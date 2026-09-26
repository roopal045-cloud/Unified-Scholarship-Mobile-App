const express = require("express");
const router = express.Router();
const disbursementService = require("../services/disbursementService");

// GET /api/disbursement/:applicationId
router.get("/:applicationId", (req, res) => {
  const status = disbursementService.getDisbursementStatus(req.params.applicationId);
  res.json(status);
});

module.exports = router;