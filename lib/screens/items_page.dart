import 'package:flutter/material.dart';
import 'package:front_insumos/api/api_service.dart';

class ItemsPage extends StatefulWidget {
  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ItemsPage> {
  final ApiService apiService = ApiService();
  List produtos = [];

  @override
  void initState() {
    super.initState();
    carregarProdutos();
  }

  void carregarProdutos() async {
    List dados = await apiService.fetchProdutos();
    setState(() {
      produtos = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Produtos")),
      body: produtos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                var produto = produtos[index];
                return ListTile(
                  title: Text(produto["name"]),
                  subtitle: Text(produto["description"] ?? "Sem descrição"),
                );
              },
            ),
    );
  }
}
