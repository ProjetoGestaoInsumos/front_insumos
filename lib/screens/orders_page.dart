import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_search_field.dart';
import 'package:front_insumos/components/custom_pagination.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/components/orders_popup.dart';
import 'package:front_insumos/utils/colors.dart';

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

Widget _buildCell(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    ),
  );
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
                  hintText: 'Buscar',
                  width: 250,
                  borderRadius: 12,
                  icon: Icons.search,
                  onChanged: _filterOrders,
                ),

              CustomButton(
                iconData: Icons.note_add_outlined,
                text: 'Abrir POP',
                buttonColor: CustomColors.blue,
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
    scrollDirection: Axis.vertical,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Table(
        border: TableBorder(
          horizontalInside: BorderSide(
            color: Colors.grey.shade400,
            width: 1,
          ),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1.5),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(1.5),
          5: FlexColumnWidth(2),
          6: FlexColumnWidth(2),
          7: FlexColumnWidth(1.5),
        },
        children: [
          /// Cabeçalho
         TableRow(
          decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
        ),
            children: [
              for (final header in [
                'Nº PEDIDO',
                'SOLICITANTE',
                'DATA',
                'RECEITA',
                'QUANTIDADE',
                'CURSOS',
                'DETALHES',
                'STATUS',
              ])

        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
            border: Border(
            ),
          ),
          child: Center(
            child: Text(
              header,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
    ],
  ),
          /// Dados dinâmicos
          for (final order in _filteredOrders)
            TableRow(
              children: [
                _buildCell(order['Numero']!),
                _buildCell(order['Solicitante']!),
                _buildCell(order['Data']!),
                _buildCell(order['Receita']!),
                _buildCell(order['Quantidade']!),
                _buildCell(order['Cursos']!),
                _buildCell(order['Detalhes']!),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(child: _getStatusIcon(order['Status']!)),
                ),
              ],
            ),
        ],
      ),
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
