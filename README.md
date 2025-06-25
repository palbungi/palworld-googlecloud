# palworld-googlecloud
팰붕이 구글클라우드 자동구축

1. VM 인스턴스 생성
https://console.cloud.google.com/compute/instances

3. SSH 연결 클릭 후 아래 명령어 복사&붙여넣기 엔터

```wget -O pb https://raw.githubusercontent.com/palbungi/palworld-googlecloud/refs/heads/main/autosetup.sh && bash pb```

3. 자동으로 서버구동에 필요한 파일 다운로드 및 도커와 도커컴포즈 설치, 서버 자동점검 스크립트등이 세팅될것임

4. nano에서 서버이름, 패스워드, 서버배율 및 서버설정 완료후 컨트롤+x 누른 후 y누르고 엔터

5. 구글 클라우드 VPC네트워크 → 방화벽 → 방화벽 규칙 만들기   https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/add

6. 이름 입력, 지정된 대상 태그 = 네트워크의 모든 인스턴스 클릭

7. 소스 IPv4 범위 = 0.0.0.0/0 입력

8. TCP 체크 8211,8212,8888,25575,27015,27016 입력

9. UDP 체크 25575,27015,27016 입력 저장

10. https://서버아이피:8888 접속하여 비밀번호 지정 후 접속

11. container의 palworld로 이동해서 Start, Stop, Restart 버튼으로 서버시작, 서버종료, 서버 재시작을 컨트롤 할 수 있음
