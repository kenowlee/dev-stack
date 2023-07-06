#!/bin/bash

# Stop stack de desenvolvimento
cd dev-stack
docker-compose down
cd ..

# Stop Painel
cd ..
cd painel
docker-compose down
cd ..

# Aqui pode ser adicionados outros containers a serem inicializados