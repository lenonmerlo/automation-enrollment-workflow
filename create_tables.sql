-- Script para criar as tabelas de matrículas
-- Execute este script no PostgreSQL para criar a estrutura do banco de dados

-- Tabela para matrículas do curso Tech
CREATE TABLE IF NOT EXISTS matriculas_tech (
  id SERIAL PRIMARY KEY,
  nome_completo VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  telefone VARCHAR(20),
  data_nascimento DATE,
  curso VARCHAR(50) DEFAULT 'Tech',
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela para matrículas do curso Business
CREATE TABLE IF NOT EXISTS matriculas_biz (
  id SERIAL PRIMARY KEY,
  nome_completo VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  telefone VARCHAR(20),
  data_nascimento DATE,
  curso VARCHAR(50) DEFAULT 'Business',
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para melhorar performance nas buscas por email
CREATE INDEX IF NOT EXISTS idx_matriculas_tech_email ON matriculas_tech(email);
CREATE INDEX IF NOT EXISTS idx_matriculas_biz_email ON matriculas_biz(email);

-- Índices para melhorar performance nas buscas por data de criação
CREATE INDEX IF NOT EXISTS idx_matriculas_tech_data_criacao ON matriculas_tech(data_criacao);
CREATE INDEX IF NOT EXISTS idx_matriculas_biz_data_criacao ON matriculas_biz(data_criacao);

-- Verificar se as tabelas foram criadas
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
