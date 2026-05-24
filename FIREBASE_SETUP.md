# 🔥 Configuração do Firebase

Este documento descreve como configurar o Firebase para o projeto Mini Catálogo de Produtos.

## 📋 Pré-requisitos

- Conta Google ativa
- Acesso ao [Firebase Console](https://console.firebase.google.com)
- Flutter CLI instalado

## 🚀 Passo a Passo

### 1. Criar Projeto no Firebase Console

1. Acesse [Firebase Console](https://console.firebase.google.com)
2. Clique em **"Adicionar projeto"**
3. Digite o nome: `mini-catalogo-produtos`
4. Siga as etapas de criação
5. Aguarde a criação ser concluída (pode levar alguns minutos)

### 2. Adicionar Aplicativo

#### Para Android:

1. No Firebase Console, clique em **"Adicionar aplicativo"** → **"Android"**
2. Preencha o Package Name: `com.example.mini_catalogo_produtos`
3. Deixe o apelido como sugerido
4. Baixe o arquivo `google-services.json`
5. Coloque em: `android/app/google-services.json`
6. Siga as instruções para atualizar `build.gradle`

#### Para iOS:

1. No Firebase Console, clique em **"Adicionar aplicativo"** → **"iOS"**
2. Preencha o Bundle ID: `com.example.miniCatalogoProdutos`
3. Deixe o apelido como sugerido
4. Baixe o arquivo `GoogleService-Info.plist`
5. Abra `ios/Runner.xcworkspace` no Xcode
6. Adicione o arquivo via drag-and-drop

### 3. Habilitar Autenticação

1. No Firebase Console, vá para **"Authentication"**
2. Clique em **"Get started"**
3. Selecione **"Anonymous"** (ou outro método desejado)
4. Clique em **"Enable"**

### 4. Criar Banco de Dados Firestore

1. No Firebase Console, vá para **"Firestore Database"**
2. Clique em **"Create database"**
3. Selecione a localização (ex: `nam5 (us-central)`)
4. Escolha **"Start in test mode"** para desenvolvimento
   - ⚠️ **Nota**: Em produção, configure regras de segurança apropriadas

### 5. Configurar Regras de Firestore

No Firebase Console → **"Firestore Database"** → **"Rules"**, adicione:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Public read access for products
    match /products/{document=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // User data access
    match /users/{uid} {
      allow read: if request.auth.uid == uid;
      allow write: if request.auth.uid == uid;
    }
  }
}
```

### 6. Usar FlutterFire CLI (Automático)

A forma mais fácil é usar o FlutterFire CLI:

```bash
# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar o projeto
flutterfire configure
```

Este comando atualizará automaticamente `firebase_options.dart` com suas credenciais.

### 7. Configurar Manualmente (Se necessário)

Se o FlutterFire CLI não funcionou:

1. No Firebase Console, clique no ícone de engrenagem → **"Configurações do projeto"**
2. Vá para **"Suas aplicações"**
3. Copie as credenciais do seu aplicativo
4. Atualize `lib/firebase_options.dart` com os valores corretos:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'COLE_SUA_API_KEY_AQUI',
  appId: 'COLE_SEU_APP_ID_AQUI',
  messagingSenderId: 'COLE_SEU_SENDER_ID_AQUI',
  projectId: 'mini-catalogo-produtos',
  storageBucket: 'mini-catalogo-produtos.appspot.com',
);
```

## 📱 Testar a Conexão

```bash
flutter clean
flutter pub get
flutter run
```

Se tudo estiver correto:
- O app iniciará sem erros
- Será possível fazer login
- Os produtos aparecerão (se houver algum no Firestore)

## 📊 Adicionar Dados de Teste

1. No Firebase Console, vá para **"Firestore Database"**
2. Clique em **"+ Start collection"**
3. Nome da collection: `products`
4. Clique em **"Auto ID"** para criar um documento
5. Adicione os seguintes campos:

```json
{
  "name": "Notebook",
  "description": "Notebook de alta performance",
  "price": 3500.00,
  "category": "Eletrônicos",
  "imageUrl": "https://via.placeholder.com/300x200?text=Notebook",
  "createdAt": "2024-01-01T10:00:00Z",
  "createdBy": "admin@catalogo.com"
}
```

## 🔒 Regras de Segurança para Produção

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      // Usuários autenticados podem ler
      allow read: if request.auth != null;
      // Apenas admins podem escrever
      allow write: if request.auth != null && 
                      request.auth.token.admin == true;
    }
    
    match /users/{userId} {
      // Usuários podem ler/escrever seus próprios dados
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

## 🚨 Troubleshooting

### Erro: "FirebaseOptions not initialized"
- Execute `flutterfire configure` novamente
- Verifique se `firebase_options.dart` foi criado corretamente

### Erro: "Project 'mini-catalogo-produtos' does not exist"
- Verifique o `projectId` em `firebase_options.dart`
- Certifique-se de que o projeto foi criado no Firebase Console

### Erro: "Permission denied: missing or insufficient permissions"
- Verifique as regras de Firestore
- Use "Start in test mode" para testes
- Configure regras apropriadas para produção

### Imagens não carregam
- Use URLs HTTPS
- Certifique-se de que o servidor de imagens é acessível
- Use URLs de placeholder como `https://via.placeholder.com`

## 📚 Recursos Úteis

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire](https://firebase.flutter.dev/)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)

## ✅ Checklist Final

- [ ] Projeto criado no Firebase Console
- [ ] Google Services configurado (Android/iOS)
- [ ] Autenticação habilitada
- [ ] Firestore Database criado
- [ ] Regras de segurança configuradas
- [ ] `firebase_options.dart` atualizado
- [ ] Testes de conexão bem-sucedidos
- [ ] Dados de teste adicionados

---

**Versão**: 1.0.0  
**Data**: 2024
