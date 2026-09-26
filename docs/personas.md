# Demo personas

These personas match the real backend data (see `backend/src/adapters/` and
`backend/src/routes/auth.js`), reachable by logging in with the student IDs noted below.
Use these exact names, IDs, and details when narrating the live demo, so the story stays
consistent with what judges see on screen. (The old `dummyApplications` list in
`scholarship_application.dart` is unused dead code — ignore it.)
## 1. Ramesh Oraon — the straightforward success story
- Two applications, both fully disbursed: Pre-Matric Scholarship (₹12,000) and the
  Eklavya Model Residential School Scheme (₹8,000)
- Use him to show the "happy path": submitted → verified → sanctioned → disbursed,
  with no friction, across two different schemes and two different legacy systems
- Narrative line: "Ramesh applied for two schemes through what used to be two separate
  portals. He now sees both in one place, and both have already been paid out."

## 2. Deepika Bhagat — the in-progress case
- One application: Post-Matric Scholarship, currently Sanctioned (₹25,000), awaiting disbursement
- Use her to show the middle of the journey — the app tells her exactly what stage she's
  at and what happens next, instead of leaving her guessing
- Narrative line: "Deepika doesn't have to call anyone to ask if she's been approved.
  She can see it, right here, updated automatically."

## 3. Sunita Kumari — the centerpiece: document mismatch, not rejection
- Login as STU-1004. One application: National Overseas Scholarship (NOS), application
  ID NOS/2026/0091, destination country United Kingdom, flagged Action Required
- Deficiency: income certificate does not match the declared value on file
- This is the most important persona for the pitch — it demonstrates the core design
  principle that a mismatch is routed for correction, not used to reject the application
  outright, and it's also your clearest live proof that the standalone NOS portal
  (a third, separate legacy system) is genuinely integrated, not just NSP/SFMP
- Narrative line: "Sunita's documents didn't match on the first try. In the old system,
  that could mean silence for weeks. Here, she's told exactly what's wrong and exactly
  what to fix, immediately."

## 4. Arjun Meena — the just-getting-started case
- One application: Top Class Education Scheme, currently Submitted, no amount yet
- Use him to show the very start of the timeline and the eligibility-check screen
  (if built) — the "before you apply" moment
- Narrative line: "Arjun just submitted. He can already see every stage his
  application will move through, before any of them have happened."

## How to use these in the demo
Walk judges through the dashboard using all four in one pass: point at Ramesh's two
disbursed entries first (proof the unification works end-to-end), then Deepika's
sanctioned one (proof of real-time status), then land on Sunita's flagged entry and
open it — this is where the verification-layer story gets told in full, including
the manual review queue on the backend side.