#!/bin/bash

# Clona o Base Project do git na pasta com o nome do projeto
echo "Nome do Projeto:"
read PROJECT

if [ -d "$PROJECT" ]; then
    echo "O diretório '$PROJECT' já existe. Não é possível criar um projeto em um diretório existente."
else
    git clone git@github.com:mjpinto-stefanini/base.git $PROJECT

    # Remove git file
    cd $PROJECT
    rm -rf .git

    # Levanta o container do projeto
    docker-compose up -d --build

    # Cria um projeto Laravel dentro do container
    docker-compose exec app composer create-project laravel/laravel .
fi