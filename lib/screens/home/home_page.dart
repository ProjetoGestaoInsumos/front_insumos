import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/screens/history/history_bloc/history_bloc.dart';
import 'package:front_insumos/screens/history/history_bloc/history_event.dart';
import 'package:front_insumos/screens/history/history_bloc/history_state.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_bloc.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_event.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_state.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_bloc.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_event.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_state.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:front_insumos/utils/format.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Emitir eventos para carregar os dados no inicializar
    context.read<ItemBloc>().add(LoadItemEvent());
    context.read<StockBloc>().add(LoadStockEvent());
    context.read<HistoryBloc>().add(FetchMovements());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Botões Mês/Ano
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ToggleButtons(
                              isSelected: [true, false],
                              onPressed: (_) {},
                              borderRadius: BorderRadius.circular(8),
                              children: const [Text('Mês'), Text('Ano')],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Cards
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildCardVencidos(context),
                              ),
                              const SizedBox(width: 50),
                              Expanded(
                                child: _buildCardPedidos(context),
                              ),
                              const SizedBox(width: 50),
                              Expanded(
                                child: _buildCardMovimentacoes(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildBottomButton(
                              context,
                              'Criar Pedido',
                              '/pedidos?abrirPop=true',
                              CustomColors.grey,
                            ),
                            const SizedBox(width: 12),
                            _buildBottomButton(
                              context,
                              'Adicionar Lote',
                              '/estoque?abrirPop=true',
                              CustomColors.blue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardVencidos(BuildContext context) {
    return BlocBuilder<StockBloc, StockState>(
      builder: (context, state) {
        if (state is StockLoading) {
          return _buildCardBase(
            title: 'Carregando estoque...',
            content: Center(child: CircularProgressIndicator()),
            buttonRoute: '/estoque',
          );
        } else if (state is StockLoaded) {
          // Filtrando os estoques vencidos
          final vencidos = state.stocks.where((stock) {
            if (stock.expirationDate == null) return false;
            return stock.expirationDate!.isBefore(DateTime.now());
          }).toList();

          // Ordenando os itens vencidos pela data de vencimento (do mais próximo para o mais distante)
          vencidos
              .sort((a, b) => a.expirationDate!.compareTo(b.expirationDate!));

          // Listando os itens vencidos com mais detalhes
          return _buildCardBase(
            title: 'Total de itens vencidos',
            content: ListView.builder(
              itemCount: vencidos.length,
              itemBuilder: (context, index) {
                final stock = vencidos[index];
                return BlocBuilder<ItemBloc, ItemState>(
                  builder: (context, itemState) {
                    if (itemState is ItemLoading) {
                      return const CircularProgressIndicator();
                    } else if (itemState is ItemLoaded) {
                      final item = itemState.items
                          .firstWhere((i) => i.id == stock.itemId);

                      // Calculando a diferença de dias para determinar o status "Vencido"
                      final diff = stock.expirationDate
                              ?.difference(DateTime.now())
                              .inDays ??
                          0;
                      final statusTag = diff < 0
                          ? StatusTag('Vencido', Colors.red)
                          : StatusTag('Válido', Colors.green);

                      // Convertendo a data de expiração para o horário local
                      final expirationDateLocal = DateFormat('dd/MM/y').format(
                          stock.expirationDate?.toLocal() ?? DateTime.now());

                      return Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              statusTag, // Exibe o status "Vencido" ou "Válido"
                              const SizedBox(height: 6),
                              Text(
                                '${item.name} - Expirou em ${expirationDateLocal.toString().split(' ')[0]}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text('Quantidade vencida: ${stock.quantity}'),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Text('Erro ao carregar itens');
                    }
                  },
                );
              },
            ),
            buttonRoute: '/estoque',
          );
        } else {
          return _buildCardBase(
            title: 'Erro ao carregar dados',
            content: Center(child: Text('Erro ao carregar dados.')),
            buttonRoute: '/estoque',
          );
        }
      },
    );
  }

  Widget _buildCardPedidos(BuildContext context) {
    return BlocBuilder<ItemBloc, ItemState>(
      builder: (context, state) {
        if (state is ItemLoading) {
          return _buildCardBase(
            title: 'Carregando pedidos...',
            content: Center(child: CircularProgressIndicator()),
            buttonRoute: '/pedidos',
          );
        } else if (state is ItemLoaded) {
          // Aqui você pode filtrar os itens de pedidos. Exemplo:
          final pedidos = state.items; // Ajuste conforme seu modelo de pedido

          return _buildCardBase(
            title: 'Últimos pedidos feitos',
            content: ListView(
              children: pedidos
                  .map((item) => Text('• ${item.name} - ${item.unit}'))
                  .toList(),
            ),
            buttonRoute: '/pedidos',
            backgroundColor: CustomColors.blue,
            textColor: Colors.white,
            buttonIsWhite: true,
          );
        } else {
          return _buildCardBase(
            title: 'Erro ao carregar pedidos',
            content: Center(child: Text('Erro ao carregar pedidos.')),
            buttonRoute: '/pedidos',
          );
        }
      },
    );
  }

  Widget _buildCardMovimentacoes(BuildContext context) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return _buildCardBase(
            title: 'Carregando movimentações...',
            content: Center(child: CircularProgressIndicator()),
            buttonRoute: '/historico',
          );
        } else if (state is HistoryLoaded) {
          // Ordenando as movimentações pela data mais próxima
          final movimentacoes = state.movements;

          // Ordena por data, do mais recente para o mais antigo
          movimentacoes.sort((a, b) => DateTime.parse(b['created_at'])
              .compareTo(DateTime.parse(a['created_at'])));

          final last10Movements = movimentacoes.take(10).toList();

          // Exibindo as movimentações
          return _buildCardBase(
            title: 'Últimas Movimentações',
            content: ListView.builder(
              itemCount: last10Movements.length,
              itemBuilder: (context, index) {
                final mov = last10Movements[index];
                final isEntrada =
                    (mov['type']?.toString().toLowerCase() == 'in');

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
                              isEntrada
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: isEntrada ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isEntrada ? 'Entrada' : 'Saída',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isEntrada ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        InfoRow(
                          label: 'Ingrediente',
                          value: '${mov['item_name'] ?? '-'}',
                        ),
                        InfoRow(
                          label: 'Quantidade',
                          value: '${mov['quantity']}',
                        ),
                        InfoRow(
                          label: 'Data',
                          value: formatarDataHora(mov['created_at']),
                        ),
                        InfoRow(
                          label: 'Responsável',
                          value: '${mov['user_name'] ?? '-'}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            buttonRoute: '/historico',
          );
        } else {
          return _buildCardBase(
            title: 'Erro ao carregar movimentações',
            content: Center(child: Text('Erro ao carregar movimentações.')),
            buttonRoute: '/historico',
          );
        }
      },
    );
  }

  Widget _buildCardBase({
    required String title,
    required Widget content,
    required String buttonRoute,
    Color backgroundColor = CustomColors.grey,
    Color textColor = Colors.black,
    bool buttonIsWhite = false,
  }) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: backgroundColor == CustomColors.grey
            ? BorderSide(color: Colors.black.withOpacity(0.1))
            : BorderSide.none,
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Expanded(child: content),
            const SizedBox(height: 12),
            CustomButton(
              onPressed: () async => {context.go(buttonRoute)},
              text: "Ver",
              buttonColor:
                  buttonIsWhite ? CustomColors.grey : CustomColors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    String label,
    String route,
    Color color,
  ) {
    return CustomButton(
      onPressed: () async => {context.go(route)},
      text: label,
      buttonColor: color,
    );
  }
}

class StatusTag extends StatelessWidget {
  final String label;
  final Color color;

  StatusTag(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
                color: Colors.black, fontFamily: 'Poppins', fontSize: 14),
          ),
        ],
      ),
    );
  }
}
