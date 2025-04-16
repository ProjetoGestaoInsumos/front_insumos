import 'package:flutter/material.dart';
import 'package:front_insumos/layouts/main_layout.dart';
import 'package:front_insumos/screens/home_page.dart';
import 'package:front_insumos/screens/items_test_page.dart';
import 'package:front_insumos/utils/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestão de Insumos',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: CustomColors.blue, secondary: CustomColors.grey),
      ),
      initialRoute: '/', // Rota inicial
      routes: {
        '/': (context) => HomePage(),
        '/produtos': (context) =>
            ItemsTestPage(), // Rota para a página de produtos
        '/layout': (context) => MainLayout(), // Rota para o layout
      },
    );
  }
}
