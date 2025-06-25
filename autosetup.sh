# 한국시간 설정
sudo timedatectl set-timezone Asia/Seoul

# 도커&도커컴포즈 설치
sudo groupadd docker
sudo usermod -aG docker $(whoami)
sudo apt update && sudo apt -y upgrade && sudo apt install -y nano && sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && yes | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/v2.37.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 팰월드 도커 및 서버 재시작 스크립트 다운로드
wget https://raw.githubusercontent.com/palbungi/palworld-googlecloud/refs/heads/main/docker-compose.yml
wget https://raw.githubusercontent.com/palbungi/palworld-googlecloud/refs/heads/main/regular_maintenance.sh

# 서버 재시작 스크립트에 실행 권한 추가
chmod +x /home/$(whoami)/regular_maintenance.sh

# 서버 재시작 예약(10분전 알림 후 재시작 하므로 3:50, 7:50, 11:50, 15:50, 19:50, 23:50에 각각 등록)
(crontab -l 2>/dev/null; echo "50 03 * * * /home/$(whoami)/regular_maintenance.sh") | crontab -
(crontab -l 2>/dev/null; echo "50 07 * * * /home/$(whoami)/regular_maintenance.sh") | crontab -
(crontab -l 2>/dev/null; echo "50 11 * * * /home/$(whoami)/regular_maintenance.sh") | crontab -
(crontab -l 2>/dev/null; echo "50 15 * * * /home/$(whoami)/regular_maintenance.sh") | crontab -
(crontab -l 2>/dev/null; echo "50 19 * * * /home/$(whoami)/regular_maintenance.sh") | crontab -
(crontab -l 2>/dev/null; echo "50 23 * * * /home/$(whoami)/regular_maintenance.sh") | crontab -

# 서버 디렉토리 생성 및 설정파일 다운로드(Engine.ini 최적화, GameUserSettings.ini 서버저장 디렉토리 지정)
mkdir -p /home/$(whoami)/palworld/Pal/Saved/Config/LinuxServer
wget -P /home/$(whoami)/palworld/Pal/Saved/Config/LinuxServer https://raw.githubusercontent.com/palbungi/palworld-googlecloud/refs/heads/main/Engine.ini
wget -P /home/$(whoami)/palworld/Pal/Saved/Config/LinuxServer https://raw.githubusercontent.com/palbungi/palworld-googlecloud/refs/heads/main/GameUserSettings.ini

# Portainer 설치 및 실행(웹에서 서버관리)
mkdir /home/$(whoami)/portainer
wget -P /home/$(whoami)/portainer https://github.com/palbungi/palworld-googlecloud/raw/refs/heads/main/portainer/docker-compose.yml
sudo docker-compose -f /home/$(whoami)/portainer/docker-compose.yml up -d

# 서버 시작
sudo docker-compose -f /home/$(whoami)/docker-compose.yml up -d && sleep 120

# 서버 종료
sudo docker-compose -f /home/$(whoami)/docker-compose.yml down

# 설치파일 삭제
rm pb
