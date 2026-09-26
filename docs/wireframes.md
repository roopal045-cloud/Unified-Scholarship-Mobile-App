# Screen reference

Design language: navy #0B3D91 header with National Emblem placeholder and tricolor strip,
saffron #FF9933 accents, green #138808 for success/verified states, Noto Sans typography,
bordered/sectioned layout (see `frontend/lib/theme/app_theme.dart` for exact tokens).

## Built and working

### Login screen (`login_screen.dart`)
Navy header with tricolor strip. Two-step form: enter Student ID / mobile number →
"Send OTP" → OTP field appears → "Verify and continue" → navigates to Dashboard.
No real Aadhaar integration for the demo.

### Dashboard (`dashboard_screen.dart`)
Header, then a "Total amount disbursed" summary card with an Ashoka Emblem watermark
behind it, then a bordered ledger-style row per application (scheme name, ID, status
chip, 4-stage progress line: Submitted → Verified → Sanctioned → Disbursed). Footer
strip at the bottom shows "Grievance Redressal" and a "Last synced" timestamp.
Tapping a row opens the Application Detail screen.

### Application Detail screen (`application_detail_screen.dart`)
Full timeline/audit-trail view for one application, using the same 4-stage model.
Shows the deficiency note in full when an application is flagged Action Required.

### Document Wallet (`document_wallet_screen.dart`)
Lists documents tied to applications, styled with the same bordered-row pattern.

### JAGO Chatbot (`chatbot_screen.dart`)
Bordered chat bubbles (no rounded fintech shape), 4 suggested-intent chips, plus a
free-text input with basic keyword matching. Real copy for all 4 intents as of this
build; references the flagged demo persona (Sunita Kumari) for status/deficiency answers.

## Not yet built

### Applications tab (bottom nav, 2nd tab)
Currently shows a "coming soon" placeholder in `dashboard_shell.dart`. Should show a
full list of all applications (not just the dashboard summary), reusing
`ApplicationLedgerRow`. This is a quick win — the widget already exists, it just
needs to be wired into this tab instead of the placeholder.

### Profile tab (bottom nav, 5th tab)
Currently a placeholder. Needs: student name, ST/PVTG status, state, and a logout
action at minimum.

### Eligibility-check screen
Not built. Per the original problem statement, this should appear before a student
starts a new application, warning them if they already hold an active scholarship
(the "one scheme at a time" rule). Depends on B's eligibility-check API, which is
also not yet built as of this doc.

### National Emblem asset
Currently a placeholder icon (`Icons.account_balance`). Swap for the real emblem
image before final submission if time allows — otherwise mention in the pitch that
it's a placeholder pending official clearance under the State Emblem of India Act.