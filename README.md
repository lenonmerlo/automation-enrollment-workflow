# 🚀 Automação de Matrículas - Teste Técnico 4Blue

![n8n](https://img.shields.io/badge/n8n-FF6C37?style=for-the-badge&logo=n8n&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-323330?style=for-the-badge&logo=javascript&logoColor=F7DF1E)

Este repositório contém a solução desenvolvida para o **teste técnico da
vaga de Desenvolvedor Back‑end Jr (Foco em Automação/Python) na 4Blue**.

A solução consiste em um fluxo automatizado criado no **n8n** que:

1.  Recebe dados de matrícula via **Webhook**
2.  Realiza **tratamento e padronização dos dados**
3.  Aplica **regras de negócio baseadas no curso escolhido**
4.  Salva os dados no **PostgreSQL**
5.  Envia um **e-mail de confirmação personalizado** ao aluno

------------------------------------------------------------------------

# 🎥 Vídeo de Demonstração

No vídeo abaixo apresento:

-   O fluxo funcionando de ponta a ponta
-   O tratamento das strings e datas
-   A solução para o **Desafio Oculto** mencionado no edital

👉 https://youtu.be/9DRFGgVsaGI

------------------------------------------------------------------------

# 📦 Arquivos Principais do Projeto

  Arquivo                         Descrição
  ------------------------------- -----------------------------------------------
  automacao-matriculas-n8n.json   Workflow exportado do n8n
  create_tables.sql               Script para criação das tabelas no PostgreSQL
  payload_tech.json               Payload de exemplo para testes
  docker-compose.yml              Container Docker para executar o n8n
  README.md                       Documentação principal
  .gitignore                      Arquivos ignorados pelo Git

Documentação adicional:

-   📁 Estrutura do Projeto
-   📊 Tratamento e Transformação de Dados
-   📋 Guia de Setup
-   🛡️ O Desafio Oculto -- Prevenção de Duplicidade

------------------------------------------------------------------------

# 🏗️ Arquitetura da Solução

Webhook → Tratamento de Dados → Switch por Curso → Verificação de
Duplicidade → Inserção no Banco → Envio de Email

Etapas:

1️⃣ **Webhook** Recebe requisição POST contendo os dados da matrícula.

2️⃣ **Code (JavaScript)** Realiza a padronização dos dados: -
Capitalização do nome - Limpeza do telefone usando Regex - Conversão da
data DD/MM/YYYY → YYYY-MM-DD

3️⃣ **Switch** Roteia o fluxo conforme o curso: - Tech → tabela
`matriculas_tech` - Business → tabela `matriculas_biz`

4️⃣ **Consulta SQL** Verifica se o e-mail já existe na tabela.

5️⃣ **IF** Impede duplicidade de matrícula.

6️⃣ **Insert** Salva o registro no banco PostgreSQL.

7️⃣ **Email** Envia confirmação personalizada ao aluno.

------------------------------------------------------------------------

# 🛡️ Desafio Oculto -- Prevenção de Duplicidade

Durante a análise do desafio identifiquei um risco comum em sistemas de
automação:

➡️ **duplicidade de registros** caso o webhook seja disparado duas
vezes.

Para evitar isso foi implementada uma validação:

SELECT id FROM matriculas\_\[curso\] WHERE email = 'email_recebido'
LIMIT 1

Se já existir registro → fluxo encerra\
Se não existir → segue para inserção

Isso garante:

-   integridade de dados
-   ausência de duplicidade
-   prevenção de envio múltiplo de e-mails

------------------------------------------------------------------------

# 🧪 Exemplo de Payload

Arquivo: payload_tech.json

{ "nome_completo": "john smith", "email": "john@4blue.com.br",
"data_nascimento": "28/02/2020", "telefone": "(11) 99999-9999", "curso":
"Tech" }

------------------------------------------------------------------------

# 🚀 Executando Localmente

Pré‑requisitos: - Docker - Git - Postman (opcional)

Subir o n8n:

docker compose up -d

Acesse:

http://localhost:5678

Credenciais: Usuário: admin\
Senha: admin123

Importe o workflow: automacao-matriculas-n8n.json

Configure as credenciais: - PostgreSQL - Gmail

Depois envie o payload para o webhook usando Postman.

------------------------------------------------------------------------

# 👨‍💻 Autor

**Lenon Merlo**\
Candidato à vaga de Desenvolvedor Back‑end Jr -- 4Blue
