import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/utils/colors.dart';

class CustomPopup extends StatefulWidget {
  final String title;
  final Widget content;
  final VoidCallback onClose;
  final bool showFooter;
  final String? primaryButtonLabel;
  final Future<void> Function()? primaryButtonOnPressed; // Suporte para async
  final String? secondaryButtonLabel;
  final Future<void> Function()? secondaryButtonOnPressed;

  const CustomPopup({
    super.key,
    required this.title,
    required this.content,
    required this.onClose,
    this.showFooter = false,
    this.primaryButtonLabel,
    this.primaryButtonOnPressed,
    this.secondaryButtonLabel,
    this.secondaryButtonOnPressed,
  });

  // Método estático para exibir o popup
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    VoidCallback? onClose,
    bool showFooter = false,
    String? primaryButtonLabel,
    Future<void> Function()? primaryButtonOnPressed,
    String? secondaryButtonLabel,
    Future<void> Function()? secondaryButtonOnPressed,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomPopup(
          title: title,
          content: content,
          onClose: onClose ?? () => Navigator.of(dialogContext).pop(),
          showFooter: showFooter,
          primaryButtonLabel: primaryButtonLabel,
          primaryButtonOnPressed: primaryButtonOnPressed,
          secondaryButtonLabel: secondaryButtonLabel,
          secondaryButtonOnPressed: secondaryButtonOnPressed,
        );
      },
    );
  }

  @override
  State<CustomPopup> createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double maxWidth = 600;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth, // Aplica a largura máxima
        ),
        child: SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(20),
          backgroundColor: CustomColors.white,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                if (screenWidth >= 600)
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: CustomColors.white, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: CustomColors.blue, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              child: widget.content,
            ),
            if (widget.showFooter) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.secondaryButtonLabel != null)
                    Expanded(
                      child: CustomButton(
                        minWidth: 120,
                        text: widget.secondaryButtonLabel,
                        buttonColor: CustomColors.grey,
                        borderRadius: 10,
                        fontSize: 16,
                        onPressed: widget.secondaryButtonOnPressed,
                      ),
                    ),
                  if (widget.secondaryButtonLabel != null &&
                      widget.primaryButtonLabel != null)
                    const SizedBox(width: 50),
                  if (widget.primaryButtonLabel != null) ...[
                    Expanded(
                      child: CustomButton(
                        minWidth: 120,
                        text: widget.primaryButtonLabel,
                        buttonColor: isProcessing
                            ? CustomColors.grey
                            : CustomColors.blue,
                        borderRadius: 10,
                        fontSize: 16,
                        onPressed: isProcessing
                            ? null
                            : () async {
                                setState(() {
                                  isProcessing = true;
                                });

                                if (widget.primaryButtonOnPressed != null) {
                                  try {
                                    await widget.primaryButtonOnPressed!();
                                  } finally {
                                    setState(() {
                                      isProcessing = false;
                                    });
                                  }
                                }
                              },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
