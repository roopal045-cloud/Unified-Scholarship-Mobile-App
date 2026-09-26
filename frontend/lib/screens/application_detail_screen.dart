import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../models/scholarship_application.dart';

// §1.2 - Application Detail / Timeline screen. Shows the full audit trail
// for one application, plus a deficiency sub-block when documents were
// flagged during verification (Sunita Kumari demo persona).
class ApplicationDetailScreen extends StatelessWidget {
  const ApplicationDetailScreen({super.key, required this.application});

  final ScholarshipApplication application;

  String _statusLabel(ApplicationStage s) {
    switch (s) {
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

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GovHeader(compact: true),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    color: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Text(
                          'Application Detail',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: AppColors.border)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(application.schemeName, style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 4),
                              Text('Application ID: ${application.applicationId}',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              Text('Applicant: ${application.applicantName}',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              _SummaryCell(
                                label: 'Current status',
                                value: application.actionRequired
                                    ? 'Action Required'
                                    : _statusLabel(application.currentStage),
                                valueColor: application.actionRequired
                                    ? const Color(0xFFD32F2F)
                                    : AppColors.navy,
                              ),
                              _SummaryCell(
                                label: application.currentStage == ApplicationStage.disbursed
                                    ? 'Disbursed'
                                    : 'Sanctioned amount',
                                value: application.amount > 0
                                    ? '\u20B9${application.amount.toStringAsFixed(0)}'
                                    : '—',
                              ),
                              _SummaryCell(
                                label: 'Last updated',
                                value: _formatDate(application.lastUpdated),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (application.actionRequired) _DeficiencyBlock(application: application),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
                    child: Text('Application timeline', style: Theme.of(context).textTheme.titleMedium),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: application.timeline.asMap().entries.map((entry) {
                        final isLast = entry.key == application.timeline.length - 1;
                        return _TimelineTile(
                          event: entry.value,
                          isLast: isLast,
                          label: _statusLabel(entry.value.stage),
                          formatDate: _formatDate,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCell extends StatelessWidget {
  const _SummaryCell({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

// Bordered, red-accented sub-block listing exactly which documents were
// flagged and why, with a re-upload call to action.
class _DeficiencyBlock extends StatelessWidget {
  const _DeficiencyBlock({required this.application});

  final ScholarshipApplication application;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEC),
        border: Border.all(color: const Color(0xFFD32F2F)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFD32F2F))),
            ),
            child: const Row(
              children: [
                Icon(Icons.error_outline, size: 16, color: Color(0xFFD32F2F)),
                SizedBox(width: 8),
                Text(
                  'Documents flagged for correction',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...application.flaggedDocuments.map(
                  (doc) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.description_outlined, size: 14, color: Color(0xFFD32F2F)),
                        const SizedBox(width: 6),
                        Text(doc, style: const TextStyle(fontSize: 12, color: AppColors.textDark)),
                      ],
                    ),
                  ),
                ),
                if (application.deficiencyNote != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    application.deficiencyNote!,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textDark, height: 1.4),
                  ),
                ],
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
                    onPressed: () {},
                    child: const Text('Re-upload documents'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.event,
    required this.isLast,
    required this.label,
    required this.formatDate,
  });

  final TimelineEvent event;
  final bool isLast;
  final String label;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    final color = event.isReached ? AppColors.green : AppColors.border;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: color)),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: event.isReached ? AppColors.textDark : Colors.grey,
                        ),
                      ),
                      if (event.date != null)
                        Text(formatDate(event.date!), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.note,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: event.isReached ? AppColors.textDark : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}