# 📋 Guia de Setup - Automação de Matrículas

Este documento descreve como configurar e executar o projeto localmente.

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter os seguintes softwares instalados:

- **Docker:** [Baixar Docker Desktop](https://www.docker.com/products/docker-desktop)
- **Docker Compose:** Geralmente vem junto com o Docker Desktop
- **Git:** [Baixar Git](https://git-scm.com/)
- **Postman (opcional):** Para testar os endpoints [Baixar Postman](https://www.postman.com/downloads/)

## 🚀 Passo a Passo de Instalação

### 1. Clone o Repositório
```bash
git clone https://github.com/seu-usuario/automacao-matriculas-4blue.git
cd automacao-matriculas-4blue
```

### 2. Inicie os Containers
```bash
docker compose up -d
```

Esse comando vai subir dois containers:
- **n8n:** Disponível em `http://localhost:5678`
- **PostgreSQL:** Disponível na porta `5432`

### 3. Acesse o n8n
Abra seu navegador e vá para `http://localhost:5678`. Você será solicitado a fazer login com as credenciais padrão:
- **Usuário:** `admin`
- **Senha:** `admin123`

### 4. Importe o Workflow
1. No n8n, clique em "Import from File" ou "New Workflow".
2. Selecione o arquivo `workflow.json` (disponível neste repositório).
3. O fluxo será importado com todos os nodes configurados.

### 5. Configure as Credenciais

#### PostgreSQL
1. Clique em "Credentials" no menu superior.
2. Crie uma nova credencial de PostgreSQL com os seguintes dados:
   - **Host:** `postgres` (nome do serviço no Docker)
   - **Database:** `postgres`
   - **User:** `postgres`
   - **Password:** `postgres`
   - **Port:** `5432`

#### Gmail (para envio de e-mails)
1. Crie uma credencial do Gmail:
   - Use sua conta Gmail pessoal ou uma conta de teste.
   - Para contas com 2FA ativado, gere uma [App Password](https://myaccount.google.com/apppasswords).

### 6. Crie as Tabelas no Banco de Dados
Execute os seguintes comandos SQL no PostgreSQL:

```sql
CREATE TABLE matriculas_tech (
  id SERIAL PRIMARY KEY,
  nome_completo VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  telefone VARCHAR(20),
  data_nascimento DATE,
  curso VARCHAR(50) DEFAULT 'Tech',
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE matriculas_biz (
  id SERIAL PRIMARY KEY,
  nome_completo VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  telefone VARCHAR(20),
  data_nascimento DATE,
  curso VARCHAR(50) DEFAULT 'Business',
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 7. Teste o Fluxo
Use o Postman ou `curl` para enviar um payload de teste:

```bash
curl -X POST http://localhost:5678/webhook/test \
  -H "Content-Type: application/json" \
  -d '{
    "nome_completo": "John Smith",
    "email": "john@example.com",
    "data_nascimento": "28/02/2020",
    "telefone": "(11) 99999-9999",
    "curso": "Tech"
  }'
```

Se tudo correr bem, você verá:
- Um novo registro inserido no banco de dados.
- Um e-mail de confirmação chegando na caixa de entrada.

---

## 🛑 Parar os Containers
```bash
docker compose down
```

## 🔧 Troubleshooting

**Erro: "Connection refused" ao conectar no PostgreSQL**
- Aguarde alguns segundos após executar `docker compose up -d`, pois o PostgreSQL leva um tempo para iniciar.
- Verifique se os containers estão rodando: `docker compose ps`

**Erro: "Port 5678 already in use"**
- Mude a porta no `docker-compose.yml` para outra disponível, como `5679:5678`.

**Erro: "No such file or directory" ao importar o workflow**
- Certifique-se de que o arquivo `workflow.json` está no diretório raiz do projeto.

---

Para mais informações, consulte a [documentação oficial do n8n](https://docs.n8n.io/).
