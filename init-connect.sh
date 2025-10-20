#!/bin/sh
echo "⏳ Esperando a Kafka Connect..."
# Espera activa hasta que la API REST de Connect responda
until curl -s http://connect:8083/connectors > /dev/null; do
  sleep 5
  echo "⌛ Kafka Connect todavía no responde en :8083..."
done

echo "📡 Creando conector JDBC Sink..."
curl -s -X PUT http://connect:8083/connectors/jdbc_sink_invoices_topic/config \
  -H "Content-Type: application/json" \
  --data-binary @/config/jdbc_sink_invoices_topic.json

echo "✅ Estado del conector:"
curl -s http://connect:8083/connectors/jdbc_sink_invoices_topic/status

