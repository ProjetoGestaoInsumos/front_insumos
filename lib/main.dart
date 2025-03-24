import 'package:flutter/material.dart';
import 'package:front_insumos/screens/items_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Rota inicial
      routes: {
        '/': (context) => HomePage(),
        '/produtos': (context) =>
            ItemsPage(), // Rota para a página de produtos
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
                context, '/produtos'); // Navega para ProdutosPage
          },
          child: Text("Ver Produtos"),
        ),
      ),
    );
  }
}
