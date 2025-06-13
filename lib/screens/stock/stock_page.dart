import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/components/custom_pagination.dart';
import 'package:front_insumos/components/custom_search_field.dart';
import 'package:front_insumos/components/error_page.dart';
import 'package:front_insumos/models/item.dart';
import 'package:front_insumos/screens/stock/add_stock.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_bloc.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_event.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_state.dart';
import 'package:front_insumos/screens/stock/register_ingredient.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_bloc.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_event.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_state.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:front_insumos/utils/format.dart';

class StockPage extends StatefulWidget {
  final bool abrirPop;
  const StockPage({super.key, this.abrirPop = false});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final Set<int> _expandedItems = {};
  List<Item> _allItems = [];

  int rowsPerPage = 10;
  int currentPage = 0;
  int get totalPages =>
      (_allItems.isEmpty) ? 1 : (_allItems.length / rowsPerPage).ceil();

  List<Item> get filteredItems {
    final start = currentPage * rowsPerPage;
    final end = (_allItems.length < start + rowsPerPage)
        ? _allItems.length
        : start + rowsPerPage;
    return _allItems.sublist(start, end);
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      setState(() {
        currentPage = page;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemBloc, ItemState>(
      listener: (context, state) {
        // Quando os itens estiverem carregados, mostra o pop-up
        if (state is ItemLoaded && widget.abrirPop) {
          showAddStockDialog(context, state.items);
        }
      },
      child: BlocBuilder<ItemBloc, ItemState>(builder: (context, itemState) {
        final stockState = context.watch<StockBloc>().state;
        final itemState = context.watch<ItemBloc>().state;

        // Verifica se ambos os estados estão carregados
        if (stockState is StockLoaded && itemState is ItemLoaded) {
          final stocks = stockState.stocks;

          if (_allItems.length != itemState.items.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _allItems = List<Item>.from(itemState.items);
                currentPage = 0;
              });
            });
          }

          final filteredItems = _allItems
              .skip(currentPage * rowsPerPage)
              .take(rowsPerPage)
              .toList();

          // AGRUPA stocks por itemId
          final Map<int, List<dynamic>> groupedStocks = {};
          for (final stock in stocks) {
            groupedStocks.putIfAbsent(stock.itemId, () => []).add(stock);
          }

          final bool allExpanded =
              _expandedItems.length == filteredItems.length;

          final List<TableRow> rows = [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
              children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        allExpanded ? Icons.unfold_less : Icons.unfold_more,
                        size: 20,
                      ),
                      tooltip:
                          allExpanded ? 'Recolher todos' : 'Expandir todos',
                      onPressed: () {
                        setState(() {
                          if (allExpanded) {
                            _expandedItems.clear();
                          } else {
                            _expandedItems
                                .addAll(filteredItems.map((e) => e.id!));
                          }
                        });
                      },
                    ),
                  ),
                ),
                _buildHeaderCell('INGREDIENTE'),
                _buildHeaderCell('CATEGORIA'),
                _buildHeaderCell('UNIDADE'),
                _buildHeaderCell('LOTES'),
                _buildHeaderCell('VALIDADE'),
                _buildHeaderCell('TOTAL'),
                _buildHeaderCell('STATUS'),
              ],
            ),
          ];

          for (final item in filteredItems) {
            final itemStocks = groupedStocks[item.id] ?? [];
            final totalQuantity =
                itemStocks.fold<double>(0, (sum, s) => sum + s.quantity);
            final latestExpiration = itemStocks
                .where((s) => s.expirationDate != null)
                .map((s) => s.expirationDate!)
                .fold<DateTime?>(null,
                    (prev, e) => prev == null || e.isAfter(prev) ? e : prev);
            final status = _calculateStatus(latestExpiration);
            final isExpanded = _expandedItems.contains(item.id);

            rows.add(TableRow(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded
                            ? _expandedItems.remove(item.id)
                            : _expandedItems.add(item.id!);
                      });
                    },
                    child: Center(
                      child: Icon(
                        isExpanded ? Icons.expand_more : Icons.chevron_right,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                _buildCell(item.name),
                _buildCell(item.category.toJson()),
                _buildCell(item.unit.toJson()),
                _buildCell(itemStocks.length.toString()),
                _buildCell(latestExpiration != null
                    ? formatarData(latestExpiration.toIso8601String())
                    : '-'),
                _buildCell(
                    '${totalQuantity.toStringAsFixed(2)} ${item.unit.toJson()}'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 12, color: status.color),
                      const SizedBox(width: 4),
                      Text(status.label, style: TextStyle(color: status.color)),
                    ],
                  ),
                ),
              ],
            ));

            if (isExpanded) {
              rows.add(TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                ),
                children: List.generate(8, (_) {
                  return Container(
                    height: 4,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.1), width: 1),
                      ),
                    ),
                  );
                }),
              ));

              for (final stock in itemStocks) {
                final s = _calculateStatus(stock.expirationDate);
                rows.add(TableRow(
                  decoration:
                      BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                  children: [
                    const SizedBox(),
                    const SizedBox(),
                    const SizedBox(),
                    const SizedBox(),
                    const SizedBox(),
                    _buildCell(stock.expirationDate != null
                        ? formatarData(stock.expirationDate!.toIso8601String())
                        : '-'),
                    _buildCell(
                        '${stock.quantity.toStringAsFixed(2)} ${item.unit.toJson()}'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, size: 12, color: s.color),
                          const SizedBox(width: 4),
                          Text(s.label, style: TextStyle(color: s.color)),
                        ],
                      ),
                    ),
                  ],
                ));
              }
            }
          }

          return Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Gerenciar Estoque',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(thickness: 1, color: Colors.grey),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CustomSearchField(
                              width: 250,
                              onChanged: (value) {
                                // lógica de busca
                              },
                            ),
                            const Spacer(),
                            CustomButton(
                              text: 'Adicionar Lote',
                              iconData: Icons.inventory_2_outlined,
                              buttonColor: CustomColors.blue,
                              onPressed: () async {
                                showAddStockDialog(context, _allItems);
                              },
                            ),
                            const SizedBox(width: 12),
                            CustomButton(
                              text: 'Registrar Ingrediente',
                              iconData: Icons.add_circle_outline,
                              buttonColor: CustomColors.blue,
                              onPressed: () async {
                                showRegisterIngredientDialog(context);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Table(
                                  border: TableBorder(
                                    horizontalInside: BorderSide(
                                        color: Colors.grey.shade400, width: 1),
                                  ),
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  columnWidths: const {
                                    0: FlexColumnWidth(0.3), // ícone
                                    1: FlexColumnWidth(
                                        2), // nome do ingrediente
                                    2: FlexColumnWidth(2), // categoria
                                    3: FlexColumnWidth(1.5), // unidade
                                    4: FlexColumnWidth(1), // lotes
                                    5: FlexColumnWidth(2), // validade
                                    6: FlexColumnWidth(1.5), // total
                                    7: FlexColumnWidth(2), // status
                                  },
                                  children: rows,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: CustomPagination(
                            currentPage: currentPage,
                            totalPages: totalPages,
                            onPageChanged: goToPage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (stockState is StockError) {
          return buildError('Erro ao carregar estoque', () {
            context.read<StockBloc>().add(LoadStockEvent());
          });
        }

        if (itemState is ItemError) {
          return buildError('Erro ao carregar ingredientes', () {
            context.read<ItemBloc>().add(LoadItemEvent());
          });
        }

        // Se os blocos não estiverem carregados, exibe um indicador de carregamento
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(child: Text(text)),
    );
  }

  StatusTag _calculateStatus(DateTime? expirationDate) {
    if (expirationDate == null) return StatusTag('Sem validade', Colors.grey);
    final now = DateTime.now();
    final diff = expirationDate.difference(now).inDays;

    if (diff < 0) return StatusTag('Vencido', Colors.red);
    if (diff <= 7) return StatusTag('A vencer', Colors.orange);
    return StatusTag('Normal', Colors.green);
  }
}

class StatusTag {
  final String label;
  final Color color;
  StatusTag(this.label, this.color);
}
