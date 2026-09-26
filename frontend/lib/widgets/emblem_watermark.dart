import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Subtle centered watermark placeholder for the National Emblem
// (Ashoka Lion Capital). Used behind the login screen and the
// dashboard's top summary section.
//
// Swap the Icon for the real asset once cleared, e.g.:
//   Image.asset('assets/images/emblem.png', width: size, height: size,
//       color: AppColors.navy, colorBlendMode: BlendMode.srcIn)
class EmblemWatermark extends StatelessWidget {
  const EmblemWatermark({super.key, this.size = 220, this.opacity = 0.05});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Icon(Icons.account_balance, size: size, color: AppColors.navy),
      ),
    );
  }
}