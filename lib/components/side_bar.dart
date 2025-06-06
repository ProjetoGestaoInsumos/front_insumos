import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front_insumos/components/custom_popup.dart';
import 'package:front_insumos/utils/colors.dart';

class Sidebar extends StatefulWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const Sidebar({
    Key? key,
    required this.onItemSelected,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int? _hoveredIndex;

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
            ClipRect(
              child: Align(
                alignment: Alignment.center,
                heightFactor:
                    0.5, // ajuste para recortar a parte de cima e baixo
                child: SvgPicture.asset(
                  'images/unicesumar-logo.svg',
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: List.generate(items.length, (i) {
                final bool isSelected = widget.selectedIndex == i;
                final bool isHovered = _hoveredIndex == i;

                Color iconColor;
                Color textColor;

                if (isSelected) {
                  iconColor = CustomColors.blue;
                  textColor = CustomColors.blue;
                } else if (isHovered) {
                  iconColor = Colors.black;
                  textColor = Colors.black;
                } else {
                  iconColor = Colors.black;
                  textColor = Colors.black;
                }

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _hoveredIndex = i),
                  onExit: (_) => setState(() => _hoveredIndex = null),
                  child: GestureDetector(
                    onTap: () => widget.onItemSelected(i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: (isSelected || isHovered)
                            ? Colors.grey[300]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(icons[i], color: iconColor),
                          if (!isCompact) ...[
                            const SizedBox(width: 10),
                            Text(
                              items[i],
                              style: TextStyle(fontSize: 16, color: textColor),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                _sidebarActionItem(
                  icon: Icons.settings_outlined,
                  label: "Configuração",
                  onTap: () {
                    CustomPopup.show(
                      context: context,
                      title: "Configuração",
                      content: const Text("Configuração do sistema"),
                      onClose: () => Navigator.of(context).pop(),
                      showFooter: true,
                      primaryButtonLabel: "Salvar",
                      primaryButtonOnPressed: () async {
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.of(context).pop();
                      },
                      secondaryButtonLabel: "Cancelar",
                      secondaryButtonOnPressed: () async {
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  isCompact: isCompact,
                  hoverKey: 100,
                ),
                _sidebarActionItem(
                  icon: Icons.logout_outlined,
                  label: "Sair",
                  onTap: () {},
                  isCompact: isCompact,
                  hoverKey: 101,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isCompact,
    required int hoverKey,
  }) {
    final bool isHovered = _hoveredIndex == hoverKey;
    Color iconColor = isHovered ? Colors.black : Colors.black;
    Color textColor = isHovered ? Colors.black : Colors.black;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredIndex = hoverKey),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isHovered ? Colors.grey[300] : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              if (!isCompact) ...[
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
