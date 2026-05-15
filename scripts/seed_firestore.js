const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

const serviceAccountPath = process.env.GOOGLE_APPLICATION_CREDENTIALS || path.join(__dirname, 'serviceAccountKey.json');
if (!fs.existsSync(serviceAccountPath)) {
  console.error('Missing Firebase service account key. Place serviceAccountKey.json inside scripts/ or set GOOGLE_APPLICATION_CREDENTIALS.');
  process.exit(1);
}
admin.initializeApp({ credential: admin.credential.cert(require(serviceAccountPath)) });
const db = admin.firestore();
const seedDir = path.join(__dirname, '..', 'assets', 'seed');
const read = (file) => JSON.parse(fs.readFileSync(path.join(seedDir, file), 'utf8'));
const now = admin.firestore.Timestamp.now();

async function main() {
  const batch = db.batch();
  for (const c of read('crisis_reports.json')) {
    const { id, ...data } = c;
    batch.set(db.collection('crisis_reports').doc(id), { ...data, reportedAt: now });
  }
  for (const u of read('emergency_units.json')) {
    const { id, ...data } = u;
    batch.set(db.collection('emergency_units').doc(id), data);
  }
  for (const a of read('alerts.json')) {
    batch.set(db.collection('alerts').doc(), { ...a, crisisId: 'karachi_gulshan_flood', createdAt: now });
  }
  for (const sim of read('simulation_results.json')) {
    const { id, ...data } = sim;
    batch.set(db.collection('simulation_results').doc(id), data);
  }
  await batch.commit();
  for (const a of read('agent_results.json')) {
    const { crisisId, ...data } = a;
    await db.collection('crisis_reports').doc(crisisId).collection('agent_results').add({ ...data, timestamp: now });
  }
  console.log('CIVIX AI Firestore seed completed successfully.');
}
main().catch((e) => { console.error(e); process.exit(1); });
