// Data model for a single scholarship application, plus dummy data used
// by the Dashboard until the real backend (adapters/aggregationService)
// is wired up.
//
// NOTE: The design-lead spec doc (design-demo-lead-deliverables.md) was
// never added to this repo, so the exact copy/personas below are demo
// placeholders written to match the existing app tone - swap freely once
// the real doc/persona data is available.

enum ApplicationStage { submitted, verified, sanctioned, disbursed }

// One entry in an application's audit trail, shown on the Application
// Detail / Timeline screen.
class TimelineEvent {
  final ApplicationStage stage;
  final DateTime? date; // null = not reached yet
  final String note;

  const TimelineEvent({required this.stage, required this.date, required this.note});

  bool get isReached => date != null;
}

class ScholarshipApplication {
  final String schemeName;
  final String applicationId;
  final String applicantName;
  final ApplicationStage currentStage;
  final double amount; // sanctioned / disbursed amount in INR
  final DateTime lastUpdated;

  // Action-required / deficiency state (§1.1, §1.2 demo behaviour).
  // When true, the stage the flag was raised at is shown separately below -
  // no 5th "action required" step is added to the 4-step stepper.
  final bool actionRequired;
  final ApplicationStage? flaggedAtStage;
  final List<String> flaggedDocuments;
  final String? deficiencyNote;

  const ScholarshipApplication({
    required this.schemeName,
    required this.applicationId,
    required this.applicantName,
    required this.currentStage,
    required this.amount,
    required this.lastUpdated,
    this.actionRequired = false,
    this.flaggedAtStage,
    this.flaggedDocuments = const [],
    this.deficiencyNote,
  });

  // Generates a plausible 4-stage timeline for the Detail screen, working
  // backwards from lastUpdated. Stages after currentStage are left unreached.
  List<TimelineEvent> get timeline {
    const stageNotes = {
      ApplicationStage.submitted: 'Application submitted online via the National Scholarship Portal.',
      ApplicationStage.verified: 'Documents verified by the Welfare Officer / Institution nodal officer.',
      ApplicationStage.sanctioned: 'Application sanctioned by the State Scholarship Cell.',
      ApplicationStage.disbursed: 'Scholarship amount disbursed via Direct Benefit Transfer (DBT).',
    };

    final events = <TimelineEvent>[];
    for (final stage in ApplicationStage.values) {
      final reached = stage.index <= currentStage.index;
      DateTime? date;
      String note = stageNotes[stage]!;
      if (reached) {
        final daysBack = (currentStage.index - stage.index) * 4;
        date = lastUpdated.subtract(Duration(days: daysBack));
      }
      if (actionRequired && stage == flaggedAtStage) {
        note = 'Verification flagged - see deficiency details below.';
      }
      events.add(TimelineEvent(stage: stage, date: date, note: note));
    }
    return events;
  }
}

// TODO(person C / backend team): replace with data from
// backend/src/services/aggregationService.js via an API call.
final List<ScholarshipApplication> dummyApplications = [
  ScholarshipApplication(
    schemeName: 'Pre-Matric Scholarship for ST Students',
    applicationId: 'PMS-2026-00841',
    applicantName: 'Ramesh Oraon',
    currentStage: ApplicationStage.disbursed,
    amount: 12000,
    lastUpdated: DateTime(2026, 9, 18),
  ),
  ScholarshipApplication(
    schemeName: 'Post-Matric Scholarship for ST Students',
    applicationId: 'POMS-2026-01123',
    applicantName: 'Deepika Bhagat',
    currentStage: ApplicationStage.sanctioned,
    amount: 25000,
    lastUpdated: DateTime(2026, 9, 20),
  ),
  // Flagged demo persona - centerpiece of the Application Detail and
  // chatbot deficiency-explanation flow.
  ScholarshipApplication(
    schemeName: 'National Fellowship for ST Students',
    applicationId: 'NFST-2026-00456',
    applicantName: 'Sunita Kumari',
    currentStage: ApplicationStage.verified,
    amount: 31000,
    lastUpdated: DateTime(2026, 9, 22),
    actionRequired: true,
    flaggedAtStage: ApplicationStage.verified,
    flaggedDocuments: const [
      'Income Certificate',
      'Caste (ST) Certificate',
    ],
    deficiencyNote:
        'Income Certificate has expired (issued more than 1 year ago). Caste Certificate '
        'image is blurred/unreadable. Please re-upload clear, valid copies to continue.',
  ),
  ScholarshipApplication(
    schemeName: 'Top Class Education Scheme',
    applicationId: 'TCE-2026-00219',
    applicantName: 'Arjun Meena',
    currentStage: ApplicationStage.submitted,
    amount: 0,
    lastUpdated: DateTime(2026, 9, 24),
  ),
  ScholarshipApplication(
    schemeName: 'Eklavya Model Residential School Scheme',
    applicationId: 'EMRS-2026-00937',
    applicantName: 'Ramesh Oraon',
    currentStage: ApplicationStage.disbursed,
    amount: 8000,
    lastUpdated: DateTime(2026, 9, 15),
  ),
];