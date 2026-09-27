import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../widgets/document_wallet_row.dart';
import '../models/document_item.dart';
import '../services/api_service.dart';

// Document Wallet screen. Lists documents derived from the student's real
// applications (see documentsFromApplications in document_item.dart) -
// there is no dedicated document-storage backend, so this is a reasonable
// derived view rather than a per-document upload system.
class DocumentWalletScreen extends StatefulWidget {
  const DocumentWalletScreen({super.key, required this.studentId});

  final String studentId;

  @override
  State<DocumentWalletScreen> createState() => _DocumentWalletScreenState();
}

class _DocumentWalletScreenState extends State<DocumentWalletScreen> {
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
                          'Could not load your documents. Please check your connection and try again.',
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
              final documents = documentsFromApplications(data['applications'] as List<dynamic>);
              final rejectedCount =
                  documents.where((d) => d.status == DocumentStatus.rejected).length;

              if (documents.isEmpty) {
                return const _EmptyWalletState();
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
                      child: Row(
                        children: [
                          Text('Document wallet', style: Theme.of(context).textTheme.titleMedium),
                          const Spacer(),
                          if (rejectedCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD32F2F).withOpacity(0.12),
                                border: Border.all(color: const Color(0xFFD32F2F)),
                              ),
                              child: Text(
                                '$rejectedCount need${rejectedCount == 1 ? 's' : ''} attention',
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: documents.map((d) => DocumentWalletRow(document: d)).toList(),
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
    );
  }
}

class _EmptyWalletState extends StatelessWidget {
  const _EmptyWalletState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.navy.withOpacity(0.06),
              ),
              child: const Icon(Icons.folder_off_outlined, size: 34, color: AppColors.navy),
            ),
            const SizedBox(height: 16),
            Text(
              'No documents on record',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Documents linked to your scholarship applications will appear '
              'here, along with their verification status.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}