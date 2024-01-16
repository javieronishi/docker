docker network create onishinet //bridge
docker run --name metasploitable2 --network onishinet -d cyberacademylabs/metasploitable2
docker run --name kali --network onishinet -it kalilinux/kali-rolling bash
apt update -y
apt install kali-linux-default -y