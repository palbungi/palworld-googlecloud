#!/bin/bash

# 색상 및 스타일 정의
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

# 경로 설정
CRON_FILE="/tmp/mycron"
SCRIPT_PATH="/home/$(whoami)/regular_maintenance.sh"

clear

# 제목 출력
echo -e "${CYAN}${BOLD}=============================================="
echo -e " 팰월드서버 자동 재시작 설정 프로그램"
echo -e "==============================================${NC}"
echo

# regular_maintenance.sh 유무 확인
if [ ! -f "$SCRIPT_PATH" ]; then
    echo -e "${YELLOW}regular_maintenance.sh 파일이 없어서 다운로드 중...${NC}"
    curl -o "$SCRIPT_PATH" https://raw.githubusercontent.com/palbungi/palworld-googlecloud/refs/heads/main/regular_maintenance.sh
    chmod +x "$SCRIPT_PATH"
    echo -e "${GREEN}파일 다운로드 및 실행 권한 설정 완료!${NC}"
fi

# 기존 크론 삭제
crontab -r
echo -e "${RED}기존 재시작 목록을 삭제했습니다.${NC}"
echo

# 모드 선택
while true; do
    echo -e "${BOLD}팰월드 서버 재시작 모드를 선택하세요:${NORMAL}"
    echo -e "${YELLOW}0. 팰월드 서버 재시작 안함${NC}"
    echo -e "${GREEN}1. 하루 횟수만 지정 (추천)${NC}"
    echo -e "${BLUE}2. 하루 횟수/시간 지정${NC}"
    echo
    read -p $'\033[1;36m번호 선택 (0-2): \033[0m' MODE
    echo

    if [[ "$MODE" == "0" ]]; then
        echo -e "${RED}서버 재시작 기능이 비활성화되었습니다.${NC}"
        echo -e "${YELLOW}스크립트를 종료합니다.${NC}"
        exit 0
        
    elif [[ "$MODE" == "1" ]]; then
        # 횟수 입력
        while true; do
            read -p $'\033[1;36m하루에 몇 번 재시작할까요? (숫자 입력): \033[0m' COUNT
            if [[ "$COUNT" == "0" ]]; then
                echo -e "${RED}서버 재시작 기능이 비활성화되었습니다.${NC}"
                echo -e "${YELLOW}스크립트를 종료합니다.${NC}"
                exit 0
            elif [[ "$COUNT" =~ ^[1-9][0-9]*$ ]]; then
                break
            else
                echo -e "${RED}올바른 숫자를 입력해주세요.${NC}"
            fi
        done

        # 자동 시간 계산
        INTERVAL=$((24 * 60 / COUNT))
        TIMES=()
        > "$CRON_FILE"
        for ((i=0; i<COUNT; i++)); do
            TOTAL_MINUTES=$((i * INTERVAL))
            HOUR=$((TOTAL_MINUTES / 60))
            MIN=$((TOTAL_MINUTES % 60))
            # 시간을 HH:MM 형식으로 저장
            printf -v HOUR_STR "%02d" "$HOUR"
            printf -v MIN_STR "%02d" "$MIN"
            TIME_STR="${HOUR_STR}:${MIN_STR}"
            TIMES+=("$TIME_STR")
            
            # 크론 파일에 추가
            echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> "$CRON_FILE"
            echo "$MIN_STR $HOUR_STR * * * $SCRIPT_PATH" >> "$CRON_FILE"
        done
        break

    elif [[ "$MODE" == "2" ]]; then
        # 횟수 입력
        while true; do
            read -p $'\033[1;36m하루에 몇 번 재시작할까요? (숫자 입력): \033[0m' COUNT
            if [[ "$COUNT" == "0" ]]; then
                echo -e "${RED}서버 재시작 기능이 비활성화되었습니다.${NC}"
                echo -e "${YELLOW}스크립트를 종료합니다.${NC}"
                exit 0
            elif [[ "$COUNT" =~ ^[1-9][0-9]*$ ]]; then
                break
            else
                echo -e "${RED}올바른 숫자를 입력해주세요.${NC}"
            fi
        done

        # 시간 직접 입력
        TIMES=()
        echo -e "${BOLD}${CYAN}재시작 시간을 24시간 형식(HH:MM)으로 입력해주세요:${NC}"
        for ((i=1; i<=COUNT; i++)); do
            while true; do
                read -p $'\033[1;36m'"${i}번째 실행 시간 (예: 03:00): "$'\033[0m' TIME
                # 24:00 변환 처리
                if [[ "$TIME" == "24:00" ]]; then
                    echo -e "${YELLOW}24:00은 00:00으로 변환됩니다.${NC}"
                    TIME="00:00"
                fi
                if [[ "$TIME" =~ ^([01]?[0-9]|2[0-3]):[0-5][0-9]$ || "$TIME" == "00:00" ]]; then
                    TIMES+=("$TIME")
                    break
                else
                    echo -e "${RED}올바른 시간 형식(예: 03:00)을 입력해주세요.${NC}"
                fi
            done
        done

        # 크론 파일 생성
        > "$CRON_FILE"
        for TIME in "${TIMES[@]}"; do
            HOUR=$(echo "$TIME" | cut -d':' -f1)
            MIN=$(echo "$TIME" | cut -d':' -f2)
            echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" >> "$CRON_FILE"
            echo "$MIN $HOUR * * * $SCRIPT_PATH" >> "$CRON_FILE"
        done
        break

    else
        echo -e "${RED}0, 1 또는 2를 입력해주세요.${NC}"
    fi
done

# 크론 등록
crontab "$CRON_FILE"
rm "$CRON_FILE"
sudo systemctl restart cron

# 시간 출력 (모드 1과 2 동일한 형식)
echo
echo -e "${BOLD}${CYAN}설정된 재시작 시간:${NC}"
for TIME in "${TIMES[@]}"; do
    HOUR=$(echo "$TIME" | cut -d':' -f1)
    MIN=$(echo "$TIME" | cut -d':' -f2)
    
    # 12시간제로 변환 및 오전/오후 판별
    if [[ "$HOUR" == "00" || "$HOUR" == "0" || "$HOUR" == "24" ]]; then
        DISPLAY_HOUR=12
        AMPM="오전"
        COLOR="${YELLOW}"
    elif (( HOUR < 12 )); then
        DISPLAY_HOUR=$((10#$HOUR))  # 08 같은 경우 8로 변환
        AMPM="오전"
        COLOR="${YELLOW}"
    elif [[ "$HOUR" == "12" ]]; then
        DISPLAY_HOUR=12
        AMPM="오후"
        COLOR="${GREEN}"
    else
        DISPLAY_HOUR=$((10#$HOUR - 12))
        [[ "$DISPLAY_HOUR" -eq 0 ]] && DISPLAY_HOUR=12
        AMPM="오후"
        COLOR="${GREEN}"
    fi
    
    # 분 표시 (00 형태 유지)
    echo -e "${COLOR}${AMPM} ${DISPLAY_HOUR}시 ${MIN}분${NC}"
done
