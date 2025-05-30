import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final void Function(String)? onChanged;
  final double width;
  final double borderRadius;
  final IconData icon;
  final Color fillColor;
  final BoxShadow? boxShadow;

  const CustomSearchField({
    super.key,
    this.hintText = 'Pesquisar...',
    this.onChanged,
    this.width = 250,
    this.borderRadius = 12,
    this.icon = Icons.search,
    this.fillColor = Colors.white,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            boxShadow ??
                const BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: ' $hintText',
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
