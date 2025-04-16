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
    if (widget.text != null) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            widget.buttonColor ?? Colors.grey,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
            ),
          ),
        ),
        onPressed: isLoading ? null : _handlePress,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.text!,
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.fontSize ?? 14),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    widget.iconData,
                    color: widget.iconColor ?? Colors.white,
                  ),
                ],
              ),
      );
    } else if (widget.text != null && widget.iconData != null) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              WidgetStatePropertyAll(widget.buttonColor ?? Colors.grey),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
            ),
          ),
        ),
        onPressed: isLoading ? null : _handlePress,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                widget.text!,
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.fontSize ?? 14),
              ),
      );
    } else {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            widget.buttonColor ?? Colors.grey,
          ),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
            ),
          ),
        ),
        onPressed: isLoading ? null : _handlePress,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Icon(
                widget.iconData,
                color: widget.iconColor ?? Colors.blue,
              ),
      );
    }
  }
}
