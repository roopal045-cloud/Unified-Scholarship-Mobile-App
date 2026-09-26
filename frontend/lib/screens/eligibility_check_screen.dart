import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../services/api_service.dart';

// Shown before a student starts a new scheme application. Enforces the
// "one scheme at a time" rule from the problem statement - blocks the
// student with a clear reason rather than letting them submit a second
// application and finding out later.
class EligibilityCheckScreen extends StatefulWidget {
  const EligibilityCheckScreen({super.key, required this.studentId});

  final String studentId;

  @override
  State<EligibilityCheckScreen> createState() => _EligibilityCheckScreenState();
}

class _EligibilityCheckScreenState extends State<EligibilityCheckScreen> {
  late Future<Map<String, dynamic>> _eligibilityFuture;

  @override
  void initState() {
    super.initState();
    _eligibilityFuture = ApiService.checkEligibility(widget.studentId);
  }

  void _retry() {
    setState(() {
      _eligibilityFuture = ApiService.checkEligibility(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GovHeader(compact: true),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _eligibilityFuture,
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
                            'Could not check eligibility. Please try again.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(onPressed: _retry, child: const Text('Retry')),
                        ],
                      ),
                    ),
                  );
                }

                final data = snapshot.data!;
                final eligible = data['eligible'] as bool;
                final reason = data['reason'] as String;

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        eligible ? Icons.check_circle_outline : Icons.block,
                        color: eligible ? AppColors.green : const Color(0xFFD32F2F),
                        size: 56,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        eligible ? 'You are eligible to apply' : 'You cannot apply right now',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        reason,
                        style: const TextStyle(color: AppColors.textDark, fontSize: 13, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      if (eligible)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Placeholder - would navigate to an actual
                              // scheme-selection / application form screen.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Proceeding to scheme selection...')),
                              );
                            },
                            child: const Text('Continue to apply'),
                          ),
                        )
                      else
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Go back to dashboard'),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}