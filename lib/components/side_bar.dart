import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_popup.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const Sidebar(
      {super.key, required this.onItemSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final items = ["Home", "Estoque", "Histórico", "Pedidos", "Receitas"];
    final icons = [
      Icons.home_outlined,
      Icons.inventory_outlined,
      Icons.history_outlined,
      Icons.shopping_cart_outlined,
      Icons.menu_book_outlined
    ];
    final isCompact = MediaQuery.of(context).size.width < 1000;

    return Container(
      width: MediaQuery.of(context).size.width * 0.14,
      color: Colors.grey.shade200,
      child: Column(
        children: [
          const SizedBox(height: 40),
          if (!isCompact)
            const Text("Logo Unicesumar",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++)
                  ListTile(
                    leading: Icon(icons[i]),
                    title: isCompact
                        ? null
                        : Text(
                            items[i],
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                    selected: selectedIndex == i,
                    onTap: () => onItemSelected(i),
                  ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: isCompact
                      ? null
                      : Text(
                          "Configuração",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                  onTap: () {
                    CustomPopup.show(
                      context: context,
                      title: "Configuração",
                      content: Text("Configuração do sistema"),
                      onClose: () => Navigator.of(context).pop(),
                      showFooter: true,
                      primaryButtonLabel: "Salvar",
                      primaryButtonOnPressed: () async {
                        // Simula um atraso de 2 segundos
                        await Future.delayed(const Duration(seconds: 2));
                        // Fecha o popup após o atraso
                        Navigator.of(context).pop();
                      },
                      secondaryButtonLabel: "Cancelar",
                      secondaryButtonOnPressed: () async {
                        // Simula um atraso de 2 segundos
                        await Future.delayed(const Duration(seconds: 2));
                        // Fecha o popup após o atraso
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout_outlined),
                  title: isCompact
                      ? null
                      : Text(
                          "Sair",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
