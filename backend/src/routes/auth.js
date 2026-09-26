const express = require("express");
const jwt = require("jsonwebtoken");
const router = express.Router();

// Hardcoded secret for the hackathon demo only - never do this in production.
const JWT_SECRET = "hackathon-demo-secret";

// Mock student directory - stands in for a real Aadhaar/OTR lookup.
const MOCK_STUDENTS = {
  "STU-1001": { student_id: "STU-1001", full_name: "Anita Oraon", state: "Jharkhand" },
  "STU-1002": { student_id: "STU-1002", full_name: "Ravi Munda", state: "Odisha" },
  "STU-1003": { student_id: "STU-1003", full_name: "Meena Bhil", state: "Madhya Pradesh" },
  "STU-1004": { student_id: "STU-1004", full_name: "Sunita Kumari", state: "Chhattisgarh" }
};

// POST /api/auth/login
// Body: { "studentId": "STU-1001" }
// In the real system this step would verify an Aadhaar OTP first.
router.post("/login", (req, res) => {
  const { studentId } = req.body;
  const student = MOCK_STUDENTS[studentId];

  if (!student) {
    return res.status(404).json({ error: "Student not found" });
  }

  const token = jwt.sign({ student_id: student.student_id }, JWT_SECRET, { expiresIn: "12h" });

  res.json({ token, profile: student });
});

module.exports = router;