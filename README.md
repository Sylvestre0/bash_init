# Projeto de Criação Automática de Estrutura Node.js com Integração ao GitHub

Este script Bash foi desenvolvido para automatizar a criação de um projeto Node.js, configurando a estrutura de diretórios e arquivos, instalando dependências essenciais, e oferecendo a opção de configurar um repositório Git no GitHub, além de fazer o push inicial dos arquivos.

## Funcionalidades

- **Criação de Estrutura de Pastas e Arquivos:** Gera automaticamente a estrutura de pastas (`src`, `controllers`, `models`, `routes`, `views`) e cria arquivos base para um projeto Node.js usando TypeScript e Express.
- **Instalação de Dependências:** Instala pacotes essenciais como `express`, `typescript`, `sequelize`, entre outros.
- **Configuração do Git e Integração com GitHub:** Permite ao usuário configurar o repositório local com Git, criar um repositório no GitHub, e fazer o primeiro commit e push dos arquivos.

## Requisitos

- **Node.js:** Certifique-se de ter o Node.js instalado na sua máquina.
- **Git:** Necessário para a integração com o GitHub.
- **cURL:** Usado para interagir com a API do GitHub.
- **Conta no GitHub:** Para criar o repositório e fazer o push.

## Como Usar

1. **Execute o Script:**

   Execute o script `init.sh` (ou qualquer que seja o nome do arquivo) via terminal:

   ```bash
   bash projeto.sh
