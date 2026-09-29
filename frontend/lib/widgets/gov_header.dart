import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Header used on every screen, matching the redesigned portal look:
// white background, navy emblem icon, Ministry name/subtitle, and a
// language switcher on the right - or the trailing widget (e.g. the
// Dashboard's notification bell) when one is supplied.
//
// NOTE: account_balance icon is a placeholder for the National Emblem
// (Ashoka Lion Capital) - swap in the real emblem asset before final
// submission.
class GovHeader extends StatelessWidget {
  const GovHeader({super.key, this.compact = false, this.trailing});

  final bool compact;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: compact ? 12 : 16),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Icon(Icons.account_balance, color: AppColors.navy, size: compact ? 24 : 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ministry of Tribal Affairs',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.bold,
                      fontSize: compact ? 15 : 17,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Government of India',
                    style: TextStyle(color: Colors.grey, fontSize: compact ? 11 : 12),
                  ),
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (!compact)
              const Text(
                'हिन्दी · English',
                style: TextStyle(color: AppColors.textDark, fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }
}