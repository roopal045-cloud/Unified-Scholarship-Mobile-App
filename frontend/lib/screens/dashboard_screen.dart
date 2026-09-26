import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../widgets/emblem_watermark.dart';
import '../widgets/application_ledger_row.dart';
import '../models/scholarship_application.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  double get _totalDisbursed => dummyApplications
      .where((a) => a.currentStage == ApplicationStage.disbursed)
      .fold(0.0, (sum, a) => sum + a.amount);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GovHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total-disbursed summary, with the emblem watermark behind it.
                Container(
                  width: double.infinity,
                  color: AppColors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Positioned.fill(
                        child: Center(child: EmblemWatermark()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total amount disbursed',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\u20B9${_totalDisbursed.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Across ${dummyApplications.length} scheme applications',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
                  child: Text(
                    'Your applications',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: dummyApplications
                        .map((a) => ApplicationLedgerRow(application: a))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        const _DashboardFooter(),
      ],
    );
  }
}

// Footer-style status strip, like the ones on real e-Governance portals.
class _DashboardFooter extends StatelessWidget {
  const _DashboardFooter();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final synced =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      color: AppColors.navy,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Grievance Redressal',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 10,
              decoration: TextDecoration.underline,
            ),
          ),
          Text(
            'Last synced: $synced',
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }
}