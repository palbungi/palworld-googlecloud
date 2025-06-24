sudo timedatectl set-timezone Asia/Seoul

mkdir /home/serverfile

sudo chown -R 1001:1002 /home/serverfile

sudo chmod +x /home/serverfile

cd /home/serverfile

sudo groupadd docker
sudo usermod -aG docker $USER
sudo apt update && sudo apt -y upgrade && sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/v2.37.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

wget https://raw.githubusercontent.com/palbungi/palworld-googlecloud/refs/heads/main/docker-compose.yml

wget https://github.com/palbungi/palworld-googlecloud/raw/refs/heads/main/regular_maintenance.sh

sudo chmod +x /home/serverfile

(sudo crontab -l 2>/dev/null; echo "50 03 * * * /home/serverfile/regular_maintenance.sh") | crontab -
(sudo crontab -l 2>/dev/null; echo "50 07 * * * /home/serverfile/regular_maintenance.sh") | crontab -
(sudo crontab -l 2>/dev/null; echo "50 11 * * * /home/serverfile/regular_maintenance.sh") | crontab -
(sudo crontab -l 2>/dev/null; echo "50 15 * * * /home/serverfile/regular_maintenance.sh") | crontab -
(sudo crontab -l 2>/dev/null; echo "50 19 * * * /home/serverfile/regular_maintenance.sh") | crontab -
(sudo crontab -l 2>/dev/null; echo "50 23 * * * /home/serverfile/regular_maintenance.sh") | crontab -

echo "Installing Serverfile... Please wait 2 minute"

sudo docker-compose up -d && sleep 120

echo "Complete! Now you can join your server"
