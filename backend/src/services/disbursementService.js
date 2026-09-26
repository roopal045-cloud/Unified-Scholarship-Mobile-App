// Mock DBT (Direct Benefit Transfer) disbursement status + a notification
// trigger stub. Same in-memory pattern as verificationService.js's review queue.

const dbtRecords = {
  "NSP2026POM004521": { // STU-1002, sanctioned but not yet disbursed
    dbtStatus: "pending",
    bankAccountLast4: "4821",
    utrNumber: null,
    disbursedOn: null
  },
  "SFMP-TC-55210": { // STU-1003, already disbursed
    dbtStatus: "processed",
    bankAccountLast4: "7739",
    utrNumber: "UTR2026091044213",
    disbursedOn: "2026-09-18"
  }
};

const notifications = [];

function getDisbursementStatus(applicationId) {
  const record = dbtRecords[applicationId];
  if (!record) {
    return {
      applicationId,
      dbtStatus: "not_applicable",
      reason: "No disbursement record - application has not reached the Sanctioned stage yet."
    };
  }
  return { applicationId, ...record };
}

function buildMessage(milestone) {
  const messages = {
    sanctioned: "Your scholarship application has been sanctioned. Disbursement will follow shortly.",
    disbursed: "Your scholarship amount has been disbursed to your linked bank account via DBT.",
    action_required: "Your scholarship application requires attention. Please check the app for details."
  };
  return messages[milestone] || `Update on your application: ${milestone}`;
}

function triggerNotification({ studentId, applicationId, milestone }) {
  const notification = {
    studentId,
    applicationId,
    milestone,
    message: buildMessage(milestone),
    sentAt: new Date().toISOString()
  };
  notifications.push(notification);
  return notification;
}

function getNotificationsForStudent(studentId) {
  return notifications.filter(n => n.studentId === studentId);
}

module.exports = {
  getDisbursementStatus,
  triggerNotification,
  getNotificationsForStudent
};