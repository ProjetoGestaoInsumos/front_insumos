import 'package:flutter/material.dart';
import 'package:front_insumos/utils/colors.dart';

class CustomButton extends StatefulWidget {
  final Future<void> Function()? onPressed;
  final Color? buttonColor;
  final IconData? iconData;
  final String? text;
  final Color? iconColor;
  final double? borderRadius;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.iconData,
    this.text,
    this.buttonColor,
    this.iconColor,
    this.borderRadius,
    this.fontSize,
  });
  @override
  State<CustomButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomButton> {
  bool isLoading = false;

  Future<void> _handlePress() async {
    if (widget.onPressed != null) {
      setState(() {
        isLoading = true;
      });

      try {
        await widget.onPressed!();
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        widget.buttonColor == CustomColors.blue ? Colors.white : Colors.black;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          widget.buttonColor ?? Colors.grey,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
          ),
        ),
      ),
      onPressed: isLoading ? null : _handlePress,
      child: SizedBox(
        height: 40,
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.iconData != null)
                      Icon(
                        widget.iconData,
                        color: widget.iconColor ?? Colors.white,
                      ),
                    if (widget.text != null) ...[
                      if (widget.iconData != null) const SizedBox(width: 8),
                      Text(
                        widget.text!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: widget.fontSize ?? 16,
                          color: textColor,
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
