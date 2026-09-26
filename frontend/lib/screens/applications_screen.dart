import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../widgets/application_ledger_row.dart';
import '../models/scholarship_application.dart';
import '../services/api_service.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key, required this.studentId, this.applicantName});

  final String studentId;
  final String? applicantName;

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  late Future<Map<String, dynamic>> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = ApiService.getDashboard(widget.studentId);
  }

  void _retry() {
    setState(() {
      _dashboardFuture = ApiService.getDashboard(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const GovHeader(compact: true),
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
                          'Could not load your applications. Please check your connection and try again.',
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
              final rawApplications = data['applications'] as List<dynamic>;

              if (rawApplications.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'You have no scholarship applications yet.',
                      style: TextStyle(color: AppColors.textDark),
                    ),
                  ),
                );
              }

              final applications = rawApplications
                  .map((a) => ScholarshipApplication.fromApiJson(
                        a as Map<String, dynamic>,
                        applicantName: widget.applicantName ?? widget.studentId,
                      ))
                  .toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All applications (${applications.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...applications.map((a) => ApplicationLedgerRow(application: a)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}