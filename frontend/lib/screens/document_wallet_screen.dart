import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gov_header.dart';
import '../widgets/document_wallet_row.dart';
import '../models/document_item.dart';

// §1.3 - Document Wallet screen. Lists every document the student has
// uploaded, with verification status, plus an empty state for new users.
class DocumentWalletScreen extends StatelessWidget {
  const DocumentWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final documents = demoShowEmptyWallet ? <DocumentItem>[] : dummyDocuments;
    final rejectedCount = documents.where((d) => d.status == DocumentStatus.rejected).length;

    return Column(
      children: [
        const GovHeader(compact: true),
        Expanded(
          child: documents.isEmpty
              ? const _EmptyWalletState()
              : SingleChildScrollView(
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
              'No documents uploaded yet',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Documents you upload for your scholarship applications will appear '
              'here, along with their verification status.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Upload a document'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}