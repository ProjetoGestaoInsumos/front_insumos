import 'package:flutter/material.dart';
import 'package:front_insumos/components/side_bar.dart';
import 'package:front_insumos/components/top_bar.dart';
import 'package:front_insumos/screens/home_page.dart';
import 'package:front_insumos/screens/history_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedPage = 0;

  final List<Widget> pages = [
    HomePage(),
    HomePage(),
    HistoryPage(),
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
