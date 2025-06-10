import 'package:flutter/material.dart';
import 'package:front_insumos/utils/colors.dart';

class CustomPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const CustomPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  List<Widget> _buildPaginationButtons(bool isMobile) {
    List<Widget> buttons = [];

    void addPageButton(int page) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: SizedBox(
            height: isMobile ? 36 : 40,
            child: TextButton(
              onPressed: () => onPageChanged(page),
              style: TextButton.styleFrom(
                backgroundColor:
                    page == currentPage ? CustomColors.blue : Colors.transparent,
                foregroundColor:
                    page == currentPage ? Colors.white : CustomColors.blue,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 12,
                  vertical: isMobile ? 6 : 10,
                ),
                minimumSize: const Size(36, 36),
              ),
              child: Text((page + 1).toString()),
            ),
          ),
        ),
      );
    }

    Widget ellipsis() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "...",
            style: TextStyle(fontSize: isMobile ? 16 : 18),
          ),
        ),
      );
    }

    if (totalPages <= 7) {
      for (int i = 0; i < totalPages; i++) {
        addPageButton(i);
      }
    } else {
      addPageButton(0);

      int startPage = (currentPage - 1).clamp(1, totalPages - 2);
      int endPage = (currentPage + 1).clamp(1, totalPages - 2);

      if (startPage > 1) buttons.add(ellipsis());

      for (int i = startPage; i <= endPage; i++) {
        addPageButton(i);
      }

      if (endPage < totalPages - 2) buttons.add(ellipsis());

      addPageButton(totalPages - 1);
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      // Mobile version (já ok)
      return Container(
        margin: const EdgeInsets.only(top: 12),
        height: 48,
        alignment: Alignment.centerRight,
        child: ListView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            IconButton(
              onPressed:
                  currentPage < totalPages - 1 ? () => onPageChanged(currentPage + 1) : null,
              icon: const Icon(Icons.chevron_right),
              tooltip: "Próximo",
            ),
            ..._buildPaginationButtons(true).reversed,
            IconButton(
              onPressed:
                  currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
              icon: const Icon(Icons.chevron_left),
              tooltip: "Anterior",
            ),
          ],
        ),
      );
    } else {
      // Desktop version - corrigido para não quebrar nem sair da tela
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed:
                  currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Anterior'),
            ),
            ..._buildPaginationButtons(false),
            TextButton.icon(
              onPressed: currentPage < totalPages - 1
                  ? () => onPageChanged(currentPage + 1)
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Próximo'),
            ),
          ],
        ),
      );
    }
  }
}