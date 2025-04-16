import 'package:flutter/material.dart';
import 'package:front_insumos/utils/colors.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: CustomColors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Painel de Controle",
              style: TextStyle(fontSize: 18, color: Colors.white)),
          CircleAvatar(
              backgroundColor: Colors.black, child: Icon(Icons.person)),
        ],
      ),
    );
  }
}
