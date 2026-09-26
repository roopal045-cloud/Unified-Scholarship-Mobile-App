const express = require("express");
const router = express.Router();
const eligibilityService = require("../services/eligibilityService");

// GET /api/eligibility/:studentId
// Checked before a student is allowed to start a new scheme application.
router.get("/:studentId", (req, res) => {
  const result = eligibilityService.checkEligibility(req.params.studentId);
  res.json(result);
});

module.exports = router;