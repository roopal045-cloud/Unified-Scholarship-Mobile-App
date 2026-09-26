# API Contract — Unified Scholarship App Backend

Base URL (local dev): `http://localhost:3000`
Stack: Node.js / Express
Auth: JWT (Bearer token), issued by `/api/auth/login`, secret is hardcoded for the hackathon build only (`hackathon-demo-secret` in `src/routes/auth.js`) — **do not reuse this pattern beyond the demo**.

Shared status vocabulary used across every endpoint that returns an application:
`under_verification` · `sanctioned` · `disbursed` · `action_required`

Current demo dataset covers 4 students across 3 source systems (NSP, SFMP, NOS) and 5 scholarship applications, spanning all four statuses above (see §5).

---

## 1. Health check

**GET /**

No auth required.

Response `200`:
```json
{ "status": "Unified Scholarship API is running" }
```

---

## 2. Auth

### POST /api/auth/login

Mock Aadhaar/OTP login. No real OTP verification in the hackathon build — any known `studentId` logs in.

**Request body:**
```json
{ "studentId": "STU-1001" }
```

**Response `200`:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "profile": {
    "student_id": "STU-1001",
    "full_name": "Anita Oraon",
    "state": "Jharkhand"
  }
}
```

**Response `404`** (unknown studentId):
```json
{ "error": "Student not found" }
```

Token payload: `{ student_id }`, expires in 12h.

**Known mock students:** `STU-1001` (Anita Oraon, Jharkhand), `STU-1002` (Ravi Munda, Odisha), `STU-1003` (Sunita Bhil, Madhya Pradesh), `STU-1004` (Deepak Gond, Chhattisgarh).

### GET /api/auth/profile — **not yet implemented**

Planned: token-authenticated, returns the same profile shape as login without requiring re-login. Not built as of this doc — frontend should keep using the profile object returned at login until this lands.

---

## 3. Applications

### GET /api/applications/:studentId

Returns the unified dashboard — every application across NSP, SFMP, and NOS for one student, normalized into one shared shape (this is the core "unify three legacy portals" endpoint).

**Path param:** `studentId` (e.g. `STU-1001`)

**Response `200`:**
```json
{
  "student_id": "STU-1001",
  "total_disbursed": 0,
  "application_count": 2,
  "applications": [
    {
      "source_system": "NSP",
      "application_id": "NSP2026PM001234",
      "scheme": "PRE_MATRIC_ST",
      "status": "under_verification",
      "pending_documents": ["income_certificate", "caste_certificate"],
      "last_updated": "2026-08-14",
      "amount": 0
    },
    {
      "source_system": "SFMP",
      "application_id": "SFMP-NFST-88231",
      "scheme": "NFST",
      "status": "under_verification",
      "pending_documents": ["net_jrf_certificate"],
      "last_updated": "2026-09-10",
      "amount": 0
    }
  ]
}
```

Every application object has this exact shape regardless of source system — `source_system`, `application_id`, `scheme`, `status`, `pending_documents` (array, may be empty), `last_updated`, `amount`. This normalization is what lets the frontend render one ledger-row component for all three portals.

**Response `404`** (no applications for this student):
```json
{ "error": "No applications found for this student" }
```

---

## 4. Verification

### POST /api/verification/check

Runs a single document check for one application. Routes to the correct source system internally based on document type — caller doesn't need to know which portal owns which document type.

**Request body:**
```json
{
  "applicationId": "SFMP-NFST-88231",
  "docType": "net_jrf_certificate"
}
```

**Response `200`** (auto-cleared):
```json
{ "status": "auto_cleared", "docType": "net_jrf_certificate", "source": "SFMP" }
```

**Response `200`** (mismatch — routed to manual review, does *not* block the application):
```json
{ "status": "manual_review", "docType": "net_jrf_certificate", "source": "SFMP" }
```

**Response `200`** (unrecognized document type):
```json
{ "status": "unknown_document_type", "docType": "some_unknown_type" }
```

**Response `400`** (missing params):
```json
{ "error": "applicationId and docType are required" }
```

**Document type → source system routing** (from `verificationService.js`):
| docType | Source |
|---|---|
| income_certificate, caste_certificate, academic_records | NSP |
| net_jrf_certificate, institution_letter | SFMP |
| admission_letter, passport | NOS |

Note: match/mismatch is simulated randomly per adapter (`Math.random()` threshold, varies 60–75% match rate by adapter) — not deterministic. Don't rely on a fixed docType always returning the same result across calls. (One exception: `SFMP-NFST-88231` + `net_jrf_certificate` is now hardcoded to always mismatch, for demo reliability.)

### GET /api/verification/review-queue

Returns everything currently sitting in manual review — this is the list a state official would work through in the real system.

**Response `200`:**
```json
[
  {
    "applicationId": "SFMP-NFST-88231",
    "docType": "net_jrf_certificate",
    "source": "SFMP",
    "flaggedAt": "2026-09-26T10:15:00.000Z"
  }
]
```

Empty array `[]` if nothing has been flagged yet. This queue is in-memory and resets on server restart — it only fills up after `/api/verification/check` returns a mismatch, it is not pre-seeded.

---

## 5. Current demo dataset reference

| Student | Scheme | Source | Status | Amount |
|---|---|---|---|---|
| STU-1001 | PRE_MATRIC_ST | NSP | under_verification | ₹0 |
| STU-1001 | NFST | SFMP | under_verification | ₹0 |
| STU-1002 | POST_MATRIC_ST | NSP | sanctioned | ₹12,400 |
| STU-1003 | TOP_CLASS | SFMP | disbursed | ₹2,00,000 |
| STU-1004 | (NOS overseas) | NOS | action_required (document mismatch) | ₹0 |

This set already covers every status value and gives one clean `action_required` demo path (STU-1004) — no adapter changes needed unless the team narrows demo scope to fewer schemes, in which case trim the unused adapter entries rather than deleting whole adapter files (NSP/SFMP/NOS as three distinct systems is itself part of the pitch).