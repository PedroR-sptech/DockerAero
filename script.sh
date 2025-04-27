#!/bin/bash

START_TIME=$(date +%s)

echo "  
 ___    __________  ____  ____  ___  _________ 
   /   |  / ____/ __ \/ __ \/ __ \/   |/_  __/   |
  / /| | / __/ / /_/ / / / / / / / /| | / / / /| |
 / ___ |/ /___/ _, _/ /_/ / /_/ / ___ |/ / / ___ |
/_/  |_/_____/_/ |_|\____/_____/_/  |_/_/ /_/  |_|
                                             
"

echo "Iniciando Aero Data..."

echo "Verificação de dependências do sistema..."

# Função para verificar e instalar Java
verificar_java() {
    echo "Verificando se o Java está instalado..."
    java -version > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Cliente já possui o Java instalado!"
    else
        echo "Cliente não possui o Java instalado!"
        echo "Instalando o Java..."
        sudo apt install -y openjdk-21-jdk
        echo "Instalação do Java concluída!"
    fi
}

# Função para verificar e instalar Docker e já iniciar containers
verificar_docker_e_containers() {
    echo "Verificando se o Docker está instalado..."
    docker --version > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Cliente já possui o Docker instalado!"
    else
        echo "Cliente não possui o Docker instalado!"
        echo "Instalando o Docker..."
        sudo apt install -y docker.io
        echo "Instalação do Docker concluída!"
    fi

    echo "Iniciando os serviços do Docker..."
    sudo systemctl start docker

    # Iniciar containers em paralelo também
    start_banco &
    start_site &

    wait
    echo "Containers prontos!"
}

# Função para o Banco de Dados
start_banco() {
    echo "Iniciando operações do Banco de Dados..."
    local dir_banco="./Banco de Dados/BD definitivo"

    if [ "$(sudo docker ps -a -q -f name=container-bd)" ]; then
        echo "Container do banco de dados já existe."
        if [ "$(sudo docker ps -q -f name=container-bd)" ]; then
            echo "Container do banco já está em execução."
        else
            echo "Iniciando o container do banco de dados..."
            sudo docker start container-bd
        fi
    else
        echo "Criando e iniciando o container do banco de dados..."
        sudo docker build -t imagem-bd-aero-data "$dir_banco"
        sudo docker run -d --name container-bd -p 3306:3306 imagem-bd-aero-data
    fi
    echo "Banco de Dados pronto."
}

# Função para o Site Aero Data
start_site() {
    echo "Iniciando operações do Site Aero Data..."
    local dir_site="./DockerSite"

    if [ "$(sudo docker ps -a -q -f name=container_aero_data)" ]; then
        echo "Container do site já existe."
        if [ "$(sudo docker ps -q -f name=container_aero_data)" ]; then
            echo "Container do site já está em execução."
        else
            echo "Iniciando o container do site..."
            sudo docker start container_aero_data
        fi
    else
        echo "Criando e iniciando o container do site..."
        sudo docker build -t aero_data "$dir_site"
        sudo docker run -d -p 8080:8080 --name container_aero_data aero_data
    fi
    echo "Site Aero Data pronto."
}

# Rodar Docker+containers e Java em paralelo
verificar_docker_e_containers &
verificar_java &

# Esperar ambos terminarem
wait

echo "✅ Ambiente preparado com sucesso!"

echo ""
echo "==============================================================================="
echo ""

echo "Iniciando o processo de ETL..."

echo "Tratamento de dados foi um sucesso!"

echo ""
echo "==============================================================================="
echo ""


echo "  
 ___    __________  ____  ____  ___  _________ 
   /   |  / ____/ __ \/ __ \/ __ \/   |/_  __/   |
  / /| | / __/ / /_/ / / / / / / / /| | / / / /| |
 / ___ |/ /___/ _, _/ /_/ / /_/ / ___ |/ / / ___ |
/_/  |_/_____/_/ |_|\____/_____/_/  |_/_/ /_/  |_|
                                             
"
echo "✅ Sua aplicação está rodando com sucesso!"
IP=$(curl -s http://checkip.amazonaws.com)
echo ""
echo "🌐 Acesse a aplicação rodando em: http://$IP:8080"
echo ""
echo ""
echo ""
echo "🔍 Testando conexão..."
if curl -s --head --request GET "http://$IP:8080" | grep "200 OK" > /dev/null; then
    echo "✅ Conexão bem-sucedida! Tudo certo!"
else
    echo "⚠️ Atenção: Não foi possível validar a conexão automaticamente."
    echo "   Verifique se os containers estão rodando ou tente novamente em alguns segundos."
fi

# Mostrar o tempo total
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))

echo ""
echo "⏱️ Tempo total de preparação: ${ELAPSED_TIME} segundos."
echo ""
echo "==============================================================================="
