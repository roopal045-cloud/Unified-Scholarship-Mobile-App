const express = require("express");
const router = express.Router();
const coverageGapService = require("../services/coverageGapService");

// GET /api/coverage-gap
// Ministry-facing endpoint: ST students enrolled per UDISE+/APAAR/OTR
// but not availing any scholarship across NSP, SFMP, or NOS.
router.get("/", (req, res) => {
  const result = coverageGapService.findCoverageGap();
  res.json(result);
});

module.exports = router;