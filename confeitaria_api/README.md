Documentação do Sistema de Confeitaria (API) - LP4

Membros do Grupo:
Maria Eduarda Ribeiro Padovani Loschi   CP3025811
Natasha Sales Ferreira Pinto            CP3025799

Descrição do Projeto:
API REST desenvolvida em Flask para gerenciar um sistema de confeitaria, permitindo o CRUD completo de produtos, clientes e pedidos.

🛠 Tecnologias Utilizadas
Backend:
Python 3.9.13
Flask - Framework web
MySQL - Banco de dados
Flask-CORS - Habilitar CORS
PyMySQL - Conector MySQL
python-dotenv - Gerenciamento de variáveis de ambiente

Dependências (requirements.txt):
txt
Flask==2.3.3
Flask-CORS==4.0.0
PyMySQL==1.1.0
python-dotenv==1.0.0
mysql-connector-python==8.1.0
cryptography==41.0.7


Endpoints da API
PRODUTOS
GET /produtos - Listar todos os produtos
Response:
json
[
  {
    "id": 1,
    "nome": "Bolo de Chocolate Belga",
    "descricao": "Bolo artesanal com chocolate belga premium",
    "preco": 89.9,
    "categoria": "bolo",
    "img_url": "https://exemplo.com/bolo-chocolate.jpg",
    "estoque": 8,
    "data_criacao": "2024-01-15T10:30:00"
  }
]
POST /produtos - Criar produto
Body:
json
{
  "nome": "Bolo de Morango",
  "descricao": "Bolo com recheio de morango fresco",
  "preco": 75.5,
  "categoria": "bolo",
  "img_url": "https://exemplo.com/bolo-morango.jpg",
  "estoque": 12
}
PUT /produtos/{id} - Atualizar produto
Body:
json
{
  "nome": "Bolo de Chocolate Premium",
  "preco": 95.0,
  "estoque": 6
}
DELETE /produtos/{id} - Excluir produto

CLIENTES
GET /clientes - Listar todos os clientes
Response:
json
[
  {
    "id": 1,
    "nome": "Ana Silva",
    "email": "ana.silva@email.com",
    "telefone": "(11) 99999-1111",
    "data_criacao": "2024-01-15T10:30:00"
  }
]
POST /clientes - Criar cliente
Body:
json
{
  "nome": "João Santos",
  "email": "joao@email.com",
  "telefone": "(11) 98888-2222"
}

PEDIDOS
GET /pedidos - Listar todos os pedidos
Response:
json
[
  {
    "id": 1,
    "cliente_id": 1,
    "data_pedido": "2024-01-15T14:30:00",
    "valor_total": 165.4,
    "status": "confirmado",
    "itens": [
      {
        "id": 1,
        "produto_id": 1,
        "quantidade": 1,
        "preco_unitario": 89.9,
        "produto_nome": "Bolo de Chocolate Belga"
      }
    ]
  }
]
POST /pedidos - Criar pedido
Body:
json
{
  "cliente_id": 1,
  "itens": [
    {
      "produto_id": 1,
      "quantidade": 2,
      "preco_unitario": 89.9
    }
  ]
}


!!!!!!!!!!!!!!!!!!!!
Passo a Passo para Executar a API
Pré-requisitos:
Python 3.8+
MySQL Server
Git

1. Clonar e Configurar o Projeto:
cd confeitaria_api

# Criar ambiente virtual
python -m venv venv

# Ativar ambiente virtual
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate

# Instalar dependências
pip install -r requirements.txt

2. Configurar Banco de Dados:
sql
-- Conectar ao MySQL e executar:
CREATE DATABASE confeitaria_db;

USE confeitaria_db;

-- Executar o script SQL com todas as CREATE TABLE
-- (disponível no arquivo database_schema.sql)

3. Configurar Variáveis de Ambiente:
Criar arquivo .env:

env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD= altera a senha!!!!!!
DB_NAME=confeitaria_db

4. Executar a API:
bash
python app.py

5. Testar a API:
Acesse: http://localhost:5000/produtos