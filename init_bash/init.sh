#!/bin/bash

# Definindo algumas cores personalizadas
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' 

# Função para criar a estrutura do projeto
estrutura() {
    while true; do
        read -p "Qual será o nome do projeto: " nome_project
        if [ -z "$nome_project" ]; then
            echo -e "${RED}Nome do Projeto está em branco${NC}"
            continue
        fi
        if [ -d "$nome_project" ]; then
            echo -e "${RED}Nome do Projeto já existe, entre com outro${NC}"
            continue
        fi
        break
    done

    echo -e "${BLUE}Criando a estrutura de pastas...${NC}"
    mkdir "$nome_project"
    cd "$nome_project" || exit
    echo -e "${BLUE}Inicializando o projeto Node.js${NC}"
    npm init -y

    echo -e "${BLUE}Instalando as dependências de produção${NC}"
    npm install express sequelize mysql2 dotenv

    echo -e "${BLUE}Instalando dependências de desenvolvimento${NC}"
    npm install --save-dev typescript ts-node @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint prettier eslint-config-prettier eslint-plugin-prettier nodemon jest ts-jest @types/jest supertest @types/supertest concurrently cross-env

    echo -e "${BLUE}Criando estruturas de pastas dentro do SRC ...${NC}"
    mkdir -p src/{controllers,models,routes,views/js,views/css,views/templates}

    cp ../model_templates/controllersTemplate.txt src/controllers/userControllers.ts
    cp ../model_templates/modelTemplate.txt src/models/userModel.ts
    cp ../model_templates/routesTemplate.txt src/routes/userRoutes.ts
    cp ../model_templates/cssTemplate.txt src/views/css/styles.css
    cp ../model_templates/htmlTemplate.txt src/views/templates/index.html
    cp ../model_templates/JsTemplate.txt src/views/js/index.js

    sed -i "s/NOME_DO_PROJETO/$nome_project/g" src/views/templates/index.html

    echo -e "${GREEN}Estrutura criada com sucesso!${NC}"
}

# Função para configurar e enviar para o GitHub
GitHub() {
    while true; do
        read -p "Digite seu Usuário do GitHub: " user
        read -p "Digite o e-mail cadastrado do GitHub: " email
        read -p "Digite o nome do repositório: " nome_projeto
        read -p "Cole o token gerado aqui: " token
        if [ ${#token} -ne 40 ]; then
            echo -e "${RED}Token inválido. Por favor, tente novamente.${NC}"
            continue
        fi

        response=$(curl -s -H "Authorization: token $token" -d "{\"name\":\"$nome_projeto\"}" https://api.github.com/user/repos)
        if echo "$response" | grep -q '"errors":'; then
            echo -e "${RED}Erro: Não foi possível criar o repositório. Verifique se o nome já existe e tente novamente.${NC}"
            continue
        fi

        url="https://github.com/$user/$nome_projeto.git"
        pushUrl="https://$token@github.com/$user/$nome_projeto.git"
        xdg-open "$url" &> /dev/null
        echo -e "${GREEN}Repositório criado em $url${NC}"
        break
    done

    repo_created=false
    retry_count=0
    while [ $retry_count -lt 10 ]; do
        repos=$(curl -s -H "Authorization: token $token" https://api.github.com/user/repos?per_page=100)
        if echo "$repos" | grep -q "\"full_name\": \"$user/$nome_projeto\""; then
            repo_created=true
            echo -e "${GREEN}Repositório verificado e disponível.${NC}"
            break
        else
            echo -e "${YELLOW}Aguardando o repositório estar disponível...${NC}"
            sleep 5
            retry_count=$((retry_count + 1))
        fi
    done

    if [ "$repo_created" = true ]; then
        echo "node_modules/" > .gitignore
        echo "Olá projeto $nome_projeto" > README.md
        git init
        git config user.name "$user"
        git config user.email "$email"
        git remote add origin "$pushUrl"
        git add .
        git status -s
        git commit -m "Primeiro commit"
        git push -u origin master
        echo -e "${GREEN}Script concluído com sucesso${NC}"
    else
        echo -e "${RED}Erro: Não foi possível verificar a criação do repositório.${NC}"
        exit 1
    fi
}

estrutura

read -p "Quer enviar para o GitHub? [s | n]: " TrueOrFalse 

if [ "$TrueOrFalse" = "s" ]; then
    GitHub
fi

code .
echo -e "${GREEN}Script executado com sucesso${NC}"
read -p "Pressione Enter para continuar..."
