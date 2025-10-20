# Crear topic sin underscore
podman exec -it kafka1 bash -lc \
  "kafka-topics --create --if-not-exists --topic invoices_topic \
   --partitions 3 --replication-factor 3 --bootstrap-server kafka1:29092"

# Enviar sin modo interactivo
cat invoices_topic.jsonl | podman exec -i kafka1 bash -lc \
  "kafka-console-producer --bootstrap-server kafka1:29092 --topic invoices_topic"
