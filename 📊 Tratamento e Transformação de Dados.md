# 📊 Tratamento e Transformação de Dados

Este documento detalha as transformações aplicadas aos dados recebidos pelo webhook.

---

## 🎯 Objetivo

Garantir que os dados recebidos estejam em um formato consistente, limpo e pronto para serem armazenados no banco de dados e utilizados em comunicações com o usuário.

---

## 🔄 Transformações Aplicadas

### 1️⃣ Nome Completo - Capitalização

**Entrada:** `john smith`  
**Saída:** `John Smith`

#### Implementação (JavaScript)
```javascript
const capitalize = (str) => {
  return str
    .toLowerCase()
    .split(' ')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
};

const nomeFormatado = capitalize(nome_completo);
```

#### Lógica
1. Converte a string inteira para minúsculas: `john smith`
2. Divide a string por espaços: `['john', 'smith']`
3. Para cada palavra, capitaliza a primeira letra: `['John', 'Smith']`
4. Junta novamente com espaços: `John Smith`

#### Por que?
- **Consistência:** Garante um padrão visual nos dados.
- **Profissionalismo:** Nomes capitalizados parecem mais formais em e-mails.
- **Buscas:** Facilita buscas case-insensitive no banco de dados.

---

### 2️⃣ Telefone - Limpeza com Regex

**Entrada:** `(11) 99999-9999`  
**Saída:** `11999999999`

#### Implementação (JavaScript)
```javascript
const telefoneLimpo = telefone.replace(/\D/g, '');
```

#### Explicação da Regex
- `\D` = Qualquer caractere que **não seja** um dígito (0-9)
- `g` = Global (substitui **todas** as ocorrências)

#### Transformação Passo a Passo
```
(11) 99999-9999
↓ Remove (
11) 99999-9999
↓ Remove )
11 99999-9999
↓ Remove espaço
1199999-9999
↓ Remove -
11999999999
```

#### Por que?
- **Armazenamento:** Reduz espaço no banco de dados.
- **Integração:** APIs de SMS/WhatsApp geralmente esperam apenas dígitos.
- **Validação:** Facilita validação de comprimento (11 dígitos para Brasil).
- **Consistência:** Elimina variações de formatação.

---

### 3️⃣ Data de Nascimento - Conversão de Formato

**Entrada:** `28/02/2020` (Formato Brasileiro: DD/MM/YYYY)  
**Saída:** `2020-02-28` (Formato ISO: YYYY-MM-DD)

#### Implementação (JavaScript)
```javascript
const converterData = (dataBR) => {
  const [dia, mes, ano] = dataBR.split('/');
  return `${ano}-${mes}-${dia}`;
};

const dataFormatada = converterData(data_nascimento);
```

#### Transformação Passo a Passo
```
28/02/2020
↓ Split por '/'
['28', '02', '2020']
↓ Desestrutura em [dia, mes, ano]
dia = '28', mes = '02', ano = '2020'
↓ Reconstrói em YYYY-MM-DD
2020-02-28
```

#### Por que?
- **Padrão Internacional:** ISO 8601 é o padrão global para datas.
- **Banco de Dados:** PostgreSQL armazena datas em formato ISO.
- **Ordenação:** Strings no formato YYYY-MM-DD são ordenáveis alfabeticamente.
- **Evita Ambiguidade:** 02/03/2020 pode ser 2 de março ou 3 de fevereiro dependendo da localidade.

#### Exemplo de Vantagem
```sql
-- Com formato ISO, a ordenação funciona corretamente
SELECT * FROM matriculas ORDER BY data_nascimento;
-- 2000-01-15
-- 2001-03-22
-- 2005-12-08

-- Com formato DD/MM/YYYY, a ordenação seria alfabética (incorreta)
-- 01/01/2000
-- 12/12/2005
-- 03/03/2001
```

---

## 🔗 Fluxo Completo de Transformação

```
ENTRADA (Webhook)
│
├─ nome_completo: "john smith"
├─ email: "john@4blue.com.br"
├─ telefone: "(11) 99999-9999"
├─ data_nascimento: "28/02/2020"
└─ curso: "Tech"
│
▼
CODE (JavaScript)
│
├─ capitalize(nome_completo) → "John Smith"
├─ telefone.replace(/\D/g, '') → "11999999999"
├─ converterData(data_nascimento) → "2020-02-28"
└─ email (sem transformação) → "john@4blue.com.br"
│
▼
SAÍDA (Dados Transformados)
│
├─ nome_completo: "John Smith"
├─ email: "john@4blue.com.br"
├─ telefone: "11999999999"
├─ data_nascimento: "2020-02-28"
└─ curso: "Tech"
│
▼
BANCO DE DADOS
│
INSERT INTO matriculas_tech VALUES (...)
│
▼
E-MAIL PERSONALIZADO
│
"Olá John Smith, sua matrícula no curso Tech foi recebida com sucesso!"
```

---

## ✅ Validações Implícitas

Embora não haja validações explícitas no fluxo, as transformações garantem:

| Campo | Validação Implícita |
|-------|---------------------|
| **Nome** | Sempre capitalizado (sem valores vazios) |
| **Email** | Recebido do webhook (assume-se válido) |
| **Telefone** | Apenas dígitos (fácil de validar depois) |
| **Data** | Convertida para formato ISO (fácil de validar depois) |
| **Curso** | Roteado pelo Switch (apenas Tech ou Business) |

---

## 🚀 Possíveis Melhorias Futuras

1. **Validação de Email:** Verificar se o e-mail tem formato válido.
2. **Validação de Data:** Verificar se a data é válida (ex: 31/02/2020 não existe).
3. **Validação de Telefone:** Verificar se tem exatamente 11 dígitos (Brasil).
4. **Sanitização:** Remover caracteres especiais perigosos.
5. **Normalização de Nomes:** Remover acentos ou caracteres especiais.

---

## 📝 Conclusão

O tratamento de dados implementado é simples, eficaz e segue as melhores práticas da indústria. Garante que os dados sejam consistentes, legíveis e prontos para uso em múltiplos contextos (banco de dados, e-mails, APIs externas).
