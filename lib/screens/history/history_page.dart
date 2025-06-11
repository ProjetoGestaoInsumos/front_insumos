import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:front_insumos/components/custom_search_field.dart';
import 'package:front_insumos/components/custom_pagination.dart';
import 'package:front_insumos/screens/history/history_bloc/history_bloc.dart';
import 'package:front_insumos/screens/history/history_bloc/history_state.dart';
import 'package:front_insumos/utils/format.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HistoryPageContent();
  }
}

class HistoryPageContent extends StatefulWidget {
  const HistoryPageContent({super.key});

  @override
  State<HistoryPageContent> createState() => _HistoryPageContentState();
}

class _HistoryPageContentState extends State<HistoryPageContent> {
  List<Map<String, dynamic>> allMovements = [];
  List<Map<String, dynamic>> filteredMovements = [];
  int rowsPerPage = 10;
  int currentPage = 0;

  int get totalPages => (filteredMovements.length / rowsPerPage).ceil();

  List<Map<String, dynamic>> get currentPageItems {
    int start = currentPage * rowsPerPage;
    int end = min(start + rowsPerPage, filteredMovements.length);
    return filteredMovements.sublist(start, end);
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      setState(() {
        currentPage = page;
      });
    }
  }

  void searchMovements(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMovements = List<Map<String, dynamic>>.from(allMovements);
      } else {
        filteredMovements = allMovements
            .where((mov) => (mov['item_name'] ?? '')
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
      currentPage = 0;
    });
  }

  Widget buildMobileList() {
    if (filteredMovements.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'Nenhum registro encontrado',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: currentPageItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final mov = currentPageItems[index];
          final isEntrada = (mov['type']?.toString().toLowerCase() == 'in');

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
                        isEntrada ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isEntrada ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isEntrada ? 'Entrada' : 'Saída',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isEntrada ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Ingrediente: ${mov['item_name'] ?? '-'}'),
                  Text('Quantidade: ${mov['quantity']}'),
                  Text('Data: ${formatarDataHora(mov['created_at'])}'),
                  Text('Responsável: ${mov['user_name'] ?? '-'}'),
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
        child: Column(
          children: [
            Table(
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
                if (filteredMovements.isEmpty)
                  TableRow(
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: index == 2
                              ? const Text(
                                  'Nenhum registro encontrado',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                )
                              : const Text(''),
                        ),
                      ),
                    ),
                  )
                else
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
                                  (mov['type']?.toString().toLowerCase() == 'in')
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  color: (mov['type']?.toString().toLowerCase() == 'in')
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 6),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    (mov['type']?.toString().toLowerCase() == 'in')
                                        ? 'Entrada'
                                        : 'Saída',
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: Text(mov['item_name'] ?? '-')),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(
                              mov['quantity'].toString(),
                              style: TextStyle(
                                color: (mov['type']?.toString().toLowerCase() == 'in')
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: Text(formatarDataHora(mov['created_at'])),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: Text(mov['user_name'] ?? '-')),
                        ),
                      ],
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

    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HistoryError) {
          return Center(child: Text(state.message));
        }

if (state is HistoryLoaded) {
  allMovements = state.movements;

  // Só redefine os filtrados se estiver vazio (primeira carga)
  if (filteredMovements.isEmpty) {
    filteredMovements = List<Map<String, dynamic>>.from(allMovements);
  }


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
                    onChanged: searchMovements,
                  ),
                ),
                const SizedBox(height: 20),
                isMobile ? buildMobileList() : buildDesktopTable(context),
                const SizedBox(height: 16),
                if (filteredMovements.isNotEmpty)
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

        return const SizedBox();
      },
    );
  }
}