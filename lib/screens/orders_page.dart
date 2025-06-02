import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_search_field.dart';
import 'package:front_insumos/components/custom_pagination.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/components/orders_popup.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
    int rowsPerPage = 10;
    int currentPage = 0;

    int get totalPages => (/*_allOrders.length*/100 / rowsPerPage).ceil();
  final List<Map<String, String>> _allOrders = [
    {
      'Numero': '01',
      'Solicitante': 'Chef Ana',
      'Data': '20/05/2025',
      'Receita': 'Macarrão Carbonara',
      'Quantidade': '2',
      'Cursos': 'Kg',
      'Detalhes': 'Ver Pedido',
      'Status': 'Pendente'
    },
    {
      'Numero': '02',
      'Solicitante': 'Chef Bruno',
      'Data': '21/05/2025',
      'Receita': 'Risoto de Cogumelos',
      'Quantidade': '5',
      'Cursos': 'Kg',
      'Detalhes': 'Ver Pedido',
      'Status': 'INDeferido'
    },
    {
      'Numero': '03',
      'Solicitante': 'Chef Carla',
      'Data': '22/05/2025',
      'Receita': 'Tiramisu',
      'Quantidade': '1',
      'Cursos': 'Litro',
      'Detalhes': 'Ver Pedido',
      'Status': 'Deferido'
    },
  ];

  List<Map<String, String>> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _filteredOrders = List.from(_allOrders);
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      setState(() {
        currentPage = page;
      });
    }
  }

  void _filterOrders(String query) {
    setState(() {
      final search = query.toLowerCase().replaceAll(RegExp(r'[-\\]'), '/');
      _filteredOrders = _allOrders.where((order) {
        final numero = order['Numero']!.toLowerCase();
        final solicitante = order['Solicitante']!.toLowerCase();
        final data = order['Data']!.toLowerCase().replaceAll(RegExp(r'[-\\]'), '/');
        return numero.contains(search) || solicitante.contains(search) || data.contains(search);
      }).toList();
    });
  }

  Widget _getStatusIcon(String status) {
  switch (status.toLowerCase()) {
    case 'pendente':
      return const Icon(Icons.pending_outlined, color: Colors.orange, size: 24);
    case 'indeferido':
      return const Icon(Icons.close, color: Colors.red, size: 24);
    case 'deferido':
      return const Icon(Icons.check, color: Colors.green, size: 24); 
    default:
      return const Icon(Icons.help_outline, color: Colors.grey);
  }
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

              CustomButton(
                iconData: Icons.note_add_outlined,
                text: 'Abrir POP',
                buttonColor: Color(0xFF4A83A7),
                onPressed: () async {
                  showOrderPopup(context);
                },
              ),

              ],
            ),
            const SizedBox(height: 20),
            // Tabela de pedidos
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(headingRowColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                 return Colors.grey[300]; 
                 },
              ),
                  border: TableBorder(
                  horizontalInside: BorderSide(width: 1, color: Colors.grey.shade400),
              ),
                  columns: const [
                    DataColumn(label: Text('Nº Pedido', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Solicitante',style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Data',style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Receita',style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Quantidade',style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Cursos',style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Detalhes',style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status',style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: _filteredOrders.map((order) {
                    final status = order['Status']!;
                    return DataRow(cells: [
                      DataCell(Text(order['Numero']!)),
                      DataCell(Text(order['Solicitante']!)),
                      DataCell(Text(order['Data']!)),
                      DataCell(Text(order['Receita']!)),
                      DataCell(Text(order['Quantidade']!)),
                      DataCell(Text(order['Cursos']!)),
                      DataCell(Text(order['Detalhes']!)),
                      DataCell(Center(child: _getStatusIcon(status)),
                    )]);
                  }).toList(),
                ),
              ),
            ),
            Align(
                    alignment: Alignment.centerRight,
                    child: CustomPagination(
                    currentPage: currentPage,
                    totalPages: totalPages,
                    onPageChanged: goToPage,
                            ),
                    ),
          ],
        ),
      ),
    );
  }
}
