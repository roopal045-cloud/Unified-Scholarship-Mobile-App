import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/scholarship_application.dart';
import 'application_progress_stepper.dart';

// Bordered, ledger-style row for one application - scheme name, ID,
// status chip, progress stepper, and (if applicable) the amount.
class ApplicationLedgerRow extends StatelessWidget {
  const ApplicationLedgerRow({super.key, required this.application});

  final ScholarshipApplication application;

  String get _statusLabel {
    switch (application.currentStage) {
      case ApplicationStage.submitted:
        return 'Submitted';
      case ApplicationStage.verified:
        return 'Verified';
      case ApplicationStage.sanctioned:
        return 'Sanctioned';
      case ApplicationStage.disbursed:
        return 'Disbursed';
    }
  }

  Color get _statusColor => application.currentStage == ApplicationStage.disbursed
      ? AppColors.green
      : AppColors.saffron;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application.schemeName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'ID: ${application.applicationId}',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.12),
                    border: Border.all(color: _statusColor),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: ApplicationProgressStepper(currentStage: application.currentStage),
          ),
          if (application.amount > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
                color: Color(0xFFFAFAFA),
              ),
              child: Text(
                application.currentStage == ApplicationStage.disbursed
                    ? 'Amount disbursed: ₹${application.amount.toStringAsFixed(0)}'
                    : 'Sanctioned amount: ₹${application.amount.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 11, color: AppColors.textDark),
              ),
            ),
        ],
      ),
    );
  }
}