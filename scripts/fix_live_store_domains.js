#!/usr/bin/env node

/**
 * Safe Firestore live store domain fixer for ShopConnect.
 *
 * Requirements:
 * - Run from project root or anywhere with GOOGLE_APPLICATION_CREDENTIALS / ADC available
 * - firebase-admin installed in the project
 *
 * Behavior:
 * - Only updates docs in collection `stores`
 * - Only touches target docs listed in CANONICAL_BY_ID
 * - Only writes affiliateUrl/outboundUrl when current value is blank or matches a known broken domain
 * - Supports --dry-run and --ids=a,b,c filters
 */

import admin from 'firebase-admin';

const args = new Set(process.argv.slice(2));
const dryRun = args.has('--dry-run');
const idsArg = [...args].find(a => a.startsWith('--ids='));
const idsFilter = idsArg ? new Set(idsArg.split('=')[1].split(',').map(s => s.trim().toLowerCase()).filter(Boolean)) : null;

const CANONICAL_BY_ID = {
  away: 'https://www.awaytravel.com',
  aldo: 'https://www.aldoshoes.com',
  harrydavid: 'https://www.harryanddavid.com',
  jossmain: 'https://www.jossandmain.com',
  bookshop: 'https://bookshop.org',
  barnesandnoble: 'https://www.barnesandnoble.com',
  abercrombie: 'https://www.abercrombie.com',
  factor: 'https://www.factor75.com',
  carparts: 'https://www.carparts.com',
  tiffany: 'https://www.tiffany.com',
  williamssonoma: 'https://www.williams-sonoma.com',
  saintlaurent: 'https://www.ysl.com',
  catbird: 'https://www.catbirdnyc.com',
  esteelauder: 'https://www.esteelauder.com',
  lancome: 'https://www.lancome-usa.com'
};

const BROKEN_HOST_MAP = {
  'away.com': 'https://www.awaytravel.com',
  'www.away.com': 'https://www.awaytravel.com',
  'aldo.com': 'https://www.aldoshoes.com',
  'www.aldo.com': 'https://www.aldoshoes.com',
  'harrydavid.com': 'https://www.harryanddavid.com',
  'www.harrydavid.com': 'https://www.harryanddavid.com',
  'www.harrydavid.com/': 'https://www.harryanddavid.com',
  'jossmain.com': 'https://www.jossandmain.com',
  'www.jossmain.com': 'https://www.jossandmain.com',
  'bookshoporg.com': 'https://bookshop.org',
  'www.bookshoporg.com': 'https://bookshop.org',
  'barnesnoble.com': 'https://www.barnesandnoble.com',
  'www.barnesnoble.com': 'https://www.barnesandnoble.com',
  'abercrombiefitch.com': 'https://www.abercrombie.com',
  'www.abercrombiefitch.com': 'https://www.abercrombie.com',
  'factor.com': 'https://www.factor75.com',
  'www.factor.com': 'https://www.factor75.com',
  'carpartscom.com': 'https://www.carparts.com',
  'www.carpartscom.com': 'https://www.carparts.com',
  'tiffanyco.com': 'https://www.tiffany.com',
  'www.tiffanyco.com': 'https://www.tiffany.com',
  'williamssonoma.com': 'https://www.williams-sonoma.com',
  'www.williamssonoma.com': 'https://www.williams-sonoma.com',
  'saintlaurent.com': 'https://www.ysl.com',
  'www.saintlaurent.com': 'https://www.ysl.com',
  'catbird.com': 'https://www.catbirdnyc.com',
  'www.catbird.com': 'https://www.catbirdnyc.com',
  'esteelauder.com': 'https://www.esteelauder.com',
  'www.esteelauder.com': 'https://www.esteelauder.com',
  'lancome.com': 'https://www.lancome-usa.com',
  'www.lancome.com': 'https://www.lancome-usa.com'
};

function normalizeId(v) {
  return String(v || '').trim().toLowerCase();
}

function normalizeUrl(v) {
  let s = String(v || '').trim();
  if (!s) return '';
  s = s.replace(/^['"]+|['"]+$/g, '');
  s = s.replace(/\s+/g, '');
  if (s.startsWith('http://')) s = 'https://' + s.slice(7);
  if (!/^https?:\/\//i.test(s)) s = 'https://' + s;
  return s.replace(/\/$/, '');
}

function hostOf(v) {
  const u = normalizeUrl(v);
  if (!u) return '';
  try {
    return new URL(u).hostname.toLowerCase();
  } catch {
    return '';
  }
}

function brokenReplacementFor(v) {
  const host = hostOf(v);
  if (!host) return '';
  return BROKEN_HOST_MAP[host] || '';
}

function shouldReplaceValue(currentValue, canonicalUrl) {
  const current = String(currentValue || '').trim();
  if (!current) return true;
  const normalized = normalizeUrl(current);
  if (!normalized) return true;
  if (normalized === canonicalUrl) return false;
  const replacement = brokenReplacementFor(normalized);
  return replacement === canonicalUrl;
}

function buildPatch(data, canonicalUrl) {
  const patch = {};
  if (shouldReplaceValue(data.affiliateUrl, canonicalUrl)) {
    patch.affiliateUrl = canonicalUrl;
  }
  if (shouldReplaceValue(data.outboundUrl, canonicalUrl)) {
    patch.outboundUrl = canonicalUrl;
  }
  return patch;
}

async function main() {
  if (!admin.apps.length) {
    admin.initializeApp();
  }
  const db = admin.firestore();
  let changed = 0;
  let checked = 0;

  for (const [id, canonicalUrl] of Object.entries(CANONICAL_BY_ID)) {
    if (idsFilter && !idsFilter.has(id)) continue;

    checked += 1;
    const ref = db.collection('stores').doc(id);
    const snap = await ref.get();

    if (!snap.exists) {
      console.log(`MISS  stores/${id} (doc not found)`);
      continue;
    }

    const data = snap.data() || {};
    const patch = buildPatch(data, canonicalUrl);
    const keys = Object.keys(patch);

    if (!keys.length) {
      console.log(`OK    stores/${id} no change needed`);
      continue;
    }

    console.log(`PATCH stores/${id}`);
    for (const key of keys) {
      console.log(`  ${key}: ${JSON.stringify(data[key] ?? '')} -> ${JSON.stringify(patch[key])}`);
    }

    if (!dryRun) {
      await ref.set(patch, { merge: true });
    }
    changed += 1;
  }

  console.log('');
  console.log(`Checked: ${checked}`);
  console.log(`Changed: ${changed}`);
  console.log(`Mode: ${dryRun ? 'DRY RUN' : 'LIVE WRITE'}`);
}

main().catch((err) => {
  console.error('FAILED:', err && err.stack ? err.stack : err);
  process.exit(1);
});
