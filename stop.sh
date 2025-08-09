# 서버 종료
YAML_FILE="/home/$(whoami)/docker-compose.yml"
CONTAINER_NAME="palworld"
docker exec -i $CONTAINER_NAME rcon-cli save
docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_5_seconds"
sleep 1
docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_4_seconds"
sleep 1
docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_3_seconds"
sleep 1
docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_2_seconds"
sleep 1
docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_1_seconds"
docker-compose -f "${YAML_FILE}" pull
docker-compose -f "${YAML_FILE}" down
