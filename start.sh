# Instalar o Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verificar a instalação do Flutter
flutter doctor

# Instalar as dependências do Flutter
flutter pub get

# Construir o app Flutter Web
flutter build web --dart-define=BACKEND_URL=$BACKEND_URL
