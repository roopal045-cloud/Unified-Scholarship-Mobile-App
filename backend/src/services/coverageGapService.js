const enrollmentAdapter = require("../adapters/enrollmentAdapter");
const nsp = require("../adapters/nspAdapter");
const sfmp = require("../adapters/sfmpAdapter");
const nos = require("../adapters/nosAdapter");

// Cross-references enrollment data (UDISE+/APAAR/OTR) against all 3
// scholarship systems to find ST students who are enrolled but have no
// scholarship application anywhere. Enables targeted Ministry outreach,
// per the problem statement's secondary goal.
function findCoverageGap() {
  const enrolled = enrollmentAdapter.getAllEnrollmentRecords();

  const gapStudents = enrolled.filter((student) => {
    const hasNsp = nsp.getApplicationsByStudent(student.student_id).length > 0;
    const hasSfmp = sfmp.getApplicationsByStudent(student.student_id).length > 0;
    const hasNos = nos.getApplicationsByStudent(student.student_id).length > 0;
    return !hasNsp && !hasSfmp && !hasNos;
  });

  return {
    total_enrolled_checked: enrolled.length,
    covered_count: enrolled.length - gapStudents.length,
    gap_count: gapStudents.length,
    gap_students: gapStudents,
  };
}

module.exports = { findCoverageGap };