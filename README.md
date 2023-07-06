# dev-stack

A ideia por trás do nosso modelo dev-stack é permitir que qualquer desenvolvedor execute nossos projetos de maneira comum, evitando problemas de ambiente que normalmente levam muito tempo para serem resolvidos.

A Stack é composta inicialmente por uma "dev-network", um edge router (traefik) e um dnsserver.

Antes de executar a stack, você deve desabilitar qualquer serviço em execução na porta 80 (apache, nginx, caddy, iis, etc).

Para poder executar esse ambiente de desenvolvimento, você deve instalar previamente o docker e o docker-compose.

- [Get Docker](https://docs.docker.com/get-docker/)
- [Install Docker Compose](https://docs.docker.com/compose/install/)

## Criando a dev network
Para permitir que nossos contâineres se comuniquem, precisamos criar uma rede compartilhada, então, execute o comando abaixo:

```bash
docker network create dev-network
```

## DNS Server setup
Para garantir que os projetos funcionem corretamente em seu computador, você deve configurar o servidor DSN primário para 127.0.0.1, então seu computador poderá reconhecer e redirecionar qualquer domínio "*.test" para nosso roteador.

### Linux
Algumas distribuições Linux vem com o serviço systemd-resolve ativado, você precisa desativá-lo, pois ele se vincula à porta [53], que entrará em conflito com a porta do Dnsmasq.

Execute os seguintes comandos:
```bash
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
```

Altere o arquivo resolv.conf:
```bash
ls -jh /etc/resolv.conf
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolv.conf
```

Se sua distribuição usa o NetworkManager, você deve desabilitar a configuração do dns editando o arquivo **/etc/NetworkManager/NetworkManager.conf** adicionando o parâmetro:
```console
dns=none
```

O NetworkManager.conf final deve ser:
```console
[main]
plugins=ifupdown,keyfile
dns=none

[ifupdown]
managed=false

[device]
wifi.scan-rand-mac-address=no
```

## Run the stack

Junto dessa stack há dois scripts que podem ser executados para fazer todas as instalações e configurações necessárias. Eles foram criados para rodar a stack em um ambiente Linux. Cada máquina possui configurações únicas, então esses scripts podem não se comportar como esperado em todas as situações.

O script start-dev.sh inicia a stack e configura o Dnsserver. Já o script init-project.sh faz um clone do projeto base do git inicia um container e instala um novo laravel.

### Run the stack and Painel
O script painel-start-dev.sh inicia ,stack o painel e configura o Dnsserver. Já o script painel-stop-dev.sh derruba os conteiners. 

## Standard project docker-compose file
```yaml
version: '3.2'

services:

  app:
    image: ghcr.io/mjpinto-stefanini/php80-fpm:latest
    labels:
      - traefik.http.routers.app.rule=Host(`app.stefanini.test`)
    volumes:
      - ./src:/src
    environment:
      - PROJECT_WEBROOT=/src/public
    

networks:
  default:
    external:
      name: dev-network
```