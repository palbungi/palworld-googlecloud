#!/usr/bin/bash

YAML_FILE="/home/$(whoami)/sudo docker-compose.yml"
CONTAINER_NAME="palworld"

# 10분
sudo docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_10_minutes"

# 5분
sleep 300
sudo docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_5_minutes"

# 3분
sleep 120
sudo docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_3_minutes"

# 2분
sleep 60
sudo docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_2_minutes"

# 1분
sleep 60
sudo docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_60_seconds"

# 저장
sudo docker exec -i $CONTAINER_NAME rcon-cli save

# 10초
sleep 50
sudo docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_10_seconds"

sleep 5

sudo docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_5_seconds"

sleep 1

sudo docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_4_seconds"

sleep 1

sudo docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_3_seconds"

sleep 1

sudo docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_2_seconds"

sleep 1

sudo docker exec -i ${CONTAINER_NAME} rcon-cli "Broadcast Server_will_restart_in_1_seconds"

sleep 1

# 서버 재시작
sudo docker-compose -f "${YAML_FILE}" pull
sudo docker-compose -f "${YAML_FILE}" down
sudo docker-compose -f "${YAML_FILE}" up -d
