#!/usr/bin/env bash
set -euo pipefail

BROKER="haproxy:9095"
TOPIC="invoices_topic"

echo "🚀 Iniciando productor kcat hacia ${BROKER} / topic=${TOPIC}"

# Esperar a que HAProxy esté accesible
until nc -z -v -w 2 haproxy 9095 >/dev/null 2>&1; do
  echo "⏳ Esperando a que HAProxy esté disponible..."
  sleep 3
done

echo "✅ HAProxy disponible, enviando mensajes..."

# Contador de mensajes
COUNTER=1

# Bucle infinito generando mensajes JSON aleatorios
while true; do
  # Generar datos aleatorios
  invoice_id=$((RANDOM % 10000 + 1))
  customer_id=$(shuf -e "Edwin" "Claudia" "Mariana" "Carlos" "Ana" "Luis" "Maria" "Pedro" "Sofia" -n1)
  amount=$(awk -v min=10 -v max=200 'BEGIN{srand(); printf("%.2f", min+rand()*(max-min))}')

  # Armar mensaje JSON
  json_msg=$(cat <<EOF
{"schema":{"type":"struct","fields":[{"field":"invoice_id","type":"int32"},{"field":"customer_id","type":"string"},{"field":"amount","type":"double"}]},"payload":{"invoice_id":${invoice_id},"customer_id":"${customer_id}","amount":${amount}}}
EOF
)

  # Enviar el mensaje
  echo "${json_msg}" | kcat -P -b "${BROKER}" -t "${TOPIC}" -p 0 || {
    echo "⚠️ Error al enviar mensaje a ${BROKER}. Reintentando..."
    sleep 2
    continue
  }

  echo "📤 (${COUNTER}) Enviado: invoice_id=${invoice_id}, customer_id=${customer_id}, amount=${amount}"
  COUNTER=$((COUNTER + 1))
  sleep 2
done
