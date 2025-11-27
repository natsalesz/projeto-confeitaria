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


Documentação do Sistema de Confeitaria (Flutter) - Desenvolvimento Mobile

Membros do Grupo:
Maria Eduarda Ribeiro Padovani Loschi   CP3025811
Natasha Sales Ferreira Pinto            CP3025799
Pedro Enrico da Silva Serradilha        CP3025799

Aplicativo mobile desenvolvido em Flutter para consumir a API de confeitaria, permitindo gerenciar produtos, clientes e pedidos através de interface intuitiva.

🛠 Tecnologias Utilizadas
Frontend:
Flutter 3.35.5 - Framework mobile
Dart - Linguagem de programação
HTTP - Cliente HTTP para APIs
Provider - Gerenciamento de estado

Dependências (pubspec.yaml):
yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  provider: ^6.1.1
  intl: ^0.18.1

        
Funcionalidades do App
Telas Principais:
Produtos - Listar, criar, editar, excluir e visualizar produtos
Clientes - Listar, criar, editar e excluir clientes
Pedidos - Listar, criar, visualizar e excluir pedidos

Features:
Navegação por abas
CRUD completo para todas as entidades
Interface responsiva
Validação de formulários
Feedback visual com SnackBars
Loading states
Tratamento de erros

Passo a Passo para Executar o App
Pré-requisitos:
Flutter SDK 3.0+
Android Studio / VS Code
Emulador Android/iOS ou dispositivo físico
API rodando (passos anteriores)

1. Clonar e Configurar o Projeto:
bash
# Clonar o projeto
git clone <url-do-repositorio>
cd confeitaria_app

# Instalar dependências
flutter pub get

2. Configurar Endpoint da API:
Editar lib/services/api_service.dart:

dart
// Para emulador Android:
static const String baseUrl = 'http://10.0.2.2:5000';

// Para iOS Simulator:
// static const String baseUrl = 'http://localhost:5000';

// Para dispositivo físico (mesma rede):
// static const String baseUrl = 'http://192.168.1.100:5000';

3. Executar o App:
bash
# Verificar dispositivos disponíveis
flutter devices

# Executar no emulador/dispositivo
flutter run

4. Build para Produção:
bash
# Android
flutter build apk

# iOS
flutter build ios
🔧 Configurações Importantes

Para Dispositivo Físico:
Conectar dispositivo via USB
Habilitar modo desenvolvedor
Habilitar depuração USB
Verificar se aparece em flutter devices
Para Teste em Rede:
Verificar IP do computador: ipconfig (Windows) ou ifconfig (Linux/Mac)
Atualizar baseUrl no api_service.dart
Ambos (celular e computador) na mesma rede WiFi
