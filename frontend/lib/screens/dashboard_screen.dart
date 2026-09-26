import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../widgets/emblem_watermark.dart';
import '../widgets/application_ledger_row.dart';
import '../widgets/notification_bell.dart';
import '../models/scholarship_application.dart';
import '../services/api_service.dart';
import 'eligibility_check_screen.dart';
const Map<String, String> _schemeLabels = {
  'PRE_MATRIC_ST': 'Pre-Matric Scholarship for ST Students',
  'POST_MATRIC_ST': 'Post-Matric Scholarship for ST Students',
  'TOP_CLASS': 'Top Class Education Scheme',
  'NFST': 'National Fellowship for ST Students',
  'NOS': 'National Overseas Scholarship',
};

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.studentId, this.applicantName});

  final String studentId;
  final String? applicantName;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> _dashboardFuture;
  late Future<List<dynamic>> _notificationsFuture;

  // Phase 4 (D) milestone-alert mock: tracks which studentId/applicationId/
  // milestone combos we've already fired a notification for this session,
  // so re-running the future (e.g. via Retry) doesn't spam duplicate alerts.
  static final Set<String> _firedMilestones = {};

  @override
  void initState() {
    super.initState();
    _dashboardFuture = ApiService.getDashboard(widget.studentId);
    _notificationsFuture = _dashboardFuture.then(_fireMilestoneAlertsThenFetch);
  }

  // The instant the dashboard sees an application at a milestone stage
  // (sanctioned / disbursed / action_required), it triggers a real call to
  // the notification stub (Phase 4 B) so the bell has something genuine to
  // show, then fetches the resulting list back.
  Future<List<dynamic>> _fireMilestoneAlertsThenFetch(Map<String, dynamic> data) async {
    const milestoneStatuses = {'sanctioned', 'disbursed', 'action_required'};
    final apps = (data['applications'] as List<dynamic>? ?? []);

    for (final raw in apps) {
      final a = raw as Map<String, dynamic>;
      final status = a['status']?.toString();
      final appId = a['application_id']?.toString();
      if (status == null || appId == null || !milestoneStatuses.contains(status)) continue;

      final key = '${widget.studentId}:$appId:$status';
      if (_firedMilestones.add(key)) {
        try {
          await ApiService.triggerNotification(
            studentId: widget.studentId,
            applicationId: appId,
            milestone: status,
          );
        } catch (_) {
          // Demo alert failing to fire shouldn't break the dashboard.
        }
      }
    }

    return ApiService.getNotifications(widget.studentId);
  }

  void _retry() {
    setState(() {
      _dashboardFuture = ApiService.getDashboard(widget.studentId);
      _notificationsFuture = _dashboardFuture.then(_fireMilestoneAlertsThenFetch);
    });
  }

  ScholarshipApplication _fromApiJson(Map<String, dynamic> json) {
    final status = json['status'] as String;
    final pendingDocs = (json['pending_documents'] as List<dynamic>? ?? [])
        .map((d) => d.toString())
        .toList();

    ApplicationStage stage;
    bool actionRequired = false;
    ApplicationStage? flaggedAtStage;

    switch (status) {
      case 'sanctioned':
        stage = ApplicationStage.sanctioned;
        break;
      case 'disbursed':
        stage = ApplicationStage.disbursed;
        break;
      case 'action_required':
        stage = ApplicationStage.verified;
        actionRequired = true;
        flaggedAtStage = ApplicationStage.verified;
        break;
      default:
        stage = ApplicationStage.submitted;
    }

    return ScholarshipApplication(
      schemeName: _schemeLabels[json['scheme']] ?? json['scheme'].toString(),
      applicationId: json['application_id'].toString(),
      applicantName: widget.applicantName ?? widget.studentId,
      currentStage: stage,
      amount: (json['amount'] as num).toDouble(),
      lastUpdated: DateTime.tryParse(json['last_updated'].toString()) ?? DateTime.now(),
      actionRequired: actionRequired,
      flaggedAtStage: flaggedAtStage,
      flaggedDocuments: actionRequired ? pendingDocs : const [],
      deficiencyNote: actionRequired && pendingDocs.isNotEmpty
          ? 'Flagged for review: ${pendingDocs.join(', ')}'
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GovHeader(trailing: NotificationBell(notificationsFuture: _notificationsFuture)),
        Expanded(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _dashboardFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFFD32F2F), size: 32),
                        const SizedBox(height: 12),
                        const Text(
                          'Could not load your dashboard. Please check your connection and try again.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textDark),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _retry, child: const Text('Retry')),
                      ],
                    ),
                  ),
                );
              }

              final data = snapshot.data!;
              final applications = (data['applications'] as List<dynamic>)
                  .map((a) => _fromApiJson(a as Map<String, dynamic>))
                  .toList();
              final totalDisbursed = (data['total_disbursed'] as num).toDouble();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                  '\u20B9${totalDisbursed.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Across ${applications.length} scheme applications',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textDark),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your applications',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EligibilityCheckScreen(studentId: widget.studentId),
                                ),
                              );
                            },
                            child: const Text(
                              '+ Apply for new scheme',
                              style: TextStyle(fontSize: 12, color: AppColors.navy),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: applications
                            .map((a) => ApplicationLedgerRow(application: a))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        ),
        const _DashboardFooter(),
      ],
    );
  }
}

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