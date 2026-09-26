// Mock adapter for the Scholarship Fellowship Management Portal (SFMP),
// operated by Canara Bank. Handles Top Class and NFST schemes.
// Note the completely different field naming from NSP - this is the
// "disconnected systems" problem we are unifying.

const MOCK_SFMP_RECORDS = {
  "STU-1001": [
    {
      ref_id: "SFMP-NFST-88231",
      fellowship_type: "NFST",
      current_status: "UNDER_REVIEW",
      net_jrf_qualified: true,
      pending_items: ["net_jrf_certificate"],
      updated_on: "2026-09-10",
      amount_disbursed_inr: 0
    }
  ],
  "STU-1003": [
    {
      ref_id: "SFMP-TC-55210",
      fellowship_type: "TOP_CLASS",
      current_status: "DISBURSED",
      net_jrf_qualified: false,
      pending_items: [],
      updated_on: "2026-08-28",
      amount_disbursed_inr: 200000
    }
  ]
};

function getApplicationsByStudent(studentId) {
  return MOCK_SFMP_RECORDS[studentId] || [];
}

function verifyDocument(docType) {
  const knownGoodDocs = ["net_jrf_certificate", "institution_letter", "academic_records"];
  const matched = knownGoodDocs.includes(docType) && Math.random() > 0.3;
  return { matched, source: "SFMP" };
}

module.exports = { getApplicationsByStudent, verifyDocument };