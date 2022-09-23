#!/bin/bash

# Alterando as configuracoes de rede
sudo ifconfig lo:0 172.254.254.254 up
#sudo systemctl stop systemd-resolved

# Iniciando a stack de desenvolvimento
cd dev-stack
docker-compose up -d
cd ..

# Iniciando Databases
cd Databases
docker-compose up -de
cd ..
