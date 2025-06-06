import 'package:flutter/material.dart';
import 'dart:math';
import 'package:front_insumos/components/custom_search_field.dart';
import 'package:front_insumos/components/custom_pagination.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageCotentState();
}

class _HistoryPageCotentState extends State<HistoryPage> {
  final List<Map<String, dynamic>> movimentacoes = List.generate(105, (index) {
    bool isEntrada = index % 2 == 0;
    return {
      'movimento': isEntrada ? 'Entrada' : 'Saída    ',
      'ingrediente': 'Ingrediente ${index + 1}',
      'categoria': 'Categoria ${index % 5 + 1}',
      'quantidade': (isEntrada ? 10 : -5) * (index + 1),
      'data': DateTime.now()
          .subtract(Duration(days: index))
          .toString()
          .split(' ')[0],
    };
  });

  int rowsPerPage = 10;
  int currentPage = 0;

  int get totalPages => (movimentacoes.length / rowsPerPage).ceil();

  List<Map<String, dynamic>> get currentPageItems {
    int start = currentPage * rowsPerPage;
    int end = min(start + rowsPerPage, movimentacoes.length);
    return movimentacoes.sublist(start, end);
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      setState(() {
        currentPage = page;
      });
    }
  }

Widget buildMobileList() {
  return Expanded(
    child: ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: currentPageItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final mov = currentPageItems[index];
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      mov['movimento'] == 'Entrada'
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: mov['movimento'] == 'Entrada'
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      mov['movimento'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mov['movimento'] == 'Entrada'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Ingrediente: ${mov['ingrediente']}'),
                Text('Categoria: ${mov['categoria']}'),
                Text('Quantidade: ${mov['quantidade']}'),
                Text('Data: ${mov['data']}'),
                const Text('Responsável: Admin'),
              ],
            ),
          ),
        );
      },
    ),
  );
}

  Widget buildDesktopTable(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: double.infinity,
          child: Table(
            border: TableBorder(
              horizontalInside: BorderSide(
                color: Colors.grey.shade400,
                width: 1,
              ),
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
                children: [
                  for (final header in [
                    'MOVIMENTO',
                    'INGREDIENTE',
                    'CATEGORIA',
                    'QUANTIDADE',
                    'DATA',
                    'RESPONSÁVEL',
                  ])
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          header,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
              for (var mov in currentPageItems)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              mov['movimento'] == 'Entrada'
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: mov['movimento'] == 'Entrada'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 6),
                            Text(mov['movimento']),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text(mov['ingrediente'])),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text(mov['categoria'])),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          mov['quantidade'].toString(),
                          style: TextStyle(
                            color: mov['movimento'] == 'Entrada'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text(mov['data'])),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text('Admin')),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

return Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      const SizedBox(height: 24),
      Text(
        'Histórico de movimentação',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
      const Divider(thickness: 1, color: Colors.grey),
      const SizedBox(height: 8),
      Align(
        alignment: isMobile ? Alignment.center : Alignment.centerLeft,
        child: CustomSearchField(
          width: isMobile ? double.infinity : 250,
          onChanged: (value) {
            // lógica de busca
          },
        ),
      ),
      const SizedBox(height: 20),
      isMobile ? buildMobileList() : buildDesktopTable(context),
      const SizedBox(height: 16),
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
);

  }
}