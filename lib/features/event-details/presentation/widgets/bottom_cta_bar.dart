import 'package:flutter/material.dart';
import '../../../../core/widgets/app_button.dart';

class BottomCtaBar extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const BottomCtaBar({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.0),
              Colors.white.withOpacity(0.9),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: AppButton.primary(
            text: label,
            hasArrow: true,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}