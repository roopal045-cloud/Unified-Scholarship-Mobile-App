const nsp = require("../adapters/nspAdapter");
const sfmp = require("../adapters/sfmpAdapter");
const nos = require("../adapters/nosAdapter");

// In-memory manual review queue for the hackathon demo.
// A real system would persist this in the DB (see verification_status table in schema.sql).
const manualReviewQueue = [];
// Hardcoded so the manual-review demo path is guaranteed, not left to
// the adapters' random match/mismatch simulation.
const FORCED_MISMATCHES = {
  "SFMP-NFST-88231": ["net_jrf_certificate"]
};
// Maps a document type to which source system should verify it.
// Mirrors the table from the problem statement (AISHE, UDISE+, UGC-NTA, e-District, etc.)
function getSourceAdapter(docType) {
  const sourceMap = {
    income_certificate: nsp,
    caste_certificate: nsp,
    academic_records: nsp,
    net_jrf_certificate: sfmp,
    institution_letter: sfmp,
    admission_letter: nos,
    passport: nos
  };
  return sourceMap[docType] || null;
}

/**
 * Verifies a single document for an application.
 * If it matches, it's auto-cleared. If not, it's routed to manual review
 * rather than blocking the application - this is the key design principle
 * from the reform brief.
 */
function verifyDocument(applicationId, docType) {
  const adapter = getSourceAdapter(docType);
 const isForcedMismatch =
    FORCED_MISMATCHES[applicationId] &&
    FORCED_MISMATCHES[applicationId].includes(docType);
  if (!adapter) {
    return { status: "unknown_document_type", docType };
  }

  const result = adapter.verifyDocument(docType);

   if (result.matched && !isForcedMismatch) {
    return {
      status: "auto_cleared",
      docType,
      source: result.source
    };
  }

  // Mismatch - route to manual review, do not block the application.
  const reviewItem = {
    applicationId,
    docType,
    source: result.source,
    flaggedAt: new Date().toISOString()
  };
  manualReviewQueue.push(reviewItem);

  return {
    status: "manual_review",
    docType,
    source: result.source
  };
}

function getManualReviewQueue() {
  return manualReviewQueue;
}

module.exports = { verifyDocument, getManualReviewQueue };