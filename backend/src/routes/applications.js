const express = require("express");
const router = express.Router();
const aggregationService = require("../services/aggregationService");

// GET /api/applications/:studentId
// Returns the unified dashboard - every application across NSP, SFMP, and NOS,
// normalized into one shared format.
router.get("/:studentId", (req, res) => {
  const { studentId } = req.params;
  const dashboard = aggregationService.getUnifiedDashboard(studentId);

  // Zero applications is a valid state (e.g. a student who hasn't applied
  // to any scheme yet) - not an error. The frontend shows an empty-state
  // dashboard rather than an error screen for this case.
  res.json(dashboard);
});

module.exports = router;