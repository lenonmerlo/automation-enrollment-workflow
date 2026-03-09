# 🛡️ O Desafio Oculto: Prevenção de Duplicidade de Matrículas

## 🔍 Identificação do Problema

Durante a análise dos requisitos do edital, identifiquei uma falha potencial grave que não foi explicitamente mencionada, mas que é crítica em qualquer sistema de automação:

**O risco de duplicidade de matrículas.**

Se o webhook recebesse o mesmo payload duas vezes (por um erro no sistema de origem, duplo clique do usuário, ou retry automático), o fluxo inseriria o aluno em duplicidade no banco de dados e enviaria múltiplos e-mails de confirmação.

---

## 💥 Cenários de Falha Potencial

### Cenário 1: Duplo Clique do Usuário
Um usuário clica no botão "Enviar Matrícula" duas vezes rapidamente, disparando o webhook duas vezes com os mesmos dados.

### Cenário 2: Retry Automático
O sistema de origem implementa uma política de retry: se não receber confirmação da primeira requisição, tenta novamente.

### Cenário 3: Erro de Rede
A primeira requisição é processada com sucesso, mas a resposta não chega ao cliente. O cliente, pensando que falhou, reenvia a requisição.

### Cenário 4: Processamento Assíncrono
Se o fluxo fosse processado de forma assíncrona sem sincronização adequada, múltiplas instâncias poderiam processar o mesmo payload simultaneamente.

---

## ✅ A Solução Implementada

Para resolver esse problema, implementei uma **trava de segurança baseada em verificação prévia** antes de qualquer inserção no banco de dados.

### Arquitetura da Solução

```
┌─────────────────────────────────────────────────────────────────┐
│                         WEBHOOK RECEBE DADOS                     │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    CODE (TRATAMENTO DE DADOS)                    │
│  - Capitaliza nome                                               │
│  - Limpa telefone com Regex                                      │
│  - Converte data DD/MM/YYYY → YYYY-MM-DD                        │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                       SWITCH (ROTEIA POR CURSO)                  │
│  - Tech → matriculas_tech                                        │
│  - Business → matriculas_biz                                     │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│              EXECUTE A SQL QUERY (VERIFICAÇÃO)                   │
│  SELECT id FROM matriculas_[curso]                              │
│  WHERE email = 'email_recebido'                                  │
│  LIMIT 1                                                         │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    IF (AVALIA O RESULTADO)                       │
└────────────────────────────┬────────────────────────────────────┘
                             │
                ┌────────────┴────────────┐
                │                         │
                ▼                         ▼
        ┌──────────────┐         ┌──────────────┐
        │ ID ENCONTRADO│         │ ID NÃO ENCONTRADO│
        │   (TRUE)     │         │    (FALSE)   │
        └──────────────┘         └──────────────┘
                │                         │
                ▼                         ▼
        ┌──────────────┐         ┌──────────────┐
        │ NO OPERATION │         │  INSERT ROW  │
        │  DO NOTHING  │         │  (Insere no  │
        │              │         │   banco)     │
        │ Fluxo encerra│         └──────────────┘
        │ silenciosamente        │
        └──────────────┘         ▼
                                ┌──────────────┐
                                │ SEND EMAIL   │
                                │(Confirmação) │
                                └──────────────┘
```

### Passo a Passo da Lógica

1. **Webhook recebe o payload** com os dados da matrícula.

2. **Code (JavaScript) trata os dados** aplicando as transformações necessárias (capitalização, limpeza, conversão de datas).

3. **Switch roteia** para a tabela correta baseado no campo `curso`.

4. **Execute a SQL Query faz uma verificação prévia:**
   ```sql
   SELECT id FROM matriculas_tech
   WHERE email = 'john@4blue.com.br'
   LIMIT 1
   ```
   - Se o e-mail já existe, a query retorna um `id` (número > 0).
   - Se o e-mail é novo, a query retorna vazio (NULL ou sem linhas).

5. **IF avalia o resultado:**
   - **TRUE (ID encontrado):** O aluno já existe no banco. O fluxo é desviado para um node `No Operation, do nothing`, encerrando silenciosamente. Nenhuma duplicata é criada, nenhum e-mail extra é enviado.
   - **FALSE (ID não encontrado):** O aluno é novo. O fluxo segue normalmente.

6. **Insert Row insere** os dados tratados na tabela correta.

7. **Send Email envia** um e-mail transacional personalizado confirmando a matrícula.

---

## 🔐 Vantagens dessa Abordagem

| Vantagem | Descrição |
|----------|-----------|
| **Simples e Robusta** | Usa apenas SQL e lógica condicional, sem complexidade desnecessária. |
| **Sem Efeitos Colaterais** | Encerramentos silenciosos não geram erros ou alertas desnecessários. |
| **Escalável** | Funciona independentemente de quantas vezes o webhook é disparado. |
| **Integridade de Dados** | Garante que cada e-mail único tenha apenas uma matrícula. |
| **Sem Spam** | Usuários não recebem múltiplos e-mails de confirmação. |
| **Auditável** | Cada tentativa de duplicidade pode ser registrada em logs se necessário. |

---

## 🧪 Teste Prático

Para validar essa solução:

1. **Primeira execução:** Envie um payload com `john@4blue.com.br`. O fluxo vai para o caminho **FALSE**, insere no banco e envia o e-mail.

2. **Segunda execução:** Envie o **mesmo payload** novamente. O fluxo vai para o caminho **TRUE**, para no `No Operation` e nenhum e-mail é enviado.

3. **Validação:** Consulte o banco de dados e confirme que há apenas **um registro** para `john@4blue.com.br`, e que você recebeu apenas **um e-mail** de confirmação.

---

## 📊 Comparação com Outras Abordagens

### ❌ Abordagem 1: Sem Verificação (Ingênua)
```
Webhook → Insert → Email
```
**Problema:** Duplicidades garantidas em caso de retries.

### ❌ Abordagem 2: Constraint UNIQUE no Banco
```
Webhook → Insert (com UNIQUE constraint) → Se erro, trata
```
**Problema:** Gera exceção no banco, mais complexo de tratar.

### ✅ Abordagem 3: Verificação Prévia (Implementada)
```
Webhook → Select (verificação) → If → Insert ou No Operation
```
**Vantagem:** Previne o erro antes de tentar inserir.

---

## 🎯 Conclusão

A implementação dessa trava de segurança demonstra não apenas conhecimento técnico, mas também **pensamento crítico** sobre edge cases e **responsabilidade** em relação à integridade dos dados.

Essa é a marca de um desenvolvedor sênior: não apenas fazer o que foi pedido, mas antecipar e resolver problemas que não foram explicitamente mencionados.
