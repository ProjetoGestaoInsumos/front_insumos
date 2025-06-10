import 'package:flutter/material.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white, // ou qualquer cor de fundo desejada
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: Lottie.asset(
                'assets/animations/anima.json',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
