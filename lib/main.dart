import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/api/api_service.dart';
import 'package:front_insumos/layouts/main_layout.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_event.dart';
import 'package:front_insumos/screens/history_page.dart';
import 'package:front_insumos/screens/home_page.dart';
import 'package:front_insumos/screens/items_test_page.dart';
import 'package:front_insumos/screens/auth/login_page.dart';
import 'package:front_insumos/screens/orders_page.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
  final apiService = ApiService();

  runApp(
    BlocProvider(
      create: (context) =>
          AuthBloc(apiService: apiService)..add(CheckAuthEvent()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestão de Insumos',
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          bodyLarge:
              TextStyle(fontSize: 14), // Tamanho padrão para textos principais
          bodyMedium:
              TextStyle(fontSize: 14), // Tamanho padrão para textos secundários
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: CustomColors.blue, secondary: CustomColors.grey),
      ),
      initialRoute: '/', // Rota inicial
      routes: {
        '/': (context) => MainLayout(),
        '/produtos': (context) =>
            ItemsTestPage(), // Rota para a página de produtos
        '/layout': (context) => MainLayout(), // Rota para o layout
        '/historico': (context) => HistoryPage(),
        '/login': (context) => LoginPage(),
        '/pedidos' : (context) => OrdersPage(),
      },
    );
  }
}
