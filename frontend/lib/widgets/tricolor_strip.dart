import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Thin tricolor accent strip shown directly below the app header.
// Reused on login, dashboard, and other key screens.
class TricolorStrip extends StatelessWidget {
  const TricolorStrip({super.key, this.height = 4});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: height, color: AppColors.saffron)),
        Expanded(child: Container(height: height, color: AppColors.white)),
        Expanded(child: Container(height: height, color: AppColors.green)),
      ],
    );
  }
}