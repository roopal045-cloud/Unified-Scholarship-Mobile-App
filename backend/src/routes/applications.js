const express = require("express");
const router = express.Router();
const aggregationService = require("../services/aggregationService");

// GET /api/applications/:studentId
// Returns the unified dashboard - every application across NSP, SFMP, and NOS,
// normalized into one shared format.
router.get("/:studentId", (req, res) => {
  const { studentId } = req.params;
  const dashboard = aggregationService.getUnifiedDashboard(studentId);

  if (dashboard.application_count === 0) {
    return res.status(404).json({ error: "No applications found for this student" });
  }

  res.json(dashboard);
});

module.exports = router;