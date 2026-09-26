import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tricolor_strip.dart';

// Official government-style header: navy bar with emblem placeholder
// and ministry name, topped off with the tricolor accent strip.
// NOTE: account_balance icon is a placeholder for the National Emblem
// (Ashoka Lion Capital) - swap in the real emblem asset before final submission,
// and flag in the pitch deck that it is used pending official clearance.
class GovHeader extends StatelessWidget {
  const GovHeader({super.key, this.compact = false, this.trailing});

  final bool compact;
  // Optional slot for a header action, e.g. the milestone-alert bell on the
  // Dashboard tab. Kept nullable so every other screen using GovHeader is
  // unaffected.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          color: AppColors.navy,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: compact ? 12 : 20,
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance,
                  color: AppColors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ministry of Tribal Affairs',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Government of India',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.85),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
        const TricolorStrip(),
      ],
    );
  }
}