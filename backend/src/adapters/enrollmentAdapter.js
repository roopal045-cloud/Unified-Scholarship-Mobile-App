// Mock adapter simulating enrollment data from UDISE+, APAAR, and OTR
// (One-Time Registration). In reality this would be a cross-government
// data match; here it's a static list of ST students known to be
// currently enrolled in a recognised institution.
//
// Deliberately includes some student IDs that already exist in
// MOCK_STUDENTS (auth.js) - those already hold scholarships - and some
// that don't - those are the "coverage gap" candidates.

const MOCK_ENROLLMENT_RECORDS = [
  { student_id: "STU-1001", full_name: "Anita Oraon", school: "Govt. Model School, Ranchi", state: "Jharkhand", grade: "Class 11" },
  { student_id: "STU-1002", full_name: "Ravi Munda", school: "St. Xavier's College", state: "Odisha", grade: "B.A. 2nd Year" },
  { student_id: "STU-1003", full_name: "Meena Bhil", school: "Govt. Polytechnic, Indore", state: "Madhya Pradesh", grade: "Diploma 3rd Year" },
  { student_id: "STU-1004", full_name: "Sunita Kumari", school: "University of Delhi", state: "Chhattisgarh", grade: "M.A. 1st Year" },
  { student_id: "STU-1005", full_name: "Arjun Meena", school: "Govt. Engineering College, Jaipur", state: "Rajasthan", grade: "B.Tech 2nd Year" },
  // The following are enrolled per UDISE+/APAAR but have no scholarship
  // application in NSP, SFMP, or NOS - these are the coverage gap.
  { student_id: "STU-2001", full_name: "Kavita Halder", school: "Govt. Girls School, Balasore", state: "Odisha", grade: "Class 10" },
  { student_id: "STU-2002", full_name: "Birsa Munda Jr.", school: "Govt. Higher Secondary, Ranchi", state: "Jharkhand", grade: "Class 12" },
  { student_id: "STU-2003", full_name: "Lakshmi Gond", school: "Govt. Degree College, Bastar", state: "Chhattisgarh", grade: "B.Sc. 1st Year" },
  { student_id: "STU-2004", full_name: "Ramesh Sabar", school: "Govt. ITI, Bhopal", state: "Madhya Pradesh", grade: "ITI 2nd Year" },
];

function getAllEnrollmentRecords() {
  return MOCK_ENROLLMENT_RECORDS;
}

module.exports = { getAllEnrollmentRecords };