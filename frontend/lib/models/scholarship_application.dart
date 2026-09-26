// Data model for a single scholarship application, plus dummy data used
// by the Dashboard until the real backend (adapters/aggregationService)
// is wired up.

enum ApplicationStage { submitted, verified, sanctioned, disbursed }

class ScholarshipApplication {
  final String schemeName;
  final String applicationId;
  final ApplicationStage currentStage;
  final double amount; // sanctioned / disbursed amount in INR
  final DateTime lastUpdated;

  const ScholarshipApplication({
    required this.schemeName,
    required this.applicationId,
    required this.currentStage,
    required this.amount,
    required this.lastUpdated,
  });
}

// TODO(person C / backend team): replace with data from
// backend/src/services/aggregationService.js via an API call.
final List<ScholarshipApplication> dummyApplications = [
  ScholarshipApplication(
    schemeName: 'Pre-Matric Scholarship for ST Students',
    applicationId: 'PMS-2026-00841',
    currentStage: ApplicationStage.disbursed,
    amount: 12000,
    lastUpdated: DateTime(2026, 9, 18),
  ),
  ScholarshipApplication(
    schemeName: 'Post-Matric Scholarship for ST Students',
    applicationId: 'POMS-2026-01123',
    currentStage: ApplicationStage.sanctioned,
    amount: 25000,
    lastUpdated: DateTime(2026, 9, 20),
  ),
  ScholarshipApplication(
    schemeName: 'National Fellowship for ST Students',
    applicationId: 'NFST-2026-00456',
    currentStage: ApplicationStage.verified,
    amount: 31000,
    lastUpdated: DateTime(2026, 9, 22),
  ),
  ScholarshipApplication(
    schemeName: 'Top Class Education Scheme',
    applicationId: 'TCE-2026-00219',
    currentStage: ApplicationStage.submitted,
    amount: 0,
    lastUpdated: DateTime(2026, 9, 24),
  ),
  ScholarshipApplication(
    schemeName: 'Eklavya Model Residential School Scheme',
    applicationId: 'EMRS-2026-00937',
    currentStage: ApplicationStage.disbursed,
    amount: 8000,
    lastUpdated: DateTime(2026, 9, 15),
  ),
];