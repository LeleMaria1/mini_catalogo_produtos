# Mini Catálogo de Produtos 📦

## 🚀 Acesso Rápido

Abaixo estão os links para visualizar a aplicação em execução e o código-fonte completo:

[![Acessar Produção](https://img.shields.io/badge/Acessar_Produção-00B894?style=for-the-badge&logo=rocket&logoColor=white)](https://mini-catalogo-produtos.web.app)
[![Ver Código](https://img.shields.io/badge/Ver_Código--Fonte-6C5CE7?style=for-the-badge&logo=github&logoColor=white)](https://github.com/LeleMaria1/mini_catalogo_produtos.git)

*   **Ambiente de Produção:** [https://mini-catalogo-produtos.web.app)
*   **Repositório Git:** [https://github.com/LeleMaria1/mini_catalogo_produtos.git](https://github.com/LeleMaria1/mini_catalogo_produtos.git)

---

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)

Um aplicativo Flutter completo para gerenciar um catálogo de produtos com arquitetura **MVVM**, utilizando **Provider** para gerenciamento de estado e **Firebase/Firestore** como backend.

## 🎯 Funcionalidades

- ✅ **Autenticação Simples** - Login com credenciais demo
- ✅ **Lista de Produtos** - Visualizar todos os produtos com interface moderna
- ✅ **Filtro por Categoria** - Filtrar produtos pela categoria
- ✅ **Busca de Produtos** - Procurar produtos por nome ou descrição
- ✅ **Cadastro de Produtos** - Adicionar novos produtos ao catálogo
- ✅ **Gerenciamento de Categorias** - Criar novas categorias ou usar existentes
- ✅ **Deletar Produtos** - Remover produtos do catálogo
- ✅ **Tema Moderno** - Interface limpa e intuitiva com design responsivo

## 📱 Requisitos

- Flutter 3.0.0 ou superior
- Dart 3.0.0 ou superior
- Firebase Account (para configurar o backend)

## 🚀 Instalação

### 1. Clonar o repositório
```bash
git clone https://github.com/seu-usuario/mini_catalogo_produtos.git
cd mini_catalogo_produtos
```

### 2. Instalar dependências
```bash
flutter pub get
```

### 3. Configurar Firebase

#### Para Android:
```bash
flutterfire configure --project=seu-projeto-firebase
```

#### Ou configurar manualmente:
1. Crie um projeto no [Firebase Console](https://console.firebase.google.com)
2. Copie as credenciais e atualize `lib/firebase_options.dart`

### 4. Executar o app

```bash
flutter run
```

## 🏗️ Arquitetura MVVM

```
lib/
├── main.dart                          # Entry point
├── firebase_options.dart              # Firebase configuration
│
├── models/                            # Modelos de dados
│   ├── product.dart                   # Modelo de Produto
│   └── user.dart                      # Modelo de Usuário
│
├── viewmodels/                        # ViewModels (MVVM)
│   ├── login_viewmodel.dart           # Lógica de autenticação
│   ├── products_list_viewmodel.dart   # Lógica da lista de produtos
│   └── add_product_viewmodel.dart     # Lógica de cadastro
│
├── views/
│   ├── screens/                       # Telas da aplicação
│   │   ├── login_screen.dart          # Tela de login
│   │   ├── products_list_screen.dart  # Lista de produtos
│   │   └── add_product_screen.dart    # Cadastro de produtos
│   │
│   └── widgets/                       # Widgets reutilizáveis
│       ├── product_card.dart          # Card de produto
│       ├── category_chip.dart         # Chip de categoria
│       └── custom_app_bar.dart        # AppBar customizada
│
├── services/                          # Serviços (Firebase, Auth)
│   ├── auth_service.dart              # Autenticação
│   └── firestore_service.dart         # Operações Firestore
│
├── themes/                            # Temas da aplicação
│   └── app_theme.dart                 # Tema principal
│
├── constants/                         # Constantes
│   └── app_constants.dart             # Constantes gerais
│
└── utils/                             # Utilitários
    └── app_utils.dart                 # Funções auxiliares
```

## 🔐 Credenciais Demo

Para testar o app, use as seguintes credenciais:

- **Email**: `admin@catalogo.com`
- **Senha**: `admin123`

## 📦 Dependências Principais

- **provider**: ^6.0.0 - Gerenciamento de estado
- **firebase_core**: ^2.24.0 - Core Firebase
- **cloud_firestore**: ^4.14.0 - Banco de dados em tempo real
- **firebase_auth**: ^4.17.0 - Autenticação Firebase
- **cached_network_image**: ^3.3.1 - Cache de imagens
- **intl**: ^0.19.0 - Internacionalização
- **uuid**: ^4.0.0 - Geração de IDs únicos

## 💾 Estrutura do Firestore

### Collection: `products`
```json
{
  "id": "uuid",
  "name": "Nome do Produto",
  "description": "Descrição",
  "price": 99.99,
  "category": "Categoria",
  "imageUrl": "https://...",
  "createdAt": "2024-01-01T10:00:00Z",
  "createdBy": "admin@catalogo.com"
}
```

### Collection: `users`
```json
{
  "id": "user-id",
  "email": "admin@catalogo.com",
  "name": "Admin User",
  "isAdmin": true,
  "createdAt": "2024-01-01T10:00:00Z"
}
```

## 🎨 Tema e Cores

- **Primária**: `#6C5CE7` (Roxo)
- **Secundária**: `#00B894` (Verde)
- **Acento**: `#FF7675` (Vermelho)
- **Background**: `#F8F9FA` (Cinza claro)

## 🔄 Fluxo de Autenticação

1. Usuário abre o app → **LoginScreen**
2. Insere credenciais demo
3. `LoginViewModel` valida e faz login
4. Se bem-sucedido → **ProductsListScreen**
5. Ao fazer logout → volta para **LoginScreen**

## 📝 Como Usar

### Adicionar Produto
1. Toque no botão **+** (FAB)
2. Preencha todos os campos obrigatórios
3. Selecione uma categoria ou crie uma nova
4. Toque em **Adicionar Produto**

### Filtrar Produtos
1. Toque em uma categoria nos chips
2. Os produtos são filtrados em tempo real

### Buscar Produtos
1. Digite no campo de busca
2. Os resultados são exibidos instantaneamente

### Deletar Produto
1. Toque no ícone de lixeira no card do produto
2. Confirme a exclusão

## 🧪 Testes

Para adicionar testes ao projeto:

```bash
flutter test
```

## 📱 Plataformas Suportadas

- ✅ Android
- ✅ iOS
- ✅ Web (com configuração adicional)
- ⚠️ macOS, Windows, Linux (requerem configuração)

## 🐛 Troubleshooting

### Firebase não inicializa
- Verifique `firebase_options.dart`
- Execute `flutterfire configure` novamente
- Verifique as credenciais do projeto Firebase

### Imagens não carregam
- Certifique-se de que as URLs são válidas
- Verifique a conexão de internet
- Use URLs HTTPS

### Erro de autenticação
- Verifique credenciais demo
- Limpe cache: `flutter clean`
- Reinstale dependências: `flutter pub get`

## 🤝 Contribuindo

Sinta-se livre para fazer fork, criar branches e submeter pull requests com melhorias.

## 📄 Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para detalhes.

## 👨‍💻 Autor

Desenvolvido como exemplo de arquitetura MVVM em Flutter.

## 📞 Suporte

Para dúvidas ou problemas, abra uma issue no repositório.

---

**Versão**: 1.0.0  
**Última atualização**: 2024
