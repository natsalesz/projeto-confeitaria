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