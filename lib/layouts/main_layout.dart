// lib/layouts/main_layout.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:front_insumos/components/side_bar.dart';
import 'package:front_insumos/components/top_bar.dart';

class MainLayout extends StatelessWidget {
  final int selectedIndex;
  final Widget child;

  const MainLayout({
    super.key,
    required this.selectedIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              switch (index) {
                case 0:
                  context.go('/');
                  break;
                case 1:
                  context.go('/estoque');
                  break;
                case 2:
                  context.go('/historico');
                  break;
                case 3:
                  context.go('/pedidos');
                  break;
                case 4:
                  context.go('/receitas');
                  break;
              }
            },
          ),
          Expanded(
            child: Column(
              children: [
                const TopBar(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
