#!/bin/bash
set -euo pipefail

# GitHub 저장소 정보
REPO_OWNER="palbungi"
REPO_NAME="palworld-googlecloud"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/$BRANCH"

# 다운로드 및 실행 함수
download_and_execute() {
  local script_name=$1
  local use_sudo=${2:-false}
  
  echo "Downloading $script_name..."
  wget -q "$BASE_URL/$script_name" -O "$script_name"
  
  if [ "$use_sudo" = true ]; then
    echo "Executing $script_name with sudo..."
    sudo bash "$script_name"
  else
    echo "Executing $script_name..."
    bash "$script_name"
  fi
  
  echo "Cleaning up $script_name..."
  rm -f "$script_name"
}

# 메인 실행
main() {
  # 1. 서버 중지
  download_and_execute "stop.sh"
  
  # 2. systemd 서비스 설정
  download_and_execute "systemd.sh" true
  
  # 3. 서버 시작
  download_and_execute "start.sh"

}

main "$@"
