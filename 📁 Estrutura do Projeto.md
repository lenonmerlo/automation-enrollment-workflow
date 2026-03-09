# 📁 Estrutura do Projeto

```
automacao-matriculas-4blue/
│
├── docker-compose.yml          # Configuração dos containers (n8n + PostgreSQL)
├── .gitignore                  # Arquivos ignorados pelo Git
│
├── README.md                   # Documentação principal do projeto
├── SETUP.md                    # Guia de instalação e configuração
├── ESTRUTURA_PROJETO.md        # Este arquivo
│
├── workflow.json               # Fluxo do n8n exportado (importar no n8n)
│
├── docs/                       # Documentação adicional
│   ├── DESAFIO_OCULTO.md      # Explicação detalhada da prevenção de duplicidade
│   ├── TRATAMENTO_DADOS.md    # Documentação do tratamento de strings e datas
│   └── ARQUITETURA.md         # Diagrama e explicação da arquitetura
│
├── exemplos/                   # Exemplos de payloads
│   ├── payload_tech.json      # Exemplo de payload para curso Tech
│   ├── payload_biz.json       # Exemplo de payload para curso Business
│   └── postman_collection.json # Coleção do Postman para testes
│
└── sql/                        # Scripts SQL
    └── create_tables.sql      # Script para criar as tabelas no PostgreSQL
```

## 📄 Descrição dos Arquivos Principais

### `docker-compose.yml`
Define os serviços (n8n e PostgreSQL) que rodam em containers Docker. Este arquivo é essencial para reproduzir o ambiente localmente.

### `workflow.json`
Arquivo exportado do n8n contendo toda a lógica do fluxo de automação. Pode ser importado diretamente no n8n para replicar o projeto.

### `README.md`
Documentação principal com visão geral do projeto, decisões técnicas e link para o vídeo de apresentação.

### `SETUP.md`
Guia passo a passo para configurar e executar o projeto localmente, incluindo troubleshooting.

### `docs/DESAFIO_OCULTO.md`
Explicação técnica detalhada sobre como a duplicidade de matrículas foi identificada e resolvida.

### `docs/TRATAMENTO_DADOS.md`
Documentação sobre as transformações aplicadas aos dados (capitalização, regex, conversão de datas).

### `exemplos/postman_collection.json`
Coleção do Postman com exemplos de requisições para testar o fluxo sem precisar construir manualmente.

---

## 🔄 Fluxo de Trabalho Recomendado

1. **Clone o repositório**
2. **Siga o SETUP.md** para configurar o ambiente
3. **Importe o workflow.json** no n8n
4. **Use os exemplos em `exemplos/`** para testar
5. **Consulte a documentação em `docs/`** para entender a lógica

---

Para dúvidas, consulte o README.md ou o vídeo de apresentação.
