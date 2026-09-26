import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/document_item.dart';

// Bordered, ledger-style row for one document - matches
// ApplicationLedgerRow's visual pattern (no floating cards/shadows).
class DocumentWalletRow extends StatelessWidget {
  const DocumentWalletRow({super.key, required this.document});

  final DocumentItem document;

  String get _statusLabel {
    switch (document.status) {
      case DocumentStatus.verified:
        return 'Verified';
      case DocumentStatus.pending:
        return 'Pending review';
      case DocumentStatus.rejected:
        return 'Rejected';
    }
  }

  Color get _statusColor {
    switch (document.status) {
      case DocumentStatus.verified:
        return AppColors.green;
      case DocumentStatus.pending:
        return AppColors.saffron;
      case DocumentStatus.rejected:
        return const Color(0xFFD32F2F);
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

  @override
  Widget build(BuildContext context) {
    final isRejected = document.status == DocumentStatus.rejected;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: isRejected ? _statusColor : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.description_outlined, size: 20, color: AppColors.navy),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document.name, style: Theme.of(context).textTheme.titleMedium),
                      Text(document.category, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('Uploaded: ${_formatDate(document.uploadedDate)}',
                          style: const TextStyle(fontSize: 10, color: Colors.grey)),
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
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _statusColor),
                  ),
                ),
              ],
            ),
          ),
          if (isRejected && document.rejectionReason != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFFDECEC),
                border: Border(top: BorderSide(color: Color(0xFFD32F2F))),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, size: 14, color: Color(0xFFD32F2F)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      document.rejectionReason!,
                      style: const TextStyle(fontSize: 11, color: Color(0xFFD32F2F)),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                    onPressed: () {},
                    child: const Text('Re-upload', style: TextStyle(fontSize: 11, color: Color(0xFFD32F2F))),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}