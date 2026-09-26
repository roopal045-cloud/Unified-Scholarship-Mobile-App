const express = require("express");
const router = express.Router();
const verificationService = require("../services/verificationService");

// POST /api/verification/check
// Body: { "applicationId": "SFMP-NFST-88231", "docType": "net_jrf_certificate" }
// Runs a single document check and returns whether it was auto-cleared
// or sent to manual review.
router.post("/check", (req, res) => {
  const { applicationId, docType } = req.body;

  if (!applicationId || !docType) {
    return res.status(400).json({ error: "applicationId and docType are required" });
  }

  const result = verificationService.verifyDocument(applicationId, docType);
  res.json(result);
});

// GET /api/verification/review-queue
// Returns everything currently sitting in manual review - this is the
// list a state official would work through in the real system.
router.get("/review-queue", (req, res) => {
  res.json(verificationService.getManualReviewQueue());
});

module.exports = router;