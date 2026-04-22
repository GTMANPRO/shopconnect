#!/usr/bin/env node

/**
 * One-time Firestore import for ShopConnect production dataset.
 *
 * Usage:
 *   GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json \
 *   node scripts/import_production_dataset.js
 *
 * Or after `gcloud auth application-default login`, if ADC is configured:
 *   node scripts/import_production_dataset.js
 */

const fs = require('fs');
const path = require('path');
const admin = require('firebase-admin');

const root = path.resolve(__dirname, '..');
const categoriesPath = path.join(root, 'assets', 'data', 'categories.production.json');
const storesPath = path.join(root, 'assets', 'data', 'stores.production.json');

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
  });
}

const db = admin.firestore();

function loadJson(p) {
  return JSON.parse(fs.readFileSync(p, 'utf8'));
}

async function writeCategory(cat) {
  const ref = db.collection('categories').doc(cat.id);
  await ref.set({
    name: cat.name,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  }, { merge: true });
}

async function writeStore(store) {
  const ref = db.collection('stores').doc(store.id);
  await ref.set({
    name: store.name,
    categories: store.categories,
    tags: store.tags,
    logoUrl: store.logoUrl || '',
    affiliateUrl: store.affiliateUrl || '',
    outboundUrl: store.outboundUrl || '',
    active: !!store.active,
    featured: !!store.featured,
    sortOrder: Number(store.sortOrder || 9999),
    popularityScore: Number(store.popularityScore || 0),
    network: store.network || 'direct',
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  }, { merge: true });
}

async function main() {
  const categories = loadJson(categoriesPath).categories || [];
  const stores = loadJson(storesPath).stores || [];

  console.log(`Importing ${categories.length} categories...`);
  for (const cat of categories) {
    await writeCategory(cat);
  }

  console.log(`Importing ${stores.length} stores...`);
  for (const store of stores) {
    await writeStore(store);
  }

  console.log('Done.');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
