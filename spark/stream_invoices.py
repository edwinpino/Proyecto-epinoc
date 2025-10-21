from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col, sum as _sum
from pyspark.sql.types import StructType, StructField, StringType, DoubleType, IntegerType

# Crear sesión Spark
spark = (
    SparkSession.builder
    .appName("InvoiceStreamByCity")
    .getOrCreate()
)

spark.sparkContext.setLogLevel("WARN")

# Esquema del payload interno
payload_schema = StructType([
    StructField("invoice_id", IntegerType()),
    StructField("customer_id", StringType()),
    StructField("amount", DoubleType()),
    StructField("city_code", StringType())
])

# Esquema del JSON completo del mensaje Kafka
message_schema = StructType([
    StructField("schema", StructType([])),  # No se usa, pero debe existir
    StructField("payload", payload_schema)
])

# Leer del tópico Kafka
df = (
    spark.readStream
    .format("kafka")
    .option("kafka.bootstrap.servers", "haproxy:9095")
    .option("subscribe", "invoices_topic")
    .option("startingOffsets", "latest")
    .load()
)

# Parsear el JSON recibido
json_df = df.selectExpr("CAST(value AS STRING) as json") \
            .select(from_json(col("json"), message_schema).alias("data"))

# Expandir los campos del payload
invoices = json_df.select("data.payload.*")

# Agregar totales por ciudad
city_totals = invoices.groupBy("city_code").agg(_sum("amount").alias("total_amount"))

# Función para escribir cada batch en Postgres
def write_to_postgres(df, epoch_id):
    df.write.jdbc(
        url="jdbc:postgresql://postgres:5432/demo",
        table="city_totals",
        mode="overwrite",  # 'overwrite' actualiza totales cada batch
        properties={
            "user": "demo",
            "password": "demo",
            "driver": "org.postgresql.Driver"
        }
    )

# Configurar y arrancar el stream
query = (
    city_totals.writeStream
    .outputMode("complete")
    .foreachBatch(write_to_postgres)
    .option("checkpointLocation", "/tmp/spark-checkpoint-city-totals")
    .start()
)

query.awaitTermination()
