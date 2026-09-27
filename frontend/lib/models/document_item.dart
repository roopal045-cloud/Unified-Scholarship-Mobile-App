// Data model for one document in the student's Document Wallet (§1.3).

enum DocumentStatus { verified, pending, rejected }

class DocumentItem {
  final String name;
  final String category;
  final DocumentStatus status;
  final DateTime uploadedDate;
  final String? rejectionReason;

  const DocumentItem({
    required this.name,
    required this.category,
    required this.status,
    required this.uploadedDate,
    this.rejectionReason,
  });
}

// TODO(backend team): replace with documents fetched per-student from the
// backend once the document-storage API is wired up.
final List<DocumentItem> dummyDocuments = [
  DocumentItem(
    name: 'Aadhaar Card',
    category: 'Identity proof',
    status: DocumentStatus.verified,
    uploadedDate: DateTime(2026, 8, 2),
  ),
  DocumentItem(
    name: 'Bonafide Certificate',
    category: 'Institution proof',
    status: DocumentStatus.verified,
    uploadedDate: DateTime(2026, 8, 2),
  ),
  DocumentItem(
    name: 'Income Certificate',
    category: 'Income proof',
    status: DocumentStatus.rejected,
    uploadedDate: DateTime(2026, 9, 5),
    rejectionReason: 'Certificate has expired (issued more than 1 year ago).',
  ),
  DocumentItem(
    name: 'Caste (ST) Certificate',
    category: 'Caste proof',
    status: DocumentStatus.rejected,
    uploadedDate: DateTime(2026, 9, 5),
    rejectionReason: 'Uploaded image is blurred / unreadable.',
  ),
  DocumentItem(
    name: 'Bank Passbook (front page)',
    category: 'Bank proof',
    status: DocumentStatus.pending,
    uploadedDate: DateTime(2026, 9, 22),
  ),
];
String _titleCase(String snakeCase) {
  return snakeCase
      .split('_')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}

const Map<String, String> _schemeLabelsForDocs = {
  'PRE_MATRIC_ST': 'Pre-Matric Scholarship',
  'POST_MATRIC_ST': 'Post-Matric Scholarship',
  'TOP_CLASS': 'Top Class Education Scheme',
  'NFST': 'National Fellowship (NFST)',
  'NOS': 'National Overseas Scholarship',
};

// Builds Document Wallet entries from a student's real applications
// (as returned by ApiService.getDashboard). There is no dedicated
// document-storage backend, so this derives a reasonable wallet view:
// - an application flagged "action_required" contributes one rejected
//   entry per pending document, with the reason tied to that scheme
// - any other application contributes one "supporting documents" entry,
//   verified if sanctioned/disbursed, pending if still under verification
List<DocumentItem> documentsFromApplications(List<dynamic> applications) {
  final items = <DocumentItem>[];

  for (final raw in applications) {
    final app = raw as Map<String, dynamic>;
    final scheme = app['scheme']?.toString() ?? '';
    final schemeLabel = _schemeLabelsForDocs[scheme] ?? scheme;
    final status = app['status']?.toString() ?? '';
    final lastUpdated =
        DateTime.tryParse(app['last_updated']?.toString() ?? '') ?? DateTime.now();
    final pendingDocs = (app['pending_documents'] as List<dynamic>? ?? [])
        .map((d) => d.toString())
        .toList();

    if (status == 'action_required' && pendingDocs.isNotEmpty) {
      for (final doc in pendingDocs) {
        items.add(DocumentItem(
          name: _titleCase(doc),
          category: schemeLabel,
          status: DocumentStatus.rejected,
          uploadedDate: lastUpdated,
          rejectionReason: 'Flagged during verification for $schemeLabel - needs re-submission.',
        ));
      }
    } else {
      items.add(DocumentItem(
        name: 'Supporting documents',
        category: schemeLabel,
        status: status == 'under_verification' ? DocumentStatus.pending : DocumentStatus.verified,
        uploadedDate: lastUpdated,
      ));
    }
  }

  return items;
}
// Demo-mode toggle used to show the Document Wallet's empty state.
const bool demoShowEmptyWallet = false;