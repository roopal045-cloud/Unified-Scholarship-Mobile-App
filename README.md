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

> **About this repository.** This README describes the **final ShikshaSetu app** as proposed in our SIH presentation. The repository contains a **working prototype** of it. Where the prototype differs (for example mock data adapters and a simulated Aadhaar-OTP step), the "In this prototype" column says so.

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

Features of the final app, with the state of each one in the prototype in this repository.

| Feature | Description | In this prototype |
|---|---|---|
| **Unified student dashboard** | Applications, progress, deficiencies, sanctions and DBT for all schemes in one view, built by the Aggregation Service from the NSP, SFMP and NOS adapters. | Working (mock data) |
| **Single login** | Student ID login screen with an OTP step. The backend issues a JWT valid for 12 hours. The OTP itself is a simulated UI step, not a real Aadhaar OTP. | Simulated |
| **Eligibility check** | Enforces the one-scheme-at-a-time rule and names the existing application that blocks a new one. | Working |
| **Application tracking** | Detail screen with a progress stepper for each application. | Working |
| **Document wallet** | Shows each document with its verification state and deficiency, derived from the student's applications. Direct file upload is not built yet. | Partial |
| **Automated verification** | The Verification Service routes each document type to the right source adapter. A match is auto-cleared. | Working (mock adapters) |
| **Manual review with deficiency notes** | A mismatch goes to a manual review queue with a note and never blocks the application. | Working |
| **JAGO chatbot** | Answers status, eligibility, documents and deficiency questions from the student's live application data, with an English/Hindi toggle. Intent matching is rule-based. | Working (rule-based) |
| **DBT and payment status** | The Disbursement Service consolidates sanction and DBT status. | Working (mock data) |
| **Notifications** | Milestone alerts through a notification bell in the app, backed by trigger and list endpoints. | In-app only |
| **Ministry official login** | A separate login screen for Ministry officials. | Working (demo credentials) |
| **Coverage-gap outreach dashboard** | Cross-references enrollment records (UDISE+, APAAR, OTR) with NSP, SFMP and NOS records to list enrolled ST students with no scholarship application. | Working (mock data) |
| **Mobile-first UI** | Light, simple, government-style interface with a tricolor strip and header. | Working |
| **Push, SMS and email alerts** | Firebase Cloud Messaging and SMS/email delivery. | Planned |
| **Live government integrations** | Real NSP, SFMP, NOS, DigiLocker, UIDAI, e-District, AISHE, UDISE+, APAAR and UGC-NTA connections. | Planned |

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

### Final app stack

| Layer | Technology | Why we chose it | In this prototype |
|---|---|---|---|
| **Frontend** | **Flutter · Dart** | One codebase gives a fast, smooth Android app, and the same code can later run on iOS and web. This suits a student base on a wide range of budget devices. Flutter's widget system let us build a consistent government-style theme quickly (header, tricolor strip, login screen, progress stepper), and its light footprint fits our low-internet, rural-user focus. | Built with Flutter, using the `http` package for API calls |
| **Backend** | **Node.js · Express** | Non-blocking I/O suits our main job: calling several portal adapters and data sources at the same time and merging the results without one slow source blocking the rest. Express keeps the REST API simple, with one route file per feature. | Built with Express 5 |
| **Database** | **MongoDB · Mongoose** | Applications, documents and verification results have different shapes for each scheme. A flexible document model lets a new scheme's fields be added without a migration, and Mongoose adds schema validation where we need it. | In-memory mock data, so the demo runs anywhere with no setup. `schema.sql` documents the data design. |
| **Authentication** | **JWT (JSON Web Token)** | Stateless tokens suit a mobile app and let us separate student and Ministry official roles cleanly. | JWT with 12-hour expiry, using `jsonwebtoken` |
| **Integrations** | **NSP · SFMP · NOS** and Govt. data APIs | The scholarship portals hold the source of truth for applications. We integrate through one adapter per portal instead of replacing them. | Mock adapters shaped like each portal's data |
| **Notifications** | **Firebase Cloud Messaging (FCM)** | Free, reliable push notifications on Android for deadlines, deficiencies and payment updates. | In-app notification bell with trigger and list endpoints |
| **AI chatbot** | **JAGO (LLM API)** | A language model lets JAGO understand free-form questions in English and Hindi, grounded in the student's live application data. | Rule-based intents with an English/Hindi toggle, using live application data |
| **Deployment** | **Vercel / AWS or GCP** | Flexible hosting that scales with usage and can run on existing government-approved cloud infrastructure. | Runs locally |
| **Version control** | **GitHub** | Source hosting and collaboration between team members. | Used |

### Supporting libraries in the prototype

| Library | Purpose |
|---|---|
| `cors` | Lets the Flutter web build and emulators call the API during development |
| `uuid` | Generates unique identifiers for records |
| `cupertino_icons`, custom `AppTheme` | Icons and one central theme for a consistent look |
| `flutter_lints`, `flutter_test` | Code quality rules and widget tests |

### Design choices behind the stack

- **Adapter pattern:** one adapter per portal converts three different data formats into one schema, so the rest of the platform never depends on portal-specific details. A new scheme is a new adapter and rule set.
- **Routes, services, adapters:** routes handle HTTP, services hold business logic (aggregation, eligibility, verification, disbursement, coverage-gap), and adapters talk to data sources. Each layer can change without touching the others.
- **Microservice-style integration layer:** each concern can be built, tested and scaled on its own in the final app.
- **Open-source only:** Flutter, Node.js and MongoDB carry no licence cost.

## 9. Integrations

| Type | System | Used for | In this prototype |
|---|---|---|---|
| Scholarship APIs | **NSP** | Pre-Matric and Post-Matric scholarships | Mock adapter |
| | **SFMP** (Canara Bank) | Top Class Education for ST, NFST | Mock adapter |
| | **NOS** | National Overseas Scholarship | Mock adapter |
| Enrollment data | **UDISE+ / APAAR / OTR** | Finding enrolled ST students for the coverage-gap dashboard | Mock adapter |
| Verification sources | **DigiLocker** | Document verification | Simulated through the scheme adapters |
| | **UIDAI (Aadhaar)** | Identity verification | Simulated OTP step |
| | **e-District** | Caste, income and domicile | Simulated |
| | **AISHE / UDISE+** | Educational details | Simulated |
| | **APAAR** | Student academic ID | Simulated |
| | **UGC / NTA** | University and exam data | Simulated |
| Services | **Firebase Cloud Messaging** | Push notifications | Planned |
| | **LLM API** | JAGO assistance | Planned |

> **Note:** live access to these systems depends on Ministry and agency data-sharing approval. Until then the adapters return mock data shaped like the real systems.

## 10. Project Structure

```
Unified-Scholarship-Mobile-App/
├── backend/
│   ├── server.js                  # Express entry point (port 3000), mounts all routes
│   ├── package.json
│   ├── API_CONTRACT.md            # Endpoint documentation
│   ├── schema.sql                 # Reference relational schema
│   └── src/
│       ├── routes/                # auth, applications, verification, disbursement,
│       │                          # notifications, eligibility, coverageGap
│       ├── services/              # aggregation, eligibility, verification,
│       │                          # disbursement, coverageGap
│       └── adapters/              # nsp, sfmp, nos, enrollment (mock data sources)
├── frontend/                      # Flutter app
│   ├── pubspec.yaml
│   ├── test/
│   ├── android/ ios/ web/ linux/ macos/ windows/
│   └── lib/
│       ├── main.dart
│       ├── screens/               # login, ministry login, dashboard, applications,
│       │                          # application detail, document wallet, eligibility
│       │                          # check, JAGO chatbot, coverage gap, profile
│       ├── widgets/               # gov header, tricolor strip, progress stepper,
│       │                          # notification bell, ledger and wallet rows
│       ├── models/                # scholarship application, document item
│       ├── services/api_service.dart
│       └── theme/app_theme.dart
├── docs/
│   ├── personas.md
│   ├── wireframes.md
│   └── pitch-deck-outline.md
├── LICENSE
└── README.md
```

## 11. Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ^3.13.2) and an Android emulator or a device
- [Node.js](https://nodejs.org/) and npm

These steps run the prototype in this repository. It needs no database or `.env` file because it runs on built-in mock data.

### 1. Clone the repository

```bash
git clone https://github.com/roopal045-cloud/Unified-Scholarship-Mobile-App.git
cd Unified-Scholarship-Mobile-App
```

### 2. Run the backend

```bash
cd backend
npm install
node server.js
```

The API starts on `http://localhost:3000`. Open that address in a browser to see the health check.

### 3. Run the Flutter app

```bash
cd frontend
flutter pub get
flutter run
```

The app picks the API address automatically: `10.0.2.2:3000` on an Android emulator (which reaches your computer's localhost) and `localhost:3000` on web and desktop. If you use a physical phone, change the address in `frontend/lib/services/api_service.dart` to your computer's local IP.

### Demo student IDs

| Student ID | Name | State |
|---|---|---|
| STU-1001 | Anita Oraon | Jharkhand |
| STU-1002 | Ravi Munda | Odisha |
| STU-1003 | Meena Bhil | Madhya Pradesh |
| STU-1004 | Sunita Kumari | Chhattisgarh |
| STU-1005 | Arjun Meena | Rajasthan |

Enter any of these IDs on the login screen and continue through the OTP step. The Ministry official login uses separate demo credentials that are set in the app code.

## 12. API Documentation

Base URL: `http://localhost:3000/api`. The complete request and response details are in [`backend/API_CONTRACT.md`](backend/API_CONTRACT.md).

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/auth/login` | Log in with a student ID and receive a JWT and profile |
| GET | `/applications/:studentId` | Unified dashboard merging NSP, SFMP and NOS |
| GET | `/eligibility/:studentId` | One-scheme-at-a-time eligibility check |
| POST | `/verification/check` | Verify one document, auto-clear it or send it to manual review |
| GET | `/verification/review-queue` | List documents waiting in manual review |
| GET | `/disbursement/:applicationId` | Sanction and DBT status |
| POST | `/notifications/trigger` | Create a milestone notification |
| GET | `/notifications/:studentId` | List notifications for a student |
| GET | `/coverage-gap` | Ministry view of enrolled ST students with no scholarship |

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
| Sensitive data: Aadhaar, income, caste | JWT-secured access, with checks made against official sources within data-sharing policies. Secrets will move to environment variables for production. |
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
- Live DigiLocker, UIDAI and e-District verification, including real Aadhaar-OTP login
- MongoDB persistence for users, applications, documents, verification and payments
- Push, SMS and email notifications through Firebase Cloud Messaging
- LLM-powered JAGO with more regional and tribal languages
- Direct document upload in the wallet
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
9. REST API and JWT: data layer and API
10. Firebase Cloud Messaging and an LLM API: notifications and JAGO

## 19. License

This project is licensed under the terms in the [LICENSE](LICENSE) file.

---

<div align="center">

**ShikshaSetu (शिक्षा सेतु)** · Team **BhashaMitra** · Team ID 143591 · SIH 2026 · PS **SIH26238**

</div>
