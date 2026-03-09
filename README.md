# 🚀 Automação de Matrículas - Teste Técnico 4Blue

![n8n](https://img.shields.io/badge/n8n-FF6C37?style=for-the-badge&logo=n8n&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-323330?style=for-the-badge&logo=javascript&logoColor=F7DF1E)

Este repositório contém a solução desenvolvida para o teste técnico da vaga de **Desenvolvedor Back-end Jr (Foco em Automação/Python)** na 4Blue.

O projeto consiste em um fluxo de automação construído no **n8n** que recebe dados de matrículas via Webhook, realiza o tratamento e higienização das informações, roteia os dados com base no curso escolhido, insere os registros em um banco de dados **PostgreSQL** e envia um e-mail de confirmação personalizado.

---

## 🎥 Vídeo de Apresentação

No vídeo abaixo, demonstro o fluxo funcionando de ponta a ponta, explico as decisões técnicas tomadas e mostro como resolvi o "Desafio Oculto" de prevenção de duplicidade.

🔗 **[Clique aqui para assistir ao vídeo de apresentação](https://youtu.be/9DRFGgVsaGI)**

---

## 🏗️ Arquitetura e Decisões Técnicas

### 1. Infraestrutura Local (Docker)
Embora um ambiente em nuvem tenha sido disponibilizado, optei por subir uma infraestrutura completa localmente utilizando **Docker** (n8n + PostgreSQL). 
Essa decisão técnica foi tomada para garantir que eu pudesse demonstrar o fluxo funcionando de ponta a ponta, com inserções reais no banco de dados e envio de e-mails, provando que a lógica está 100% correta e pronta para produção, além de demonstrar domínio sobre infraestrutura e conteinerização.

### 2. Tratamento de Dados (JavaScript)
Como o n8n é nativamente construído em Node.js, a forma mais performática e nativa de tratar strings dentro da ferramenta é utilizando o node "Code" com **JavaScript**.
O tratamento realizado inclui:
- **Nome Completo:** Capitalização da primeira letra de cada palavra (ex: `john smith` → `John Smith`).
- **Telefone:** Higienização utilizando Regex para remover parênteses, espaços e traços, mantendo apenas os números (ex: `(11) 99999-9999` → `11999999999`).
- **Data de Nascimento:** Conversão do formato brasileiro `DD/MM/YYYY` para o padrão de banco de dados `YYYY-MM-DD` (ex: `28/02/2020` → `2020-02-28`).

---

## 🧩 O Fluxo de Automação

O fluxo foi desenhado para ser robusto e à prova de falhas. Ele segue as seguintes etapas:

1. **Webhook:** Recebe o payload JSON via método POST.
2. **Code (JavaScript):** Realiza a higienização e formatação dos dados recebidos.
3. **Switch:** Roteia o fluxo para caminhos diferentes com base no valor do campo `curso` ("Tech" ou "Business").
4. **Execute a SQL Query (Verificação):** Consulta o banco de dados para verificar se o e-mail recebido já existe na tabela correspondente.
5. **IF (Prevenção de Duplicidade):** Avalia o resultado da query anterior.
6. **Insert Row (PostgreSQL):** Caso o aluno seja novo, insere os dados tratados na tabela correta.
7. **Send Email (Gmail):** Envia um e-mail transacional personalizado confirmando a matrícula no curso específico.

---

## 🛡️ O Desafio Oculto: Prevenção de Duplicidade

Durante a análise dos requisitos, identifiquei uma falha potencial grave: **a duplicidade de matrículas**. 
Se o webhook recebesse o mesmo payload duas vezes (por um erro no sistema de origem ou duplo clique do usuário), o fluxo inseriria o aluno em duplicidade no banco de dados e enviaria múltiplos e-mails de confirmação.

### A Solução Implementada:
Para resolver esse problema, implementei uma trava de segurança antes da inserção no banco de dados:
1. O node `Execute a SQL query` faz um `SELECT id FROM matriculas WHERE email = 'email_recebido' LIMIT 1`.
2. O node `IF` avalia o retorno:
   - **TRUE (Aluno já existe):** Se a query retornar um ID, o fluxo é desviado para um node `No Operation, do nothing`, encerrando a execução silenciosamente. Nenhuma duplicata é criada e nenhum e-mail extra é enviado.
   - **FALSE (Aluno novo):** Se a query não retornar nada (vazio), o fluxo segue normalmente, inserindo o aluno no banco e enviando o e-mail de boas-vindas.

Essa abordagem garante a integridade dos dados e evita spam para os usuários.

---

## 🚀 Como Executar Localmente

Caso deseje testar o fluxo em sua própria máquina:

1. Clone este repositório.
2. Suba os containers utilizando o Docker Compose:
   ```bash
   docker compose up -d
   ```
3. Acesse o n8n em `http://localhost:5678`.
4. Importe o arquivo JSON do fluxo (disponível neste repositório).
5. Configure as credenciais do PostgreSQL e do Gmail.
6. Utilize o Postman para enviar o payload de teste para a URL do Webhook.

---

**Desenvolvido por Lenon Merlo**  
*Candidato à vaga de Desenvolvedor Back-end Jr na 4Blue*
