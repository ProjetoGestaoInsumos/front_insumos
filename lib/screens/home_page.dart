import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(
        child: Row(
          children: [
            CustomButton(
              text: "Teste Backend",
              buttonColor: CustomColors.grey,
              onPressed: () async {
                Navigator.pushNamed(
                    context, '/produtos'); // Navega para ProdutosPage
              },
            ),
            const SizedBox(width: 20), // Espaço entre os botões
            CustomButton(
              text: "Layout",
              buttonColor: CustomColors.blue,
              onPressed: () async {},
            ),
          ],
        ),
      ),
    );
  }
}
