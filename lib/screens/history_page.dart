import 'package:flutter/material.dart';
import 'package:front_insumos/components/side_bar.dart';
import 'package:front_insumos/components/top_bar.dart';
import 'package:front_insumos/screens/home_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryLayoutState();
}

class _HistoryLayoutState extends State<HistoryPage> {
  int selectedPage = 2; // Marcar como "Histórico" selecionado

  final List<Widget> pages = [
    HomePage(),
    HomePage(),
    HistoryPageContent(), // ✅ Conteúdo específico aqui
    HomePage(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            onItemSelected: (index) {
              setState(() {
                selectedPage = index;
              });
            },
            selectedIndex: selectedPage,
          ),
          Expanded(
            child: Column(
              children: [
                const TopBar(),
                Expanded(
                  child: pages[selectedPage],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Novo widget com título, divider e campo de busca
class HistoryPageContent extends StatelessWidget {
  const HistoryPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // ⬅ Alinha à esquerda
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
            color: Colors.black, // ⬅ Linha preta
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 250,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(
                        0, 0, 0, 0.25), // preto com 25% de opacidade
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: ' Pesquisar...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // Aqui você pode adicionar a lista de movimentações depois
        ],
      ),
    );
  }
}
