#!/bin/bash

# PalServer with UE4SS systemd 서비스 설치 스크립트
wget https://github.com/Yangff/RE-UE4SS/releases/download/linux-experiment/UE4SS_0.0.0.zip
unzip UE4SS_0.0.0.zip -d "/home/$(whoami)/"
chmod +x libUE4SS.so
rm UE4SS_0.0.0.zip

# root 권한 확인
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Try: sudo $0"
  exit 1
fi

# 사용자 정보 가져오기
CURRENT_USER=$(logname 2>/dev/null || echo "${SUDO_USER:-$(whoami)}")
USER_HOME=$(eval echo "~$CURRENT_USER")

# 경로 설정
UE4SS_LIB="$USER_HOME/libUE4SS.so"
PALSERVER_BIN="$USER_HOME/palworld/Pal/Binaries/Linux/PalServer-Linux-Shipping"

# 파일 존재 여부 확인
if [ ! -f "$UE4SS_LIB" ]; then
  echo "Error: UE4SS library not found at $UE4SS_LIB"
  exit 1
fi

if [ ! -f "$PALSERVER_BIN" ]; then
  echo "Error: PalServer binary not found at $PALSERVER_BIN"
  exit 1
fi

# 서비스 이름 설정
SERVICE_NAME="palworld-ue4ss"

# 서비스 파일 경로
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

# 서비스 파일 생성
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=PalWorld Server with UE4SS Modding
After=network.target

[Service]
Type=simple
User=$CURRENT_USER
Group=$CURRENT_USER
Environment="LD_PRELOAD=$UE4SS_LIB"
WorkingDirectory=$(dirname "$PALSERVER_BIN")
ExecStart=$PALSERVER_BIN
Restart=on-failure
RestartSec=30s
KillSignal=SIGINT
TimeoutStopSec=60
StandardOutput=journal
StandardError=journal
SyslogIdentifier=$SERVICE_NAME

# 리소스 제한 (선택 사항)
# MemoryLimit=24G
# CPUQuota=400%

# 보안 옵션
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=full
ProtectHome=read-only
ProtectKernelTunables=yes
ProtectKernelModules=yes
ProtectControlGroups=yes
RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6
RestrictRealtime=yes
MemoryDenyWriteExecute=yes
LockPersonality=yes

[Install]
WantedBy=multi-user.target
EOF

# 서비스 활성화 및 시작
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl start "$SERVICE_NAME"
