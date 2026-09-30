<div align="center">

# ShikshaSetu (शिक्षा सेतु)

### Unified Scholarship Mobile Application for Tribal Students

*One app. One login. Every scholarship.*

</div>

---

## Hackathon Details

| | |
|---|---|
| **Hackathon** | Smart India Hackathon (SIH) 2026 |
| **Problem Statement ID** | SIH26238 |
| **Problem Statement Title** | Unified Scholarship Mobile Application for Tribal Students |
| **Theme** | Smart Automation |
| **Category** | Software |
| **Team Name** | BhashaMitra |
| **Team ID** | 143591 |
| **Proposed App** | ShikshaSetu (शिक्षा सेतु), an Android mobile application |

---

## Table of Contents

1. [About the Project](#1-about-the-project)
2. [Problem Statement](#2-problem-statement)
3. [Our Solution](#3-our-solution)
4. [Key Features](#4-key-features)
5. [Innovation and Uniqueness](#5-innovation-and-uniqueness)
6. [System Architecture](#6-system-architecture)
7. [Application Workflow](#7-application-workflow)
8. [Technology Stack and Why We Chose It](#8-technology-stack-and-why-we-chose-it)
9. [Integrations](#9-integrations)
10. [Project Structure](#10-project-structure)
11. [Getting Started](#11-getting-started)
12. [API Documentation](#12-api-documentation)
13. [Feasibility and Viability](#13-feasibility-and-viability)
14. [Challenges and Potential Solutions](#14-challenges-and-potential-solutions)
15. [Impact and Benefits](#15-impact-and-benefits)
16. [Future Scope](#16-future-scope)
17. [Documentation and Design Assets](#17-documentation-and-design-assets)
18. [References](#18-references)
19. [License](#19-license)

---

## 1. About the Project

**ShikshaSetu** ("Bridge to Education") is a mobile-first platform that brings the central scholarship schemes for Scheduled Tribe (ST) students into a single app. Students log in once and can check eligibility, apply, upload documents, track verification, and follow sanction and DBT (Direct Benefit Transfer) payments across schemes. The Ministry gets a consolidated view and a **coverage-gap dashboard** that finds enrolled ST students who are not availing any scholarship.

The existing portals (NSP, SFMP and NOS) keep running unchanged. ShikshaSetu sits on top of them and connects them.

## 2. Problem Statement

Tribal students today face several connected problems:

| Problem | What happens today |
|---|---|
| **Fragmented systems** | Five schemes are spread across NSP, SFMP and NOS. There is no single view for the student or for the Ministry. |
| **Repetitive manual checks** | Identity, ST/PVTG status, income and academic records are verified by hand, separately for each scheme. |
| **A mismatch stalls everything** | One document error can hold up the whole application, and the student is not told why. |
| **Eligible students never reached** | ST students who are enrolled but availing no scheme are invisible to the Ministry. |

## 3. Our Solution

| Problem | ShikshaSetu's answer |
|---|---|
| Fragmented systems | **Unified dashboard, one login.** Every application from submission to sanction and DBT disbursement in one place. |
| Repetitive manual checks | **Automated verification layer.** Documents are checked against DigiLocker, UIDAI, e-District, AISHE, UDISE+, APAAR and UGC-NTA. |
| A mismatch stalls everything | **Routed, not rejected.** A mismatch goes to a manual review queue with a deficiency note. The **JAGO** chatbot explains what to correct and the application stays live. |
| Eligible students never reached | **Coverage-gap outreach.** Enrollment data (UDISE+, APAAR, OTR) is matched against scholarship records to flag students for Ministry outreach. |

**How it fits together**

```
Existing systems (unchanged)          One app · one login
┌─────────────────────────┐
│ NSP  Pre-Matric,        │
│      Post-Matric        │      ┌────────────────────────────────┐
│ SFMP (Canara Bank)      │ ───▶ │ Verification & Aggregation     │ ───▶ Unified dashboard
│      Top Class, NFST    │      │ Layer                          │      JAGO chatbot
│ NOS  National Overseas  │      │ Normalizes 3 data formats and  │      Digital document wallet
│      Scholarship        │      │ auto-checks each document at   │      Eligibility check
└─────────────────────────┘      │ its source                     │
                                 │ On mismatch: manual review     │
Govt. data sources               │ queue with a deficiency note.  │
DigiLocker · UIDAI · eDistrict   │ Never blocks the application.  │
AISHE · UDISE+ · APAAR · UGC-NTA └────────────────────────────────┘
```

## 4. Key Features

| Feature | Description |
|---|---|
| **Unified student dashboard** | Applications, progress, deficiencies, sanctions and DBT for all schemes in one view. |
| **Single login** | One login for all schemes. Aadhaar-OTP login is simulated in the prototype, and a JWT is issued for the session. |
| **Eligibility check** | Checks one scheme at a time and names the existing application that blocks a new one. |
| **Application management** | Apply for a scheme and track it end to end. |
| **Digital document wallet** | Upload documents once and reuse them, with the verification state and any deficiency shown for each. |
| **Automated verification** | Each document is checked at its source (DigiLocker, UIDAI, e-District, AISHE, UDISE+, APAAR, UGC-NTA). Matches move on automatically. |
| **Manual review with deficiency notes** | Mismatches are never auto-rejected. They go to a review queue with a note explaining what to fix. |
| **JAGO chatbot** | A student-specific assistant for status, pending documents, eligibility, deficiencies, payments and scheme queries, in **English and Hindi**. It answers from the student's live data. |
| **DBT and payment status** | Sanction and disbursement status consolidated across schemes. |
| **Notifications** | Milestone and reminder alerts by push, SMS, email and in-app. |
| **Ministry official login** | A separate login for Ministry officials. |
| **Coverage-gap outreach dashboard** | Matches enrollment records (UDISE+, APAAR, OTR) with scholarship records (NSP, SFMP, NOS) to find enrolled ST students availing no scheme, and flags them for outreach. |
| **Mobile-first and inclusive** | Light, simple interface for rural and first-time users, with language support and low-internet use in mind. |

### Coverage-gap identification logic

```
Enrollment records (UDISE+ / APAAR / OTR)
              │
              ▼
   Identify enrolled ST students
              │
              ▼
   Match against scholarship records (NSP + SFMP + NOS)
              │
              ▼
   Any scholarship application found?
        │                     │
       Yes                    No
        ▼                     ▼
 Covered: already        Potential gap:
 availing a scheme       flag for Ministry outreach
```

## 5. Innovation and Uniqueness

- **Multi-scheme platform.** Five schemes and three existing systems (NSP, SFMP, NOS) in one student-friendly interface.
- **Smart verification layer.** Less repetitive documentation, with exceptions going to manual review instead of rejection.
- **JAGO integrated assistance.** Personalised help in English and Hindi on eligibility, status, documents, deficiencies and payments.
- **Single student view.** Applications, verification status, pending actions, sanctions and DBT across all schemes.
- **Coverage-gap identification.** Proactive outreach to students who would otherwise never be seen.
- **Mobile-first and inclusive.** Designed for rural and first-time digital users.

## 6. System Architecture

ShikshaSetu has five layers.

```
┌──────────────────────────────────────────────────────────────────────┐
│ USER LAYER: Flutter mobile app                                       │
│ Student Dashboard · Applications · Document Wallet · JAGO Assistant  │
│ Eligibility Check · Notifications                                    │
└───────────────────────────────┬──────────────────────────────────────┘
                                │ HTTPS / REST API  ⇅  JSON responses
┌───────────────────────────────▼──────────────────────────────────────┐
│ BACKEND LAYER: Node.js + Express REST API                            │
│ Authentication (JWT / OAuth) · Application Management (CRUD, track)  │
│ Verification Engine · DBT & Payment Status · Notification Service    │
└───────────────────────────────┬──────────────────────────────────────┘
                                │ Internal API calls  ⇅  Processed data
┌───────────────────────────────▼──────────────────────────────────────┐
│ INTEGRATION LAYER: Microservices                                     │
│ Aggregation · Eligibility · Verification · Disbursement ·            │
│ Notification · Coverage-Gap                                          │
└───────────────┬───────────────────────────────────┬──────────────────┘
                │ Adapter calls to NSP·SFMP·NOS     │ Verification lookups
┌───────────────▼─────────────┐      ┌──────────────▼───────────────────┐
│ EXTERNAL SYSTEMS            │      │ GOVT. DATA SOURCES               │
│ NSP · SFMP · NOS            │      │ DigiLocker · UIDAI (Aadhaar)     │
└─────────────────────────────┘      │ e-District · AISHE / UDISE+      │
                                     │ APAAR · UGC / NTA                │
┌─────────────────────────────┐      └──────────────────────────────────┘
│ DATABASE LAYER: MongoDB     │
│ Users · Applications ·      │
│ Documents · Verification ·  │
│ Payments · Logs & analytics │
└─────────────────────────────┘
```

### Integration-layer services

| Service | Responsibility |
|---|---|
| **Aggregation Service** | Normalizes data from all portals into one common schema. |
| **Eligibility Service** | Applies scheme rules and checks existing applications (one scheme at a time). |
| **Verification Service** | Routes each check to the right official source. |
| **Disbursement Service** | Consolidates payment and DBT status. |
| **Notification Service** | Sends milestone and reminder alerts. |
| **Coverage-Gap Service** | Finds eligible, unenrolled students for outreach. |

## 7. Application Workflow

| Step | What happens |
|---|---|
| **1. Login** | Aadhaar-OTP login (simulated). A JWT is issued for the session. |
| **2. Dashboard loads** | The Aggregation Service normalizes NSP, SFMP and NOS data into one view. |
| **3. Eligibility check, then apply** | The Eligibility Service allows one scheme at a time. |
| **4. Documents verified** | The Verification Service routes each check to its source. **Match:** auto-verified and moves on. **Mismatch:** manual review with a deficiency note. |
| **5. Track status and DBT** | The Disbursement Service consolidates payment status. |
| **6. Notify** | Milestones and reminders by push, SMS, email and in-app. |
| **Runs alongside** | JAGO answers from the student's live data. The Coverage-Gap Service flags enrolled ST students who are availing no scheme. |

## 8. Technology Stack and Why We Chose It

| Layer | Technology | Why we chose it |
|---|---|---|
| **Frontend** | **Flutter · Dart** | One codebase gives a fast, smooth Android app, and the same code can later run on iOS and web. This suits a student base on a wide range of budget devices. Flutter's widget system let us build a consistent government-style theme quickly (header, tricolor strip, login screen), and its light footprint fits our low-internet, rural-user focus. |
| **Backend** | **Node.js · Express** | Non-blocking I/O suits our main job: calling several portal adapters and data sources at the same time and merging the results without one slow source blocking the rest. Express keeps the REST API simple and quick to build and extend. |
| **Database** | **MongoDB · Mongoose** | Applications, documents and verification results have different shapes for each scheme. A flexible document model lets a new scheme's fields be added without a migration, and Mongoose adds schema validation and structure where we need it. |
| **Authentication** | **JWT (JSON Web Token)** | Stateless, session-based access for the mobile app, and it lets us separate student and Ministry official roles cleanly. |
| **Integrations** | **NSP · SFMP · NOS** and Govt. data APIs | The scholarship portals hold the source of truth for applications. We integrate through adapters instead of replacing them. |
| **Notifications** | **Firebase Cloud Messaging (FCM)** | Free, reliable push notifications on Android, for deadlines, deficiencies and payment updates. |
| **AI chatbot** | **JAGO (LLM API)** | A language model lets JAGO understand free-form questions in English and Hindi, while its answers are grounded in the student's live application data. |
| **Deployment** | **Vercel / AWS or GCP** | Flexible hosting options that scale with usage and can run on existing government-approved cloud infrastructure. |
| **Version control and CI** | **GitHub** | Source hosting, collaboration between team members, and CI. |

**Design choices behind the stack**

- **Adapter pattern:** one adapter per portal converts three different data formats into one schema, so the rest of the platform never depends on portal-specific details. A new scheme is a new adapter and rule set. Today the adapters use **mock data**, and they swap to live APIs once agencies grant access.
- **Microservice-style integration layer:** each concern (aggregation, eligibility, verification, disbursement, notification, coverage-gap) can be built, tested and scaled on its own.
- **Open-source only:** Flutter, Node.js and MongoDB carry no licence cost.

## 9. Integrations

| Type | System | Used for |
|---|---|---|
| Scholarship APIs | **NSP** | Pre-Matric and Post-Matric scholarships |
| | **SFMP** (Canara Bank) | Top Class Education for ST, NFST |
| | **NOS** | National Overseas Scholarship |
| Verification sources | **DigiLocker** | Document verification |
| | **UIDAI (Aadhaar)** | Identity verification |
| | **e-District** | Caste, income and domicile |
| | **AISHE / UDISE+** | Educational details |
| | **APAAR** | Student academic ID |
| | **UGC / NTA** | University and exam data |
| Services | **Firebase Cloud Messaging** | Push notifications (planned) |
| | **LLM API** | JAGO assistance |

> **Prototype note:** Aadhaar-OTP login is simulated, and the scholarship and verification integrations use mock adapters. Live access depends on Ministry and agency data-sharing approval.

## 10. Project Structure

```
Unified-Scholarship-Mobile-App/
├── backend/
│   ├── src/                 # Routes, adapters, services, Ministry official dashboard logic
│   ├── server.js            # Backend entry point
│   ├── API_CONTRACT.md      # Endpoint documentation
│   └── package.json
├── docs/
│   ├── personas.md          # User personas
│   ├── wireframes.md        # Screen wireframes
│   └── pitch-deck-outline.md
├── frontend/                # Flutter app
│   ├── lib/                 # Dart source code
│   ├── android/ ios/ web/ linux/ macos/ windows/
│   ├── test/
│   └── pubspec.yaml
├── LICENSE
└── README.md
```

## 11. Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) and an Android emulator or device
- [Node.js](https://nodejs.org/) and npm
- [MongoDB](https://www.mongodb.com/) (local or Atlas)

### 1. Clone the repository

```bash
git clone https://github.com/roopal045-cloud/Unified-Scholarship-Mobile-App.git
cd Unified-Scholarship-Mobile-App
```

### 2. Run the backend

```bash
cd backend
npm install
npm start
```

Create a `.env` file in `backend/` with values like:

```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/shikshasetu
JWT_SECRET=your_secret_here
```

### 3. Run the Flutter app

```bash
cd frontend
flutter pub get
flutter run
```

Set the backend base URL in the app to your server address. On an Android emulator, `localhost` on your machine is reached at `10.0.2.2`.

## 12. API Documentation

The complete list of endpoints, request bodies and responses is in [`backend/API_CONTRACT.md`](backend/API_CONTRACT.md). It includes the scholarship, application, disbursement and notification endpoints.

## 13. Feasibility and Viability

| Area | Assessment |
|---|---|
| **Data** | Builds on data agencies already hold. NSP, SFMP and NOS keep running unchanged. One adapter per portal normalizes three data formats into one schema. |
| **Technical** | Proven stack (Flutter, Node.js, MongoDB), standard REST APIs, and verification through existing government data sources. |
| **Operational** | Runs on existing education-department infrastructure. Students get one login. Mismatches go to manual review, so officials stay in control. |
| **Economic** | Open-source technologies with no licence cost, reuse of government APIs and data, and one app and one backend to host and maintain. |
| **Legal and schedule** | Aligns with Govt. of India digital initiatives. Live API access via Ministry and agency data-sharing approval. The MVP is demonstrable within the project timeline. |

**Viability**

- **Social:** directly benefits tribal students by simplifying scholarship access and reducing dropouts.
- **User:** high demand from students, parents and educational institutions.
- **Scalability:** extends to more schemes, states and student categories.
- **Sustainability:** maintained by government at minimal added cost on existing digital infrastructure.
- **Long-term impact:** inclusive, equitable access to education and national development goals.

## 14. Challenges and Potential Solutions

| Challenge | Our approach |
|---|---|
| Legacy portals expose no ready APIs | One adapter per portal. Mock data for now, swapping to live APIs once agencies grant access. |
| Three systems, three data formats | The Aggregation Service normalizes every record into one common schema. |
| Documents that don't match across records | Routed to manual review with a deficiency note, never auto-rejected. |
| Sensitive data: Aadhaar, income, caste | JWT-secured access, with checks made against official sources within data-sharing policies. |
| Low digital literacy, many languages | Simple mobile-first screens. JAGO guides in English and Hindi, with more languages to follow. |
| New schemes and changing rules | A new scheme is a new adapter and rule set. The rest of the platform stays as is. |

## 15. Impact and Benefits

**Impact:** reduced processing friction, greater transparency, improved outreach to enrolled students not receiving scholarships, less repetitive paperwork, clearer pending actions, and digital document reuse.

| Stakeholder | Benefit |
|---|---|
| **ST students** | Unified tracking, deficiency alerts and payment visibility |
| **Families** | Easier progress monitoring across schemes |
| **Institutions** | A transparent view of verification requirements |
| **Ministry** | Consolidated monitoring and coverage-gap identification |

**Sustainable Development Goals**

- **SDG 4, Quality Education:** unified application tracking and deficiency alerts for ST students.
- **SDG 10, Reduced Inequalities:** identifies enrolled ST students not receiving scholarship benefits.
- **SDG 16, Strong Institutions:** transparent progress, payment visibility and Ministry monitoring.

## 16. Future Scope

- Replace mock adapters with live NSP, SFMP and NOS integrations after data-sharing approval
- Live DigiLocker, UIDAI and e-District verification
- More regional and tribal languages for JAGO
- Push notifications through Firebase Cloud Messaging
- Extension to more schemes, states and student categories

## 17. Documentation and Design Assets

- [User personas](docs/personas.md)
- [Wireframes](docs/wireframes.md)
- [Pitch deck outline](docs/pitch-deck-outline.md)
- [API contract](backend/API_CONTRACT.md)

## 18. References

**Official portals**

1. Ministry of Tribal Affairs: [tribal.nic.in/ScholarshiP.aspx](https://tribal.nic.in/ScholarshiP.aspx)
2. National Scholarship Portal (NSP): [scholarships.gov.in](https://scholarships.gov.in)
3. SFMP, Canara Bank: fellowship management portal
4. NOS, National Overseas Scholarship: [overseas.tribal.gov.in](https://overseas.tribal.gov.in)

**Documents and data sources**

5. DigiLocker: [digilocker.gov.in](https://digilocker.gov.in)
6. UIDAI, e-District, AISHE, APAAR, UDISE+, UGC-NTA

**Technology**

7. Flutter and Dart: mobile frontend
8. Node.js and Express: backend
9. MongoDB, REST API and JWT: data layer and API
10. Firebase Cloud Messaging and an LLM API: notifications and JAGO

## 19. License

This project is licensed under the terms in the [LICENSE](LICENSE) file.

---

<div align="center">

**ShikshaSetu (शिक्षा सेतु)** · Team **BhashaMitra** · Team ID 143591 · SIH 2026 · PS **SIH26238**

</div>
