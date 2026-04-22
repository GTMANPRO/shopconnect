
const fs = require('fs');
const path = require('path');
const admin = require('firebase-admin');

const projectRoot = process.argv[2] || process.cwd();
const overridesPath = process.argv[3] || path.join(projectRoot, 'scripts', 'offer_url_overrides.json');

if (!fs.existsSync(overridesPath)) {
  console.error(`Overrides file not found: ${overridesPath}`);
  console.error('Copy scripts/offer_url_overrides.template.json to scripts/offer_url_overrides.json and fill in real URLs first.');
  process.exit(1);
}

const raw = fs.readFileSync(overridesPath, 'utf8');
let overrides;
try {
  overrides = JSON.parse(raw);
} catch (err) {
  console.error(`Invalid JSON in overrides file: ${err.message}`);
  process.exit(1);
}

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
  });
}

const db = admin.firestore();

function isValidHttpUrl(value) {
  if (typeof value !== 'string' || !value.trim()) return false;
  try {
    const u = new URL(value.trim());
    return u.protocol === 'http:' || u.protocol === 'https:';
  } catch (_) {
    return false;
  }
}

async function main() {
  const entries = Object.entries(overrides);
  if (entries.length === 0) {
    console.log('No overrides found.');
    return;
  }

  console.log(`Applying ${entries.length} offer URL overrides from ${overridesPath}`);

  let updated = 0;
  let skipped = 0;

  for (const [docId, url] of entries) {
    if (!isValidHttpUrl(url)) {
      console.log(`Skipped ${docId}: missing or invalid URL`);
      skipped += 1;
      continue;
    }

    const ref = db.collection('offers').doc(docId);
    const snap = await ref.get();
    if (!snap.exists) {
      console.log(`Skipped ${docId}: offer document not found`);
      skipped += 1;
      continue;
    }

    await ref.set(
      {
        affiliateUrl: url.trim(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );
    console.log(`Updated ${docId} -> ${url}`);
    updated += 1;
  }

  console.log(`Done. Updated ${updated}, skipped ${skipped}.`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
