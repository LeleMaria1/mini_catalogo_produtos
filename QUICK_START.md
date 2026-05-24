# 🚀 Guia de Início Rápido

Comece a usar o Mini Catálogo de Produtos em 5 minutos!

## 📦 Instalação Rápida

```bash
# 1. Navegar para o projeto
cd c:\Projetos\mini_catalogo_produtos

# 2. Instalar dependências
flutter pub get

# 3. Executar o app
flutter run
```

## 🔐 Fazer Login

Use as credenciais demo:

```
Email: admin@catalogo.com
Senha: admin123
```

## ⚡ Primeiros Passos

### 1️⃣ Adicionar um Produto

1. Toque no botão **+** (canto inferior direito)
2. Preencha os campos:
   - **Nome**: Ex: "Notebook Dell"
   - **Descrição**: Ex: "Notebook de alta performance"
   - **Preço**: Ex: 3500.00
   - **Categoria**: Selecione "Eletrônicos" ou crie "Novo"
   - **URL da Imagem**: Cole uma URL HTTPS
3. Toque em **"Adicionar Produto"**

### 2️⃣ Filtrar Produtos

1. Na lista, veja os chips de categorias
2. Toque em uma categoria para filtrar
3. Toque em "Todos" para ver todos os produtos

### 3️⃣ Buscar Produtos

1. Use a caixa de busca
2. Digite o nome ou descrição
3. Os resultados aparecem em tempo real

### 4️⃣ Deletar Produto

1. Encontre o produto na lista
2. Toque no ícone de lixeira
3. Confirme a exclusão

### 5️⃣ Fazer Logout

1. Toque em ⋮ (três pontos) no canto superior direito
2. Selecione **"Logout"**
3. Será redirecionado para a tela de login

## 📱 URLs de Imagem Úteis

Para testes, você pode usar estas URLs:

```
https://via.placeholder.com/300x200?text=Notebook
https://via.placeholder.com/300x200?text=Smartphone
https://via.placeholder.com/300x200?text=Tablet
https://via.placeholder.com/300x200?text=Headphone
https://via.placeholder.com/300x200?text=Camera
```

## 🔥 Configurar Firebase (Próximas Etapas)

Para usar com dados reais no Firestore:

1. Veja [FIREBASE_SETUP.md](FIREBASE_SETUP.md)
2. Configure seu projeto Firebase
3. Atualize `lib/firebase_options.dart`
4. Execute `flutter run` novamente

## 🎨 Customizar Cores

Para mudar as cores do tema, edite `lib/themes/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF6C5CE7); // Roxo
static const Color secondaryColor = Color(0xFF00B894); // Verde
static const Color accentColor = Color(0xFFFF7675); // Vermelho
```

## 📚 Documentação Completa

- **[README.md](README.md)** - Visão geral do projeto
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Explicação da arquitetura MVVM
- **[FIREBASE_SETUP.md](FIREBASE_SETUP.md)** - Como configurar Firebase

## 🧪 Testar a App

### Modo Debug
```bash
flutter run
```

### Modo Release
```bash
flutter run --release
```

### Build APK (Android)
```bash
flutter build apk
```

### Build iOS
```bash
flutter build ios
```

## 🐛 Problemas Comuns

### Erro ao executar flutter run
```bash
# Limpar cache
flutter clean

# Instalar dependências novamente
flutter pub get

# Tentar novamente
flutter run
```

### Firebase não inicializa
- Verifique se `firebase_options.dart` existe
- Execute `flutterfire configure` novamente
- Verifique conexão de internet

### Imagens não carregam
- Use URLs HTTPS
- Use URLs de placeholder como sugeridas acima
- Verifique a conexão de internet

## 💡 Dicas

✨ **Tip 1**: A app já vem com dados de teste. Você pode adicionar seus próprios produtos.

✨ **Tip 2**: Use categorias para organizar seus produtos.

✨ **Tip 3**: A busca funciona em tempo real - digite para ver resultados instantaneamente.

✨ **Tip 4**: Customize o tema editando `lib/themes/app_theme.dart`.

✨ **Tip 5**: Adicione mais funcionalidades seguindo o padrão MVVM existente.

## 🚀 Próximas Etapas

Após familiarizar-se com o app:

1. ✅ Configurar Firebase com dados reais
2. ✅ Customizar cores e temas
3. ✅ Adicionar novas funcionalidades (edição de produtos, etc)
4. ✅ Implementar sistema de usuários com admin
5. ✅ Fazer deploy na Play Store / App Store

## 📞 Suporte

Para dúvidas ou problemas, consulte a documentação completa no README.md

---

**Versão**: 1.0.0  
**Última atualização**: 2024
