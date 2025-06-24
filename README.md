# palworld-googlecloud
팰붕이 구글클라우드 자동구축

1. VM 인스턴스 https://console.cloud.google.com/compute/instances?authuser=3&inv=1 접속
2. SSH 연결 클릭 
3. 복붙 엔터 ```wget -O pp https://raw.githubusercontent.com/palbungi/palworld-googlecloud/refs/heads/main/autosetup.sh && bash pp```
4. 구글 클라우드 VPC네트워크 → 방화벽 → 방화벽 규칙 만들기  https://console.cloud.google.com/net-security/firewall-manager/firewall-policies/add
5. 이름 입력, 지정된 대상 태그 = 네트워크의 모든 인스턴스 클릭
6. 소스 IPv4 범위 = 0.0.0.0/0 입력
7. TCP 체크 8211,8212,25575,27015,27016 입력
8. UDP 체크 8211,8212,25575,27015,27016 입력 저장
9. 서버접속
