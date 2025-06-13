import 'package:flutter/material.dart';
import 'package:front_insumos/screens/orders/orders_bloc/order_bloc.dart';
import 'package:front_insumos/screens/orders/orders_bloc/order_event.dart';
import 'package:front_insumos/screens/orders/orders_bloc/order_state.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/components/custom_search_field.dart';
import 'package:front_insumos/components/custom_pagination.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/screens/orders/orders_popup.dart';
import 'package:front_insumos/utils/colors.dart';
import '/api/api_service.dart';

class OrdersPage extends StatefulWidget {
  final bool abrirPop;
  const OrdersPage({super.key, this.abrirPop = false});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late final POPBloc _popBloc;

  @override
  void initState() {
    super.initState();
    _popBloc = POPBloc(ApiService());
    _popBloc.add(LoadPOPs());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.abrirPop) {
        showOrderPopup(context);
      }
    });
  }

  @override
  void dispose() {
    _popBloc.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _popBloc.add(SearchPOPs(query));
  }

  void _onPageChanged(int page) {
    _popBloc.add(ChangePage(page));
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
      case 'cancelado':
        return const Icon(Icons.close, color: Colors.red, size: 24);
      case 'aprovado':
        return const Icon(Icons.check, color: Colors.green, size: 24);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<POPBloc>(
      create: (_) => _popBloc,
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
                child: BlocBuilder<POPBloc, POPState>(
                  builder: (context, state) {
                    if (state is POPLoading || state is POPInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is POPError) {
                      return Center(child: Text(state.message));
                    } else if (state is POPLoaded) {
                      final pops = state.paginatedPOPs;

                      if (pops.isEmpty) {
                        return const Center(child: Text('Nenhum POP encontrado.'));
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
                                    'Nº POP',
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
                              for (final pop in pops)
                                TableRow(
                                  children: [
                                    _buildCell(pop.id.toString()),           
                                    _buildCell(pop.docenteNome),             
                                    _buildCell(DateFormat('dd/MM/yyyy').format(pop.date)), 
                                    _buildCell(pop.recipeName),              
                                    _buildCell(pop.nStudents.toString()),    
                                    _buildCell(pop.curso),                   
                                    _buildCell('Ver Pedido'),                

                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      child: Center(child: _getStatusIcon(pop.status.name)),
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
                child: BlocBuilder<POPBloc, POPState>(
                  builder: (context, state) {
                    if (state is POPLoaded) {
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
