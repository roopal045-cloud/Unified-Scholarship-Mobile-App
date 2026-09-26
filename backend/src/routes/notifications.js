const express = require("express");
const router = express.Router();
const disbursementService = require("../services/disbursementService");

// POST /api/notifications/trigger
router.post("/trigger", (req, res) => {
  const { studentId, applicationId, milestone } = req.body;
  if (!studentId || !applicationId || !milestone) {
    return res.status(400).json({ error: "studentId, applicationId and milestone are required" });
  }
  const notification = disbursementService.triggerNotification({ studentId, applicationId, milestone });
  res.json(notification);
});

// GET /api/notifications/:studentId
router.get("/:studentId", (req, res) => {
  const list = disbursementService.getNotificationsForStudent(req.params.studentId);
  res.json(list);
});

module.exports = router;