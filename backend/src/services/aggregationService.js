const nsp = require("../adapters/nspAdapter");
const sfmp = require("../adapters/sfmpAdapter");
const nos = require("../adapters/nosAdapter");

// Maps each system's own status vocabulary onto one shared vocabulary
// so the frontend never has to know which legacy system a record came from.
const STATUS_MAP = {
  // NSP
  PENDING_VERIFICATION: "under_verification",
  SANCTIONED: "sanctioned",
  // SFMP
  UNDER_REVIEW: "under_verification",
  DISBURSED: "disbursed",
  // NOS
  DOCUMENT_MISMATCH: "action_required"
};

function normalizeNsp(record) {
  return {
    source_system: "NSP",
    application_id: record.application_no,
    scheme: record.scheme_code,
    status: STATUS_MAP[record.applicant_status] || "unknown",
    pending_documents: record.docs_required,
    last_updated: record.last_updated,
    amount: record.sanctioned_amount || 0
  };
}

function normalizeSfmp(record) {
  return {
    source_system: "SFMP",
    application_id: record.ref_id,
    scheme: record.fellowship_type,
    status: STATUS_MAP[record.current_status] || "unknown",
    pending_documents: record.pending_items,
    last_updated: record.updated_on,
    amount: record.amount_disbursed_inr || 0
  };
}

function normalizeNos(record) {
  return {
    source_system: "NOS",
    application_id: record.id,
    scheme: "NOS",
    status: STATUS_MAP[record.state] || "unknown",
    pending_documents: record.remarks ? [record.remarks] : [],
    last_updated: record.last_action_date,
    amount: record.amount || 0
  };
}

/**
 * Returns a single normalized list of every application a student has,
 * regardless of which legacy system it lives in.
 */
function getUnifiedDashboard(studentId) {
  const applications = [
    ...nsp.getApplicationsByStudent(studentId).map(normalizeNsp),
    ...sfmp.getApplicationsByStudent(studentId).map(normalizeSfmp),
    ...nos.getApplicationsByStudent(studentId).map(normalizeNos)
  ];

  const totalDisbursed = applications.reduce((sum, a) => sum + a.amount, 0);

  return {
    student_id: studentId,
    total_disbursed: totalDisbursed,
    application_count: applications.length,
    applications
  };
}

module.exports = { getUnifiedDashboard };