import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:go_router/go_router.dart';
//import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> itensVencidos = [
    {"nome": "Leite", "validade": "07/04/2025"},
  ];

  final List<String> ultimosPedidos = ["Farinha", "Leite", "Ovo", "Tomate"];

  final List<Map<String, dynamic>> ultimasMovimentacoes = [
    {"nome": "Ovo", "tipo": "saida"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Column(
        children: [
          // Barra superior

          // Conteúdo
          Expanded(
            child: Row(
              children: [
                // Menu lateral

                // Painel principal
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
                              Expanded(child: _buildCardVencidos(context)),
                              const SizedBox(width: 50),
                              Expanded(child: _buildCardPedidos(context)),
                              const SizedBox(width: 50),
                              Expanded(child: _buildCardMovimentacoes(context)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Botões inferiores
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

  // Widget _buildDrawerItem(BuildContext context, String title, IconData icon, String route) {
  //   final bool isSelected = {};

  //   return Container(
  //     color: isSelected ? const Color(0xFF4A84C0) : Colors.transparent,
  //     child: ListTile(
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  //       title: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             title,
  //             style: TextStyle(
  //               color: isSelected ? Colors.white : Colors.black87,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           Icon(
  //             icon,
  //             color: isSelected ? Colors.white : Colors.black54,
  //           ),
  //         ],
  //       ),
  //       onTap: () => {},
  //     ),
  //   );
  // }

  Widget _buildCardVencidos(BuildContext context) {
    return _buildCardBase(
      title: 'Total de itens vencidos',
      content: ListView.builder(
        itemCount: itensVencidos.length,
        itemBuilder: (context, index) {
          final item = itensVencidos[index];
          return Row(
            children: [
              Text("• ${item['nome']} V:${item['validade']}"),
              const SizedBox(width: 5),
              const Icon(Icons.circle, size: 10, color: Colors.red),
            ],
          );
        },
      ),
      buttonRoute: '/estoque',
    );
  }

  Widget _buildCardPedidos(BuildContext context) {
    return _buildCardBase(
      title: 'Últimos pedidos feitos',
      content: ListView(
        children: ultimosPedidos
            .map((e) =>
                Text('• $e', style: const TextStyle(color: Colors.white)))
            .toList(),
      ),
      buttonRoute: '/pedidos',
      backgroundColor: const Color(0xFF2E6FA4),
      textColor: Colors.white,
      buttonIsWhite: true,
    );
  }

  Widget _buildCardMovimentacoes(BuildContext context) {
    return _buildCardBase(
      title: 'Últimas Movimentações',
      content: ListView(
        children: ultimasMovimentacoes.map((e) {
          return Row(
            children: [
              const Text('•', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 4),
              Text(e['nome']),
            ],
          );
        }).toList(),
      ),
      buttonRoute: '/historico',
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
            ? BorderSide(
                color: Colors.black.withOpacity(0.1)) // borda preta fraca
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
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
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
