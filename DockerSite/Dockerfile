# Usa a imagem oficial do Node.js
FROM node:latest

# Instala o Git dentro do container (necessário para o clone)
RUN apt-get update && apt-get install -y git

# Define o diretório de trabalho dentro do container
WORKDIR /usr/src/app

# Clona o repositório diretamente no container
RUN git clone https://github.com/AeroData01/Projeto-AeroData.git

# Define o diretório de trabalho para a pasta onde está o código (caso necessário)
WORKDIR /usr/src/app/Projeto-AeroData/web-data-viz

# Cria o arquivo .env com as variáveis
RUN echo "AMBIENTE_PROCESSO=producao\n\
DB_HOST=localhost\n\
DB_DATABASE=aerodata\n\
DB_USER=admin\n\
DB_PASSWORD=urubu100\n\
DB_PORT=3306\n\
APP_PORT=8080\n\
APP_HOST=localhost" > /usr/src/app/Projeto-AeroData/web-data-viz/.env

# Instala as dependências do projeto
RUN npm install

# Exponha a porta usada pela aplicação
EXPOSE 8080

# Define o comando padrão para iniciar a aplicação
CMD ["npm", "run", "dev"]
