import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front_insumos/layouts/main_layout.dart';
import 'package:front_insumos/screens/history_page.dart';
import 'package:front_insumos/screens/home_page.dart';
import 'package:front_insumos/screens/items_test_page.dart';
import 'package:front_insumos/screens/orders_page.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
  runApp(MyApp());
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
          bodyLarge: TextStyle(fontSize: 14), // Tamanho padrão para textos principais
          bodyMedium: TextStyle(fontSize: 14), // Tamanho padrão para textos secundários
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: CustomColors.blue, secondary: CustomColors.grey),
      ),
      initialRoute: '/', // Rota inicial
      routes: {
        '/': (context) => HomePage(),
        '/produtos': (context) =>
            ItemsTestPage(), // Rota para a página de produtos
        '/layout': (context) => MainLayout(), // Rota para o layout
        '/historico': (context) => HistoryPage(),
        '/pedidos' : (context) => OrdersPage(),
      },
    );
  }
}
