import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/components/custom_search_field.dart';
import 'package:front_insumos/components/custom_pagination.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/screens/orders/orders_popup.dart';
import 'package:front_insumos/utils/colors.dart';
import 'reponse_orders_bloc/order_bloc.dart';
import 'reponse_orders_bloc/order_event.dart';
import 'reponse_orders_bloc/order_state.dart';
import '/api/api_service.dart';

class OrdersPage extends StatefulWidget {
  final bool abrirPop;
  const OrdersPage({super.key, this.abrirPop = false});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late final OrderBloc _orderBloc;

  @override
  void initState() {
    super.initState();
    _orderBloc = OrderBloc(ApiService());
    _orderBloc.add(LoadOrders());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.abrirPop) {
        showOrderPopup(context);
      }
    });
  }

  @override
  void dispose() {
    _orderBloc.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _orderBloc.add(SearchOrders(query));
  }

  void _onPageChanged(int page) {
    _orderBloc.add(ChangePage(page));
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
    return BlocProvider<OrderBloc>(
      create: (_) => _orderBloc,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                'Pedidos',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomSearchField(
                    width: 250,
                    borderRadius: 12,
                    onChanged: _onSearchChanged,
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
              Expanded(
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    if (state is OrderLoading || state is OrderInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OrderError) {
                      return Center(child: Text(state.message));
                    } else if (state is OrderLoaded) {
                      final orders = state.paginatedOrders;

                      if (orders.isEmpty) {
                        return const Center(child: Text('Nenhum pedido encontrado.'));
                      }

                      return SingleChildScrollView(
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
                              // Header
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

                              // Data rows
                              for (final order in orders)
                                TableRow(
                                  children: [
                                    _buildCell(order.id.toString()),           // 'numero' → order.id
                                    _buildCell(order.docenteNome),             // 'solicitante' → order.docenteNome
                                    _buildCell(DateFormat('dd/MM/yyyy').format(order.date)), // formata para "13/06/2025" 
                                    _buildCell(order.recipeName),               // 'receita' → order.recipeName
                                    _buildCell(order.nStudents.toString()),    // 'quantidade' → order.nStudents
                                    _buildCell(order.curso),                    // 'cursos' → order.curso
                                    _buildCell('Ver Pedido'),                   // 'detalhes' → static string or use order.details if exists

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      child: Center(child: _getStatusIcon(order.status)),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    if (state is OrderLoaded) {
                      return CustomPagination(
                        currentPage: state.currentPage,
                        totalPages: state.totalPages,
                        onPageChanged: _onPageChanged,
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
