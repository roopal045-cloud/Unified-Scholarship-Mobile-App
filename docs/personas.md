# Demo personas

These are the actual mock student accounts in the backend (`backend/src/routes/auth.js`).
Use these exact names, IDs, and details when narrating the live demo.

## 1. Anita Oraon (STU-1001) — the unification story
- State: Jharkhand
- Two applications, both "under verification": Pre-Matric Scholarship (NSP) and
  National Fellowship / NFST (SFMP)
- Use her to open the demo: she has applications in two different legacy systems,
  both showing correctly in one unified dashboard
- Narrative line: "Anita has applications in two systems that used to be
  completely separate. She now sees both in one place."

## 2. Ravi Munda (STU-1002) — the sanctioned case
- State: Odisha
- One application: Post-Matric Scholarship, status "sanctioned"
- Use him to show a clean, positive status further along the timeline
- Narrative line: "Ravi's scholarship has been sanctioned. He can see exactly
  where he stands, without calling anyone."

## 3. Meena Bhil (STU-1003) — the disbursed case
- State: Madhya Pradesh
- One application: Top Class Education Scheme, status "disbursed"
- Use her to show the very end of the journey — money actually paid out
- Narrative line: "Meena's scholarship has already been disbursed. The full
  journey, start to finish, is visible in one screen."

## 4. Sunita Kumari (STU-1004) — the centerpiece: document mismatch, not rejection
- State: Chhattisgarh
- One application: National Overseas Scholarship (NOS), status "action_required"
  (document mismatch)
- **This is the most important persona for the pitch.** It demonstrates the core
  design principle: a mismatch is routed for correction, not used to reject the
  application outright.
- Use her for both the Document Wallet (shows the flagged document) and the
  JAGO chatbot demo (ask about status, deficiency, and documents required — see
  `chatbot-demo-script.md`)
- Narrative line: "Sunita's documents didn't match on the first try. In the old
  system, that could mean silence for weeks. Here, she's told exactly what's
  wrong and exactly what to fix."

## 5. Arjun Meena (STU-1005) — eligible to apply, and a coverage-gap case
- State: Rajasthan
- Zero applications — the only mock student with none
- Use him for the **eligibility-check screen**: logging in as him and tapping
  "+ Apply for new scheme" shows the green "you are eligible" state, unlike
  every other persona above (who would all show blocked)
- He also appears in the **Ministry coverage-gap dashboard** — enrolled per
  UDISE+/APAAR but not availing any scholarship
- Narrative line: "Arjun hasn't applied to anything yet, so he's cleared to
  start — and he's also exactly the kind of student the Ministry's outreach
  dashboard is built to find."

## Suggested demo order
1. **Anita Oraon** — dashboard, prove the unification across NSP + SFMP
2. **Ravi Munda** or **Meena Bhil** — quick pass through a positive status further along
3. **Sunita Kumari** — the centerpiece: Document Wallet, Application Detail, then
   JAGO chatbot Q&A on her case (English, then toggle to Hindi)
4. **Arjun Meena** — eligibility check (green "eligible" state), then log out and
   log into the separate **Ministry login** (username `admin`, password `mota2026`)
   to show him appearing on the coverage-gap outreach dashboard