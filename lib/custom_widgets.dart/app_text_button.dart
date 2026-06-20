import 'package:flutter/material.dart';
import 'package:skillday/custom_widgets.dart/app_text_styles.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AppTextButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: AppTextStyles.button),
    );
  }
}
