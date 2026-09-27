import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../services/api_service.dart';

// Ministry-facing screen: ST students enrolled per UDISE+/APAAR/OTR but
// not availing any scholarship across NSP, SFMP, or NOS. Enables targeted
// outreach - per the problem statement's secondary goal. This is NOT a
// student-facing screen; reached from Profile for demo purposes only.
class CoverageGapScreen extends StatefulWidget {
  const CoverageGapScreen({super.key});

  @override
  State<CoverageGapScreen> createState() => _CoverageGapScreenState();
}

class _CoverageGapScreenState extends State<CoverageGapScreen> {
  late Future<Map<String, dynamic>> _gapFuture;

  @override
  void initState() {
    super.initState();
    _gapFuture = ApiService.getCoverageGap();
  }

  void _retry() {
    setState(() {
      _gapFuture = ApiService.getCoverageGap();
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body: Column(
        children: [
          const GovHeader(compact: true),
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
                const Text('Coverage Gap Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: AppColors.saffron.withOpacity(0.12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, size: 16, color: AppColors.navy),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Ministry view - outreach dashboard',
                    style: TextStyle(fontSize: 11, color: AppColors.navy, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _gapFuture,
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
                          const Text('Could not load coverage data.', textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(onPressed: _retry, child: const Text('Retry')),
                        ],
                      ),
                    ),
                  );
                }

                final data = snapshot.data!;
                final totalChecked = data['total_enrolled_checked'] as int;
                final coveredCount = data['covered_count'] as int;
                final gapCount = data['gap_count'] as int;
                final gapStudents = data['gap_students'] as List<dynamic>;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            _StatCard(label: 'Enrolled checked', value: '$totalChecked', color: AppColors.navy),
                            const SizedBox(width: 10),
                            _StatCard(label: 'Covered', value: '$coveredCount', color: AppColors.green),
                            const SizedBox(width: 10),
                            _StatCard(
                                label: 'Coverage gap', value: '$gapCount', color: const Color(0xFFD32F2F)),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                        child: Text(
                          'Students requiring outreach',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: gapStudents.map((s) {
                            final student = s as Map<String, dynamic>;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.person_outline, color: AppColors.navy, size: 22),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          student['full_name'].toString(),
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${student['school']} - ${student['grade']}',
                                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                                        ),
                                        Text(
                                          student['state'].toString(),
                                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),
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

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: AppColors.white, border: Border.all(color: AppColors.border)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}