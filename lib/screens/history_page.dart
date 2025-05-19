import 'package:flutter/material.dart';
import 'package:front_insumos/components/side_bar.dart';
import 'package:front_insumos/components/top_bar.dart';
import 'dart:math';
import 'package:front_insumos/screens/home_page.dart';
import 'package:front_insumos/components/custom_search_field.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryLayoutState();
}

class _HistoryLayoutState extends State<HistoryPage> {
  int selectedPage = 2;

  final List<Widget> pages = [
    HomePage(),
    HomePage(),
    HistoryPageContent(),
    HomePage(),
    HomePage(),
  ];

  void onItemSelected(int index) {
    setState(() {
      selectedPage = index;
    });
    Navigator.of(context).pop(); // Fecha o drawer no mobile
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          appBar: isDesktop
              ? null
              : AppBar(
                  title: const Text("Histórico"),
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
          drawer: isDesktop
              ? null
              : Drawer(
                  child: Sidebar(
                    selectedIndex: selectedPage,
                    onItemSelected: onItemSelected,
                  ),
                ),
          body: isDesktop
              ? Row(
                  children: [
                    Sidebar(
                      selectedIndex: selectedPage,
                      onItemSelected: onItemSelected,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const TopBar(),
                          Expanded(child: pages[selectedPage]),
                        ],
                      ),
                    ),
                  ],
                )
              : pages[selectedPage],
        );
      },
    );
  }
}

class HistoryPageContent extends StatefulWidget {
  const HistoryPageContent({super.key});

  @override
  State<HistoryPageContent> createState() => _HistoryPageContentState();
}

class _HistoryPageContentState extends State<HistoryPageContent> {
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
          Expanded(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: DataTableTheme(
                  data: DataTableThemeData(
                  headingRowColor:
                     WidgetStateProperty.all(Colors.grey[200]),

                  dataRowMinHeight: 56,
dataRowMaxHeight: 56,

                  headingRowHeight: 56,
                  ),
                  child: DataTable(
                    border: const TableBorder(
                      horizontalInside: BorderSide(
                        color: Color.fromARGB(80, 158, 158, 158),
                        width: 1,
                      ),
                      top: BorderSide.none,
                      bottom: BorderSide.none,
                      left: BorderSide.none,
                      right: BorderSide.none,
                      verticalInside: BorderSide.none,
                    ),
                    columns: [
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Center(child: Text('MOVIMENTO')),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Center(child: Text('INGREDIENTE')),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Center(child: Text('CATEGORIA')),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Center(child: Text('QUANTIDADE')),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Center(child: Text('DATA')),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Center(child: Text('RESPONSÁVEL')),
                        ),
                      ),
                    ],
                    rows: currentPageItems.map((mov) {
                      bool isEntrada = mov['movimento'] == 'Entrada';
                      return DataRow(
                        cells: [
                          DataCell(Row(
                            children: [
                              Icon(
                                isEntrada
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: isEntrada ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 6),
                              Text(mov['movimento']),
                            ],
                          )),
                          DataCell(Text(mov['ingrediente'])),
                          DataCell(Text(mov['categoria'])),
                          DataCell(Text(
                            mov['quantidade'].toString(),
                            style: TextStyle(
                              color: isEntrada ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          DataCell(Text(mov['data'])),
                          const DataCell(Text('Admin')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: currentPage > 0
                            ? () => goToPage(currentPage - 1)
                            : null,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
