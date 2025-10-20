FROM confluentinc/cp-kafka-connect:7.5.0

# Instalar el conector JDBC desde Confluent Hub
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:latest

# Descargar el driver JDBC de PostgreSQL si no está presente
RUN cd /usr/share/confluent-hub-components/confluentinc-kafka-connect-jdbc/lib && \
    curl -LO https://jdbc.postgresql.org/download/postgresql-42.7.4.jar

# Asegurar que Connect encuentre los plugins
ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components"

