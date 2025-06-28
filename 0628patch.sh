# 서버 재시작 스크립트 다운로드, 경로설정, 실행 권한 추가
wget https://raw.githubusercontent.com/palbungi/palworld-googlecloud/refs/heads/main/regular_maintenance.sh
sed -i "s|docker-compose.yml|/home/$(whoami)/docker-compose.yml|g" regular_maintenance.sh
chmod +x /home/$(whoami)/regular_maintenance.sh

rm 0628
