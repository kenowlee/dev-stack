#!/bin/bash

# Alterando as configuracoes de rede
sudo ifconfig lo:0 172.254.254.254 up
#sudo systemctl stop systemd-resolved

# Iniciando a stack de desenvolvimento
cd dev-stack
docker-compose up -d
cd ..

# Alterando o arquivo resolv.conf
linha=$(grep -n "nameserver" /etc/resolv.conf | cut -f1 -d: | tail -1)
sudo sed -i "${linha}d" /etc/resolv.conf
sudo sed -i "${linha}i nameserver 127.0.0.1" /etc/resolv.conf

# Iniciando Databases (optional)
#cd Databases
#docker-compose up -d
#cd ..

# Aqui pode ser adicionados outros containers a serem inicializados