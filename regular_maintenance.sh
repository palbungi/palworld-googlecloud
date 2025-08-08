#!/usr/bin/bash

# 설정 변수
YAML_FILE="docker-compose.yml"
CONTAINER_NAME="palworld"
BROADCAST_CMD="rcon-cli \"Broadcast"
SAVE_CMD="rcon-cli save"
RESTART_MSG="Server_will_restart_in"
SHUTDOWN_MSG="Server_is_shutting_down_for_maintance"

# 브로드캐스트 함수
broadcast() {
    local message="$1"
    docker exec -i "$CONTAINER_NAME" rcon-cli "Broadcast $message"
}

# 카운트다운 알림 함수
countdown() {
    local time_left="$1"
    broadcast "${RESTART_MSG}_${time_left}"
}

# 서버 저장
save_server() {
    docker exec -i "$CONTAINER_NAME" $SAVE_CMD
}

# 재시작 절차 시작
echo "서버 재시작 절차를 시작합니다..."

# 10분 전 알림
countdown "10_minutes"
sleep 300  # 5분 대기

# 5분 전 알림
countdown "5_minutes"
sleep 120  # 2분 대기

# 3분 전 알림
countdown "3_minutes"
sleep 60   # 1분 대기

# 2분 전 알림
countdown "2_minutes"
sleep 60   # 1분 대기

# 1분 전 알림
countdown "60_seconds"
save_server
sleep 50   # 50초 대기

# 10초 전 알림
countdown "10_seconds"
save_server
sleep 5    # 5초 대기

# 초 단위 카운트다운
for i in {5..1}; do
    countdown "${i}_seconds"
    sleep 1
done

# 서버 종료 알림
broadcast "$SHUTDOWN_MSG"

# 최종 대기
sleep 5

# 서버 재시작
echo "서버 재시작 중..."
docker-compose -f "$YAML_FILE" pull
docker-compose -f "$YAML_FILE" down
docker-compose -f "$YAML_FILE" up -d

echo "서버 재시작 완료!"
