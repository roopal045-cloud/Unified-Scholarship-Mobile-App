# Pitch deck outline

Target: ~7 slides, ~5-7 minutes including live demo. Keep every slide text-first —
no stock photos, no decorative graphics. Reuse the workflow diagrams from planning
if useful (student journey, verification-layer branching diagram).

## 1. Problem
- MoTA runs 5 scholarship schemes across 3 disconnected systems (NSP, SFMP, NOS)
- A student availing more than one scheme has no single view of status or funds
- Multiple manual verification steps (identity, ST/PVTG status, income, academic
  records) cause delay and repetitive documentation
- One line, stated plainly: "A student today cannot see all their scholarships
  in one place, and neither can the Ministry."

## 2. Solution overview
- One unified, mobile-first Scholarship Module across all 5 schemes
- Three components: unified dashboard, JAGO chatbot, verification & integration layer
- Built to sit ON TOP of the existing 3 systems, not replace them — lower
  integration risk, faster to actually deploy in the real Ministry environment

## 3. Architecture
- Diagram: 3 legacy systems → verification/aggregation layer → one Flutter app
- Call out explicitly: mismatches route to manual review, they never block
  the application — this is the single most important design decision to state
  out loud to judges, since it directly answers "what happens when data doesn't match"

## 4. Live demo
- Walk through the 4 personas in `personas.md`, in this order: Ramesh (proof
  the unification works across 2 systems) → Deepika (real-time status) →
  Sunita (the flagged/deficiency flow — the centerpiece) → chatbot Q&A on Sunita's case
- Note: rehearse this exact sequence at least twice before presenting — a smooth
  persona walkthrough reads as far more credible than jumping between random data

## 5. Technical implementation
- Stack: Flutter (frontend), Node/Express (backend), mock adapters simulating
  NSP/SFMP/NOS pending real API access from those systems
- Brief mention: DB schema designed for Postgres (see `backend/schema.sql`),
  currently running in-memory for the demo

## 6. Impact
- Reduces repetitive documentation and manual verification delay
- Coverage-gap identification: matching UDISE+/APAAR/OTR data to find ST students
  enrolled but not availing any scholarship, enabling targeted outreach
  (mention as designed, even if not fully built in the demo)

## 7. What's next / limitations (be upfront, don't wait for judges to ask)
- Real API integration with NSP/SFMP/NOS pending Ministry/agency access
- National Emblem is a placeholder pending official clearance
- Eligibility-check screen (enforcing "one scheme at a time") is designed but
  not fully implemented in this build
- Multilingual chatbot support is scoped but not built for this demo

