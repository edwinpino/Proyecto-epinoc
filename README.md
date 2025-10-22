#Escenario de Implementación
![alt text](image-1.png)



chmod +x start_service.sh 
chmod +x producer/producer.sh 

podman network prune -f

./start_service.sh

verificación de la base de datos:
http://localhost:8081/browser/
      PGADMIN_DEFAULT_EMAIL: admin@example.com
      PGADMIN_DEFAULT_PASSWORD: admin123
Adicionar la base de datos en el pgadmin, máquina "postgres"
      POSTGRES_DB: demo
      POSTGRES_USER: demo
      POSTGRES_PASSWORD: demo 

listar topics:
podman exec -it kafka1 kafka-topics --list --bootstrap-server localhost:9092

Producir mensajes por comando:

