import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/scholarship_application.dart';
import '../screens/application_detail_screen.dart';
import 'application_progress_stepper.dart';

// Bordered, ledger-style row for one application - scheme name, ID,
// status chip, progress stepper, and (if applicable) the amount.
class ApplicationLedgerRow extends StatelessWidget {
  const ApplicationLedgerRow({super.key, required this.application});

  final ScholarshipApplication application;

  String get _statusLabel {
    if (application.actionRequired) return 'Action Required';
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

  Color get _statusColor {
    if (application.actionRequired) return const Color(0xFFD32F2F);
    return application.currentStage == ApplicationStage.disbursed
        ? AppColors.green
        : AppColors.saffron;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ApplicationDetailScreen(application: application),
        ),
      ),
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: application.actionRequired ? const Color(0xFFD32F2F) : AppColors.border,
          width: application.actionRequired ? 1.4 : 1,
        ),
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
            child: ApplicationProgressStepper(
              currentStage: application.currentStage,
              actionRequired: application.actionRequired,
            ),
          ),
          if (application.actionRequired)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFFDECEC),
                border: Border(top: BorderSide(color: Color(0xFFD32F2F))),
              ),
                           child: Row(
                children: [
                  const Icon(Icons.error_outline, size: 16, color: Color(0xFFD32F2F)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      application.deficiencyNote ?? 'Action required - see details.',
                      style: const TextStyle(fontSize: 11, color: Color(0xFFD32F2F)),
                    ),
                  ),
                ],
              ),
            ),
          if (application.amount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                'Amount: \u20B9${application.amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}