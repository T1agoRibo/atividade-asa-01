#!/bin/bash

SERVICO=$1
ACAO=$2

start_service() {
    echo "Iniciando o serviço $SERVICO."

    docker build -t $SERVICO ./$SERVICO
    
    if [ $SERVICO == "dns" ]; then
        docker run -d -p 8053:53/udp -p 8053:53/tcp --name $SERVICO $SERVICO
    fi

    if [ $SERVICO == "web" ]; then
        docker run -d -p 80:80/tcp --name $SERVICO $SERVICO
    fi

    if [ $? -eq 0 ]; then
        echo "Serviço $SERVICO iniciado com sucesso."
    else
        echo "Falha ao iniciar o serviço $SERVICO."
    fi
}

stop_service() {
    echo "Parando o serviço $SERVICO."

    docker stop $SERVICO && docker rm $SERVICO
    docker rmi $SERVICO

    if [ $? -eq 0 ]; then
        echo "Serviço $SERVICO parado e removido com sucesso."
    else
        echo "Falha ao parar o serviço $SERVICO."
    fi
}

case "$ACAO" in
    start)
        start_service
        ;;
    stop)
        stop_service
        ;;
    *)
        echo "Ação inválida: $ACAO"
        echo "Ações disponíveis: start, stop"
        exit 1
        ;;
esac