#!/bin/bash

YAML_FILE="/home/$(whoami)/docker-compose.yml"
CONFIG_FILE="/home/$(whoami)/config.env"
MAINTENANCE_SCRIPT="/home/$(whoami)/regular_maintenance.sh"
TIMER_SCRIPT="/home/$(whoami)/timer.sh"

# Step 0: Save and stop the server
docker exec -i palworld rcon-cli save
sleep 5
docker-compose -f "${YAML_FILE}" pull
docker-compose -f "${YAML_FILE}" down

# Step 1: Check and update admin password
if grep -q "ADMIN_PASSWORD=adminpasswd" "${CONFIG_FILE}"; then
    echo "운영자 비밀번호를 입력하세요:"
    read -s NEW_PASSWORD
    sed -i "s/ADMIN_PASSWORD=adminpasswd/ADMIN_PASSWORD=${NEW_PASSWORD}/" "${CONFIG_FILE}"
fi

# Step 3: Clear existing crontab
crontab -r
echo "기존 팰월드서버 재시작 목록을 삭제했습니다."

# Step 4: Prompt for restart option
echo "0. 팰월드서버 재시작 안함"
echo "1. 하루 횟수만 지정 (자동 시간 계산)"
echo "2. 하루 횟수와 시간 지정"
read -p "번호를 선택하세요: " OPTION

if [ "$OPTION" == "0" ]; then
    echo "스크립트를 종료합니다."
    exit 0
fi

CRON_CONTENT="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [ "$OPTION" == "1" ]; then
    read -p "하루에 몇번 실행할까요? (0 입력시 종료): " COUNT
    if [ "$COUNT" == "0" ]; then
        echo "스크립트를 종료합니다."
        exit 0
    fi
    INTERVAL=$((24 / COUNT))
    for ((i=0; i<COUNT; i++)); do
        HOUR=$((i * INTERVAL))
        CRON_CONTENT+="
0 ${HOUR} * * * ${MAINTENANCE_SCRIPT}"
    done
elif [ "$OPTION" == "2" ]; then
    read -p "하루에 몇번 실행할까요? (0 입력시 종료): " COUNT
    if [ "$COUNT" == "0" ]; then
        echo "스크립트를 종료합니다."
        exit 0
    fi
    for ((i=1; i<=COUNT; i++)); do
        read -p "${i}번째 실행 시간을 입력하세요 (0~24): " HOUR
        if [ "$HOUR" == "24" ]; then
            HOUR="0"
        fi
        CRON_CONTENT+="
0 ${HOUR} * * * ${MAINTENANCE_SCRIPT}"
    done
fi

# Register crontab
echo -e "${CRON_CONTENT}" | crontab -

# Step 9: Download timer.sh if not exists
if [ ! -f "${TIMER_SCRIPT}" ]; then
    curl -o "${TIMER_SCRIPT}" https://raw.githubusercontent.com/palbungi/palworld-googlecloud/refs/heads/main/timer.sh
    chmod +x "${TIMER_SCRIPT}"
fi

# Step 10: Restart server
docker-compose -f "${YAML_FILE}" up -d
echo "팰월드서버가 재시작 됩니다."
echo "팰월드서버 재시작 목록이 성공적으로 설정되었습니다."
echo "앞으로는 팰월드서버 재시작 목록 편집시  ./timer.sh   입력 후 엔터."




# Step 11: Delete 0731.sh if exists
if [ -f "/home/$(whoami)/0731.sh" ]; then
    rm "/home/$(whoami)/0731.sh"
fi
