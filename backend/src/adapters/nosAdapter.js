// Mock adapter for the standalone National Overseas Scholarship (NOS) Portal.
// Yet another different field shape - a third team, a third convention.

const MOCK_NOS_RECORDS = {
  "STU-1004": [
    {
      id: "NOS/2026/0091",
      programme: "National Overseas Scholarship",
      state: "DOCUMENT_MISMATCH",
      remarks: "Income certificate does not match declared value",
      country: "United Kingdom",
      last_action_date: "2026-09-18",
      amount: 0
    }
  ]
};

function getApplicationsByStudent(studentId) {
  return MOCK_NOS_RECORDS[studentId] || [];
}

function verifyDocument(docType) {
  const knownGoodDocs = ["income_certificate", "admission_letter", "passport"];
  const matched = knownGoodDocs.includes(docType) && Math.random() > 0.4;
  return { matched, source: "NOS" };
}

module.exports = { getApplicationsByStudent, verifyDocument };