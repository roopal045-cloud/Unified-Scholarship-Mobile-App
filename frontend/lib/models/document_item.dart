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

// Demo-mode toggle used to show the Document Wallet's empty state.
const bool demoShowEmptyWallet = false;