// Mock adapter for the National Scholarship Portal (NSP).
// Handles Pre-Matric and Post-Matric schemes.
// Uses NSP's own field naming to simulate a real, independently-built
// legacy system we do NOT control.

const MOCK_NSP_RECORDS = {
  "STU-1001": [
    {
      application_no: "NSP2026PM001234",
      scheme_code: "PRE_MATRIC_ST",
      applicant_status: "PENDING_VERIFICATION",
      stage: "INSTITUTION_VERIFICATION",
      docs_required: ["income_certificate", "caste_certificate"],
      last_updated: "2026-08-14",
      sanctioned_amount: null
    }
  ],
  "STU-1002": [
    {
      application_no: "NSP2026POM004521",
      scheme_code: "POST_MATRIC_ST",
      applicant_status: "SANCTIONED",
      stage: "DISBURSEMENT_PENDING",
      docs_required: [],
      last_updated: "2026-09-02",
      sanctioned_amount: 12400
    }
  ]
};

function getApplicationsByStudent(studentId) {
  return MOCK_NSP_RECORDS[studentId] || [];
}

function verifyDocument(docType) {
  const knownGoodDocs = ["income_certificate", "caste_certificate", "academic_records"];
  const matched = knownGoodDocs.includes(docType) && Math.random() > 0.25;
  return { matched, source: "NSP" };
}

module.exports = { getApplicationsByStudent, verifyDocument };