# CIVIX AI — Flutter + Firebase Realtime MVP

**CIVIX AI** is an Android-first Flutter MVP for an AI-powered smart city crisis intelligence and emergency response system built for Pakistan.

This version is **Firebase-backed** and intentionally does **not use in-app mock lists**. The dashboard, map, alerts, agents, analytics, and simulation screens read from **Firestore live streams**. Seed data is provided so developers can populate Firebase with realistic Pakistan-focused realtime demo data.

---

## What is included

- Flutter Android-first app
- Dark futuristic government-grade UI
- Firebase Core + Cloud Firestore integration
- Realtime Firestore streams for crisis data
- Crisis reporting screen that writes live Firestore records
- AI agent workflow panel
- AI reasoning screen
- Emergency simulation screen
- Realtime alert center
- Analytics dashboard
- Admin control panel
- Pakistan/Karachi-focused seed data
- Firestore seed script using Firebase Admin SDK
- Firestore security rules starter file

---

## Important note about Firebase

A ZIP file cannot include your private Firebase project credentials or Android `google-services.json` file. You must connect your own Firebase project before running.

The app is ready for Firebase, but you need to add:

```text
android/app/google-services.json
lib/firebase_options.dart
```

The easiest way is using FlutterFire CLI.

---

## Prerequisites

Install:

- Flutter latest stable
- Android Studio or Android SDK
- Node.js LTS
- Firebase CLI
- FlutterFire CLI

Check Flutter:

```bash
flutter doctor
```

Install Firebase CLI:

```bash
npm install -g firebase-tools
firebase login
```

Install FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

---

## Setup steps

### 1. Extract the ZIP

```bash
unzip civix_ai_realtime_flutter.zip
cd civix_ai_realtime
```

### 2. Generate Flutter platform folders if needed

If the extracted project does not contain full Android/iOS platform folders, run:

```bash
flutter create .
```

This keeps the existing `lib/`, `pubspec.yaml`, assets, and scripts.

### 3. Create Firebase project

Go to Firebase Console and create a project, for example:

```text
civix-ai-demo
```

Enable:

- Firestore Database
- Authentication, optional for demo

For demo testing, you may enable anonymous/email authentication or temporarily use test rules.

### 4. Configure FlutterFire

From the project root:

```bash
flutterfire configure
```

Choose your Firebase project and Android app.

This generates:

```text
lib/firebase_options.dart
android/app/google-services.json
```

### 5. Update `lib/main.dart` if FlutterFire generated options

If `flutterfire configure` generates `firebase_options.dart`, replace Firebase initialization in `lib/main.dart` with:

```dart
import 'firebase_options.dart';

await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

Current code uses:

```dart
await Firebase.initializeApp();
```

That works on Android after `google-services.json` is added, but FlutterFire options are cleaner.

### 6. Install Flutter dependencies

```bash
flutter pub get
```

---

## Seed Firestore with realtime demo data

The app reads live Firestore collections. Seed data is inside:

```text
assets/seed/
```

Collections seeded:

```text
crisis_reports
emergency_units
alerts
simulation_results
crisis_reports/{crisisId}/agent_results
```

### 1. Generate Firebase service account key

Firebase Console → Project Settings → Service accounts → Generate new private key.

Save it as:

```text
scripts/serviceAccountKey.json
```

Never commit this file publicly.

### 2. Install seeder dependencies

```bash
cd scripts
npm install
```

### 3. Run seed script

```bash
npm run seed
```

Expected output:

```text
CIVIX AI Firestore seed completed successfully.
```

---

## Run the app

From project root:

```bash
flutter run
```

For Android release build:

```bash
flutter build apk --release
```

---

## Firestore data model

### `crisis_reports/{id}`

```json
{
  "title": "Urban Flood Emergency",
  "description": "Gulshan mein flooding ho rahi hai aur roads block hain.",
  "type": "Urban Flood Emergency",
  "locationName": "Gulshan-e-Iqbal, Karachi",
  "latitude": 24.9202,
  "longitude": 67.0886,
  "severity": "HIGH",
  "confidence": 92,
  "status": "Response in Progress",
  "reportedAt": "Timestamp",
  "reportedBy": "Citizen App",
  "affectedRadiusKm": 3.2,
  "peopleAtRisk": 18500,
  "blockedRoads": 7
}
```

### `crisis_reports/{id}/agent_results/{agentResultId}`

```json
{
  "agentName": "Detection Agent",
  "status": "Completed",
  "confidence": 92,
  "summary": "Detected Urban Flood Emergency with 92% confidence.",
  "reasoningPoints": ["Heavy rainfall signal matched", "Road blockage keywords found"],
  "timestamp": "Timestamp"
}
```

### `alerts/{id}`

```json
{
  "crisisId": "karachi_gulshan_flood",
  "language": "English",
  "title": "Flood Emergency - Gulshan-e-Iqbal",
  "message": "Flood emergency reported in Gulshan-e-Iqbal...",
  "severity": "HIGH",
  "location": "Gulshan-e-Iqbal, Karachi",
  "status": "Sent",
  "createdAt": "Timestamp"
}
```

### `simulation_results/{crisisId}`

```json
{
  "beforeCongestion": 87,
  "afterCongestion": 51,
  "beforeEta": 22,
  "afterEta": 9,
  "peopleAtRisk": 18500,
  "peopleAlerted": 12400,
  "congestionReduction": 41,
  "etaImprovement": 28,
  "rescueCoverageImprovement": 35
}
```

### `emergency_units/{id}`

```json
{
  "type": "Ambulance",
  "name": "Edhi Ambulance 01",
  "location": "Gulshan Response Point",
  "status": "Available",
  "etaMinutes": 9
}
```

---

## Main demo flow

1. Seed Firestore.
2. Run app.
3. Continue as Demo User.
4. Home dashboard shows Karachi high-alert data from Firestore.
5. Open Map to see live crisis markers from Firestore.
6. Go to Report screen.
7. Submit:

```text
Gulshan mein flooding ho rahi hai aur roads block hain.
```

8. The app writes a new Firestore crisis report.
9. Agent results, multilingual alerts, and simulation results are generated as Firestore records.
10. AI Reasoning and Simulation screens display the generated realtime records.

---

## Current MVP AI behavior

The MVP uses local deterministic AI-style processing in `FirestoreService.submitReport()` to generate Firestore records.

It detects crisis type using keywords such as:

- `flood`, `pani`, `barish`, `block`
- `fire`, `aag`, `smoke`
- `accident`, `ambulance`, `injured`

Then it writes:

- Crisis report
- Agent reasoning records
- Simulation result
- English alert
- Urdu alert
- Roman Urdu alert

This keeps the MVP demo reliable and realtime without requiring paid AI API calls.

---

## How to connect Gemini / Google Antigravity later

Replace the deterministic logic inside:

```text
lib/data/services/firestore_service.dart
```

Specifically:

```dart
submitReport()
_agentSeed()
_alerts()
```

Recommended production flow:

```text
Flutter App
   ↓
FastAPI Backend
   ↓
Google Antigravity Orchestration Layer
   ↓
Signal Agent
Detection Agent
Severity Agent
Planning Agent
Dispatch Agent
Alert Agent
Analytics Agent
   ↓
Gemini API
   ↓
Firestore
   ↓
Flutter realtime streams
```

---

## Firestore security rules

A starter rules file is included:

```text
firestore.rules
```

For quick authenticated testing:

```text
allow read, write: if request.auth != null;
```

For hackathon-only testing, Firebase Console test mode can be used temporarily, but do not ship production apps with public write access.

---

## Files to customize

### Theme

```text
lib/core/theme/app_theme.dart
```

### Common UI widgets

```text
lib/core/widgets/civix_widgets.dart
```

### Firestore streams and write logic

```text
lib/data/services/firestore_service.dart
```

### Seed data

```text
assets/seed/
```

### Screens

```text
lib/features/
```

---

## Notes for developer

- This project uses Firestore realtime streams; the app UI updates when Firestore changes.
- No private Firebase keys are included.
- No Google Maps API key is included. The current map screen is a premium realtime city-grid visualization driven by Firestore crisis data.
- To add real Google Maps later, replace `LiveMapScreen` with `google_maps_flutter` and use `latitude`, `longitude`, and `affectedRadiusKm` from Firestore.
- The seed script uses Firebase Admin SDK and must only run locally or from a secure backend environment.

---

## Hackathon pitch

CIVIX AI is not just an alert app. It is an agentic smart city operating system that detects crises, reasons through severity, plans emergency actions, simulates response execution, and updates the city state in real time.

Built for Pakistan’s urban challenges, CIVIX AI helps cities respond faster to floods, fires, accidents, medical emergencies, infrastructure failures, and public safety threats.
