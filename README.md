# CIVIX AI

CIVIX AI is an Android-first Flutter MVP for smart city crisis intelligence and emergency response in Pakistan. The app presents a Karachi command center where citizen reports, crisis records, emergency alerts, agent reasoning, simulations, analytics, and admin actions update through Firebase Cloud Firestore in real time.

The project is built as a demoable civic-tech prototype. It does not call a paid AI model yet. Instead, it uses deterministic, AI-style logic in the Flutter app to classify crisis reports, create multi-agent reasoning records, generate public alerts, and write simulation outcomes to Firestore so the whole interface behaves like a live emergency operations system.

## What This Project Does

CIVIX AI helps demonstrate how a city authority could receive crisis reports, detect the type and severity of the event, coordinate response agents, alert citizens, and visualize the city state.

Main capabilities:

- Shows a realtime Karachi command center dashboard.
- Streams crisis reports from Firestore.
- Displays high-priority crisis metrics such as active crises, high-priority incidents, people at risk, and blocked roads.
- Provides a live crisis map visualization driven by Firestore crisis records.
- Lets a demo user submit a crisis report.
- Auto-detects basic crisis types such as flood, fire, and general urban crisis from report text.
- Writes submitted reports to Firestore.
- Generates multi-agent reasoning records for each submitted report.
- Generates English, Urdu, and Roman Urdu alert records.
- Generates an emergency simulation result comparing before-AI and after-AI response metrics.
- Displays the latest crisis agent workflow.
- Shows detailed reasoning steps for each agent.
- Shows emergency simulation impact metrics.
- Provides an analytics dashboard with aggregate crisis KPIs.
- Provides a basic admin panel where authority actions can be triggered.
- Includes seed data and a Node.js seeding script for a realistic Karachi demo dataset.

## Product Concept

The app is designed as an agentic smart city operating system:

1. A citizen, responder, traffic feed, or city sensor reports a problem.
2. CIVIX AI records the crisis in Firestore.
3. A signal agent gathers local context.
4. A detection agent classifies the crisis.
5. A severity agent estimates risk.
6. A planning agent proposes response actions.
7. A dispatch agent simulates resource movement and ETA improvements.
8. An alert agent prepares multilingual citizen alerts.
9. Dashboards, map, alerts, simulation, and analytics update live.

In the current MVP, steps 3 through 8 are simulated locally in Dart. The Firestore data shape is already prepared for replacing that logic with a backend AI orchestration layer later.

## Tech Stack

- Flutter
- Dart SDK 3.4+
- Firebase Core
- Cloud Firestore
- Firebase Auth dependency included, but login is currently demo-only
- go_router for navigation
- provider for dependency injection
- google_fonts for typography
- flutter_animate for splash animation
- fl_chart for analytics charts
- uuid for report IDs
- Node.js Firebase Admin SDK for Firestore seeding

## App Structure

```text
lib/
  main.dart                         App entry point and Firebase init
  router/app_router.dart            go_router route table
  core/theme/app_theme.dart         Dark CIVIX visual theme
  core/widgets/civix_widgets.dart   Shared UI widgets
  data/models/models.dart           Firestore model classes
  data/services/firestore_service.dart
                                    Firestore streams and MVP report logic
  features/
    splash/                         Animated splash screen
    onboarding/                     Product onboarding
    auth/                           Demo login screen
    home/                           Main shell and command dashboard
    map/                            Live crisis map visualization
    report/                         Crisis report submission
    agents/                         Latest crisis agent workflow
    reasoning/                      Per-crisis agent reasoning details
    simulation/                     Emergency response simulation
    analytics/                      Aggregate crisis analytics
    alerts/                         Realtime alert center
    admin/                          Authority action panel

assets/seed/                        Demo Firestore seed data
scripts/seed_firestore.js           Firebase Admin seeding script
firestore.rules                     Starter Firestore rules
pubspec.yaml                        Flutter dependencies and assets
```

## Navigation Flow

Routes are defined in `lib/router/app_router.dart`.

```text
/                    Splash screen
/onboarding          Onboarding screens
/login               Demo login
/app                 Main bottom-tab app shell
/reasoning/:id       Agent reasoning for a crisis
/simulation/:id      Simulation result for a crisis
/analytics           Analytics dashboard
/admin               Admin control panel
```

The main app shell has these bottom tabs:

- Home
- Map
- Report
- Agents
- Alerts

## Firestore Collections

The app expects these Firestore collections:

```text
crisis_reports
crisis_reports/{crisisId}/agent_results
alerts
emergency_units
simulation_results
```

### `crisis_reports/{id}`

Stores each crisis or emergency event.

Important fields:

- `title`
- `description`
- `type`
- `locationName`
- `latitude`
- `longitude`
- `severity`
- `confidence`
- `status`
- `reportedAt`
- `reportedBy`
- `affectedRadiusKm`
- `peopleAtRisk`
- `blockedRoads`

### `crisis_reports/{id}/agent_results/{agentResultId}`

Stores AI-style reasoning steps for a specific crisis.

Important fields:

- `agentName`
- `status`
- `confidence`
- `summary`
- `reasoningPoints`
- `timestamp`

### `alerts/{id}`

Stores citizen-facing alert messages.

Important fields:

- `crisisId`
- `language`
- `title`
- `message`
- `severity`
- `location`
- `status`
- `createdAt`

### `emergency_units/{id}`

Stores emergency resources.

Important fields:

- `type`
- `name`
- `location`
- `status`
- `etaMinutes`

### `simulation_results/{crisisId}`

Stores before-and-after response simulation metrics.

Important fields:

- `beforeCongestion`
- `afterCongestion`
- `beforeEta`
- `afterEta`
- `peopleAtRisk`
- `peopleAlerted`
- `congestionReduction`
- `etaImprovement`
- `rescueCoverageImprovement`

## Seed Data

The repo includes Pakistan/Karachi-focused demo data in `assets/seed/`.

Seed files:

- `crisis_reports.json`
- `emergency_units.json`
- `alerts.json`
- `simulation_results.json`
- `agent_results.json`

The default dataset includes incidents such as:

- Gulshan-e-Iqbal urban flood
- Saddar fire incident
- Shahrah-e-Faisal road accident
- Clifton medical emergency
- NIPA road blockage
- North Nazimabad power infrastructure failure

## Setup

This project does not include private Firebase files. You need to connect your own Firebase project before running the app.

Required generated files:

```text
android/app/google-services.json
lib/firebase_options.dart
```

Install dependencies:

```bash
flutter pub get
```

Configure Firebase:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

If `flutterfire configure` creates `lib/firebase_options.dart`, update `lib/main.dart` to initialize Firebase with generated options:

```dart
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

The current code uses:

```dart
await Firebase.initializeApp();
```

That can work for Android after `android/app/google-services.json` exists, but generated options are cleaner for multi-platform builds.

## Android Project Note

The repository currently has an `android/app` directory, but it does not appear to contain a full generated Android platform project. If platform files are missing, regenerate them from the project root:

```bash
flutter create .
```

This keeps the existing `lib/`, `assets/`, `scripts/`, and `pubspec.yaml` content while restoring Flutter platform scaffolding.

## Seeding Firestore

Create a Firebase service account key in Firebase Console:

```text
Project Settings > Service accounts > Generate new private key
```

Save it as:

```text
scripts/serviceAccountKey.json
```

Do not commit that file.

Install seeder dependencies:

```bash
cd scripts
npm install
```

Run the seed script:

```bash
npm run seed
```

Expected output:

```text
CIVIX AI Firestore seed completed successfully.
```

The script writes seed data to:

- `crisis_reports`
- `emergency_units`
- `alerts`
- `simulation_results`
- `crisis_reports/{crisisId}/agent_results`

## Running The App

From the project root:

```bash
flutter run
```

For a release APK:

```bash
flutter build apk --release
```

## Demo Walkthrough

1. Configure Firebase.
2. Seed Firestore.
3. Run the Flutter app.
4. Wait for the splash screen to move to onboarding.
5. Continue through onboarding.
6. Select `Continue as Demo User`.
7. Review the Karachi command dashboard.
8. Open the Map tab to see crisis markers.
9. Open the Report tab.
10. Submit the default flood report:

```text
Gulshan mein flooding ho rahi hai aur roads block hain.
```

11. The app writes a new crisis to Firestore.
12. The app creates agent reasoning, alert, and simulation records.
13. The reasoning screen opens for the new crisis.
14. Open the simulation screen to see response improvements.
15. Open Alerts to see generated public alerts.

## Current MVP AI Logic

The main MVP logic lives in:

```text
lib/data/services/firestore_service.dart
```

`submitReport()` does the following:

- Creates a UUID for the report.
- Checks report text for keywords.
- Detects flood from words such as `flood`, `pani`, `barish`, and `block`.
- Detects fire from words such as `fire`, `aag`, and `smoke`.
- Falls back to `Urban Crisis` for unknown reports.
- Assigns severity and confidence.
- Writes a `crisis_reports` document.
- Writes agent result documents under the crisis.
- Writes a `simulation_results` document.
- Writes multilingual alert documents.

This gives the prototype a reliable demo flow without needing a backend server or paid AI API calls.

## Current Limitations

- Authentication is demo-only. The login screen does not sign in with Firebase Auth yet.
- Report image and voice buttons are placeholders.
- The live map is a custom city-grid visualization, not Google Maps.
- Admin actions mostly show confirmation snackbars. Only `Resolve Latest Crisis` updates Firestore.
- Firestore rules currently require `request.auth != null`, but the demo login does not authenticate. For local demos you must either add real auth or use suitable temporary demo rules.
- The app writes generated alerts for flood-oriented copy even when some non-flood crisis types are submitted.
- Some existing seed strings contain mojibake where Urdu text was incorrectly encoded before this README cleanup.
- No automated tests are included yet.
- No backend orchestration service is included yet.

## Suggested Production Architecture

The current Firestore data shape can support a real AI/backend pipeline later:

```text
Flutter App
  -> API Backend
  -> AI Orchestration Layer
  -> Signal Agent
  -> Detection Agent
  -> Severity Agent
  -> Planning Agent
  -> Dispatch Agent
  -> Alert Agent
  -> Analytics Agent
  -> Firestore
  -> Flutter realtime streams
```

Possible next production upgrades:

- Add real Firebase Authentication and role-based access.
- Move `submitReport()` AI generation into a secure backend.
- Replace deterministic keyword detection with Gemini or another model.
- Add Google Maps or another GIS provider.
- Store real emergency unit dispatch state.
- Add push notifications for alerts.
- Add Firestore indexes and stricter security rules.
- Add tests for model parsing, service writes, and UI flows.
- Fix encoded Urdu seed text.

## Key Files For Future Work

- `lib/data/services/firestore_service.dart`: Most important file for data flow and MVP AI behavior.
- `lib/data/models/models.dart`: Firestore document parsing models.
- `lib/features/report/report_screen.dart`: Crisis submission flow.
- `lib/features/reasoning/reasoning_screen.dart`: Per-crisis agent trace.
- `lib/features/simulation/simulation_screen.dart`: Simulation metrics UI.
- `lib/features/admin/admin_screen.dart`: Authority command actions.
- `scripts/seed_firestore.js`: Firestore seed loader.
- `assets/seed/`: Demo data source.
- `firestore.rules`: Starter Firestore rules.

## Quick Project Memory

Remember this project as a Flutter/Firebase realtime emergency-response MVP named CIVIX AI. It is focused on Pakistan/Karachi smart city crisis intelligence. Firestore is the source of truth. The app streams crisis reports, alerts, agent results, emergency units, and simulations. The current "AI" is deterministic Dart logic in `FirestoreService.submitReport()`, not an external model. The main future work is to add real Firebase Auth, move AI orchestration to a backend, replace the custom map with real maps, clean encoded Urdu seed text, and harden Firestore rules.
