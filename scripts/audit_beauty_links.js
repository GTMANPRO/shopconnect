#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const projectRoot = process.cwd();

const candidates = [
  path.join(projectRoot, 'assets/data/stores.json'),
  path.join(projectRoot, 'assets/data/affiliate_links.json'),
  path.join(projectRoot, 'lib/data/seed_data.dart'),
];

function exists(p) {
  try {
    return fs.existsSync(p);
  } catch (_) {
    return false;
  }
}

function isUsableLink(v) {
  return typeof v === 'string' && /^https?:\/\//i.test(v.trim());
}

function normalizeId(v) {
  return String(v || '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '');
}

function safeReadJson(file) {
  try {
    const raw = fs.readFileSync(file, 'utf8');
    const parsed = JSON.parse(raw);
    if (Array.isArray(parsed)) return parsed;
    if (Array.isArray(parsed.stores)) return parsed.stores;
    return [];
  } catch (err) {
    console.warn(`Skipping invalid JSON: ${file}`);
    console.warn(`  -> ${err.message}`);
    return null;
  }
}

function extractStoresFromSeedDataDart(file) {
  const raw = fs.readFileSync(file, 'utf8');
  const chunks = [...raw.matchAll(/StoreModel\(([\s\S]*?)\)/g)];
  const stores = [];

  for (const match of chunks) {
    const block = match[1];
    const id = /id:\s*'([^']+)'/.exec(block)?.[1] || '';
    const name = /name:\s*'([^']+)'/.exec(block)?.[1] || '';
    const category = /category:\s*'([^']+)'/.exec(block)?.[1] || '';
    const outboundUrl = /outboundUrl:\s*'([^']+)'/.exec(block)?.[1] || '';
    const affiliateUrl = /affiliateUrl:\s*'([^']+)'/.exec(block)?.[1] || '';

    if (id || name) {
      stores.push({ id, name, category, outboundUrl, affiliateUrl });
    }
  }

  return stores;
}

function loadStores() {
  for (const file of candidates) {
    if (!exists(file)) continue;

    if (file.endsWith('.json')) {
      const stores = safeReadJson(file);
      if (stores && stores.length) {
        return { source: file, stores };
      }
    }

    if (file.endsWith('.dart')) {
      const stores = extractStoresFromSeedDataDart(file);
      if (stores.length) {
        return { source: file, stores };
      }
    }
  }

  return null;
}

const result = loadStores();

if (!result) {
  console.error('No supported valid store source found. Checked:');
  for (const c of candidates) console.error(` - ${c}`);
  process.exit(1);
}

const { source, stores } = result;

const beauty = stores.filter(
  (s) => String(s.category || '').trim().toLowerCase() === 'beauty'
);

const seen = new Map();
const duplicates = [];
const missing = [];

for (const store of beauty) {
  const key = normalizeId(store.id || store.name);

  if (seen.has(key)) {
    duplicates.push({ first: seen.get(key), duplicate: store });
  } else {
    seen.set(key, store);
  }

  const affiliateOk = isUsableLink(store.affiliateUrl);
  const outboundOk = isUsableLink(store.outboundUrl);

  if (!affiliateOk && !outboundOk) {
    missing.push(store);
  }
}

console.log(`Beauty source: ${source}`);
console.log(`Beauty stores found: ${beauty.length}`);
console.log(`Duplicate beauty ids/names: ${duplicates.length}`);
console.log(`Beauty stores with no affiliate/outbound route: ${missing.length}`);
console.log('');

if (duplicates.length) {
  console.log('DUPLICATES');
  for (const row of duplicates) {
    console.log(
      ` - ${row.duplicate.id || '(no id)'} | ${row.duplicate.name || '(no name)'}  DUP of  ${row.first.id || '(no id)'} | ${row.first.name || '(no name)'}`
    );
  }
  console.log('');
}

if (missing.length) {
  console.log('MISSING ROUTES');
  for (const row of missing) {
    console.log(` - ${row.id || '(no id)'} | ${row.name || '(no name)'}`);
  }
}
