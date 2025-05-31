import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_search_field.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<Map<String, String>> _allOrders = [
    {
      'numero': '01',
      'solicitante': 'Chef Ana',
      'data': '20/05/2025',
      'receita': 'Macarrão Carbonara',
      'ingrediente': 'Queijo Parmesão',
      'quantidade': '2',
      'unidade': 'Kg',
      'status': '✅'
    },
    {
      'numero': '02',
      'solicitante': 'Chef Bruno',
      'data': '21/05/2025',
      'receita': 'Risoto de Cogumelos',
      'ingrediente': 'Arroz Arbório',
      'quantidade': '5',
      'unidade': 'Kg',
      'status': '😐'
    },
    {
      'numero': '03',
      'solicitante': 'Chef Carla',
      'data': '22/05/2025',
      'receita': 'Tiramisu',
      'ingrediente': 'Café',
      'quantidade': '1',
      'unidade': 'Litro',
      'status': '❌'
    },
  ];

  List<Map<String, String>> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _filteredOrders = List.from(_allOrders);
  }

void _filterOrders(String query) {
  setState(() {
    final search = query.toLowerCase().replaceAll(RegExp(r'[-\\]'), '/');
    _filteredOrders = _allOrders.where((order) {
      final numero = order['numero']!.toLowerCase();
      final solicitante = order['solicitante']!.toLowerCase();
      final data = order['data']!.toLowerCase().replaceAll(RegExp(r'[-\\]'), '/');
      return numero.contains(search) || solicitante.contains(search) || data.contains(search);
    }).toList();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Linha de busca e botão
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomSearchField(
                  hintText: 'Buscar por Número, Nome ou Data',
                  width: 350,
                  borderRadius: 12,
                  icon: Icons.search,
                  onChanged: _filterOrders,
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_open),
                  label: const Text('Abrir POP'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Tabela de pedidos
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Nº Pedido')),
                    DataColumn(label: Text('Solicitante')),
                    DataColumn(label: Text('Data')),
                    DataColumn(label: Text('Receita')),
                    DataColumn(label: Text('Ingrediente')),
                    DataColumn(label: Text('Quantidade')),
                    DataColumn(label: Text('Unidade')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: _filteredOrders.map((order) {
                    return DataRow(cells: [
                      DataCell(Text(order['numero']!)),
                      DataCell(Text(order['solicitante']!)),
                      DataCell(Text(order['data']!)),
                      DataCell(Text(order['receita']!)),
                      DataCell(Text(order['ingrediente']!)),
                      DataCell(Text(order['quantidade']!)),
                      DataCell(Text(order['unidade']!)),
                      DataCell(Text(order['status']!, style: const TextStyle(fontSize: 18))),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Paginação (placeholder por enquanto)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back_ios)),
                TextButton(onPressed: () {}, child: const Text('1', style: TextStyle(fontWeight: FontWeight.bold))),
                TextButton(onPressed: () {}, child: const Text('2')),
                const Text('...'),
                TextButton(onPressed: () {}, child: const Text('68')),
                IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
