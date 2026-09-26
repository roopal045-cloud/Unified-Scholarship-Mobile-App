const aggregationService = require("./aggregationService");

// Enforces the "one scheme at a time" rule from the problem statement:
// a student holding any existing application (regardless of its status)
// is not eligible to start a new one until that one is closed out.
function checkEligibility(studentId) {
  const dashboard = aggregationService.getUnifiedDashboard(studentId);

  if (dashboard.application_count === 0) {
    return {
      eligible: true,
      reason: "No existing scholarship applications found. You are eligible to apply.",
      existingApplication: null
    };
  }

  const existing = dashboard.applications[0];

  return {
    eligible: false,
    reason: `You already hold an active application ("${existing.scheme}", status: ` +
      `${existing.status}). Only one scholarship or fellowship scheme may be held at a time.`,
    existingApplication: existing
  };
}

module.exports = { checkEligibility };