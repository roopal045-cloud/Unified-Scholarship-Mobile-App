# Screen reference

Design language: navy #0B3D91 header with National Emblem placeholder and tricolor strip,
saffron #FF9933 accents, green #138808 for success/verified states, Noto Sans typography
(font falls back to system default — never actually registered in pubspec.yaml),
bordered/sectioned layout (see `frontend/lib/theme/app_theme.dart` for exact tokens).

All screens below are built, wired to the live backend, and tested end-to-end.

## Student-facing screens

### Login (`login_screen.dart`)
Navy header with tricolor strip. Student ID field → "Send OTP" → OTP field appears →
"Verify and continue" → calls the real login API, navigates to the dashboard shell.
Includes a "Ministry official? Login here" link to the separate Ministry flow.

### Dashboard (`dashboard_screen.dart`)
Header, "Total amount disbursed" summary with an Ashoka Emblem watermark behind it,
a notification bell (fires and fetches real milestone alerts), a "+ Apply for new
scheme" button (→ Eligibility Check screen), and a bordered ledger-style row per
application with a 4-stage progress line (Submitted → Verified → Sanctioned →
Disbursed). Footer strip shows "Grievance Redressal" and a live "Last synced" time.

### Applications (`applications_screen.dart`)
Full list of every application for the logged-in student — same ledger-row widget
as the Dashboard, reused. Tapping a row opens the Application Detail screen.

### Application Detail (`application_detail_screen.dart`)
Full timeline/audit-trail view for one application. Shows the deficiency note in
full when an application is flagged.

### Document Wallet (`document_wallet_screen.dart`)
Documents derived from the student's real applications (there is no separate
document-storage backend). A flagged application contributes a rejected entry
per pending document; other applications contribute a "supporting documents"
entry, verified or pending based on status. Shows a "needs attention" badge
when any document is rejected.

### JAGO Chatbot (`chatbot_screen.dart`)
Bordered chat bubbles, English/Hindi toggle, 4 suggested-intent chips plus a
free-text input with keyword matching. All replies pull the student's live
application data — no hardcoded copy remaining. See `chatbot-demo-script.md`
for the exact demo flow.

### Eligibility Check (`eligibility_check_screen.dart`)
Reached from the Dashboard's "+ Apply for new scheme" button. Calls the real
eligibility API and shows either a green "you are eligible" state (zero
existing applications) or a red "blocked" state naming the existing application
that prevents a new one — enforcing the "one scheme at a time" rule from the
problem statement. "Continue to apply" beyond this point is an intentional
placeholder; no application-submission form was built (out of scope).

### Profile (`profile_screen.dart`)
Real name, student ID, state, category, and a working Log out button that
returns to the login screen.

## Ministry-facing screens (separate flow, not linked from student login's main path)

### Ministry Login (`ministry_login_screen.dart`)
Separate login form, reached via a small link on the student login screen.
Mock credentials: username `admin`, password `mota2026`. Not connected to any
student account or student data.

### Coverage Gap Dashboard (`coverage_gap_screen.dart`)
Reached only after Ministry login. Three stat cards (enrolled checked, covered,
gap count) and a list of ST students who are enrolled per UDISE+/APAAR/OTR but
not availing any scholarship — cross-referenced live against the 3 mock
adapters. Has its own back button rather than the student bottom nav.

## Known placeholders / not built
- **National Emblem** — `Icons.account_balance` placeholder; swap for the real
  asset before final submission, or disclose in the pitch as pending clearance
  under the State Emblem of India Act.
- **Noto Sans font** — referenced in the theme but never registered in
  `pubspec.yaml`; falls back to the system default font silently. Cosmetic only.
- **Application-submission form** — intentionally out of scope; the eligibility
  check is the last built step in that flow.