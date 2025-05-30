import 'package:flutter/material.dart';
import 'dart:math';
import 'package:front_insumos/components/custom_search_field.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageCotentState();
}

class _HistoryPageCotentState extends State<HistoryPage> {
  final List<Map<String, dynamic>> movimentacoes = List.generate(105, (index) {
    bool isEntrada = index % 2 == 0;
    return {
      'movimento': isEntrada ? 'Entrada' : 'Saída',
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

  List<Widget> paginationButtons() {
    List<Widget> buttons = [];

    void addPageButton(int page) {
      buttons.add(TextButton(
        onPressed: () => goToPage(page),
        style: TextButton.styleFrom(
          backgroundColor:
              page == currentPage ? Colors.blue : Colors.transparent,
          foregroundColor: page == currentPage ? Colors.white : Colors.blue,
        ),
        child: Text((page + 1).toString()),
      ));
    }

    if (totalPages <= 7) {
      for (int i = 0; i < totalPages; i++) {
        addPageButton(i);
      }
    } else {
      addPageButton(0);

      int startPage = max(1, currentPage - 1);
      int endPage = min(totalPages - 2, currentPage + 1);

      if (startPage > 1) {
        buttons.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("..."),
        ));
      }

      for (int i = startPage; i <= endPage; i++) {
        addPageButton(i);
      }

      if (endPage < totalPages - 2) {
        buttons.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("..."),
        ));
      }

      addPageButton(totalPages - 1);
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Histórico de movimentação',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(
            thickness: 2,
            color: Colors.black,
          ),
          const SizedBox(height: 24),
          CustomSearchField(
            width: 250,
            onChanged: (value) {
              // Atualize seu estado aqui para filtrar a tabela
            },
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Table(
              border: const TableBorder(
                horizontalInside: BorderSide(
                  color: Color.fromARGB(80, 158, 158, 158),
                  width: 1,
                ),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0E0E0),
                  ),
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton.icon(
                  onPressed:
                      currentPage > 0 ? () => goToPage(currentPage - 1) : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Anterior'),
                ),
                ...paginationButtons(),
                TextButton.icon(
                  onPressed: currentPage < totalPages - 1
                      ? () => goToPage(currentPage + 1)
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Próximo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
