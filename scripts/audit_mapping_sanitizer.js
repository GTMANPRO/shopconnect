#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const root = process.cwd();
const overridesPath = path.join(root, 'lib', 'data', 'monetization_overrides.dart');
const routerPath = path.join(root, 'lib', 'services', 'monetization_router.dart');
const outJson = path.join(root, 'tmp', 'mapping_sanitizer_report.json');
const outCsv = path.join(root, 'tmp', 'mapping_sanitizer_suspicious.csv');

function read(p) {
  try { return fs.readFileSync(p, 'utf8'); } catch { return ''; }
}
function slugify(s) {
  return String(s || '')
    .toLowerCase()
    .replace(/&/g, ' and ')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .replace(/-{2,}/g, '-');
}
function domainFromUrl(url) {
  try {
    const u = new URL(url);
    return u.hostname.replace(/^www\./, '').toLowerCase();
  } catch {
    return '';
  }
}
function tokens(s) {
  return slugify(s).split('-').filter(Boolean);
}
function looksSearchLike(url) {
  return /(google\.|bing\.|search\?|duckduckgo\.|yahoo\.)/i.test(url || '');
}
function parseEntries(text) {
  const entries = [];
  const rx = /['"]([A-Za-z0-9_\-]+)['"]\s*:\s*['"](https?:[^'"]+)['"]/g;
  let m;
  while ((m = rx.exec(text)) !== null) {
    entries.push({ key: m[1], url: m[2] });
  }
  return entries;
}
function loadStores() {
  const candidates = [
    path.join(root, 'assets', 'data', 'stores.json'),
    path.join(root, 'assets', 'data', 'stores.production.json'),
  ];
  for (const p of candidates) {
    try {
      const raw = JSON.parse(fs.readFileSync(p, 'utf8'));
      const arr = Array.isArray(raw) ? raw : Array.isArray(raw.items) ? raw.items : [];
      if (arr.length) return arr;
    } catch {}
  }
  return [];
}

const overridesText = read(overridesPath);
const routerText = read(routerPath);
const stores = loadStores();
const entries = parseEntries(overridesText);
const storeIndex = new Map();
for (const s of stores) {
  const ids = [s.id, s.storeId, s.slug].filter(Boolean);
  for (const id of ids) storeIndex.set(String(id), s);
}

const suspicious = [];
const summary = {
  root,
  overridesPath,
  routerPath,
  totalOverrideEntries: entries.length,
  suspiciousCount: 0,
  categories: {
    search_fallback_like: 0,
    invalid_url: 0,
    unknown_domain: 0,
    likely_crosswired: 0,
    redirect_like: 0,
  },
};

for (const e of entries) {
  const store = storeIndex.get(e.key) || null;
  const storeName = store?.name || e.key;
  const domain = domainFromUrl(e.url);
  const keyTokens = tokens(e.key);
  const nameTokens = tokens(storeName);
  const allTokens = [...new Set([...keyTokens, ...nameTokens])].filter(t => t.length >= 3);

  let reason = null;
  if (!e.url || !/^https?:\/\//i.test(e.url)) {
    reason = 'invalid_url';
  } else if (looksSearchLike(e.url)) {
    reason = 'search_fallback_like';
  } else if (/(shopconnect\.com|localhost|example\.com)/i.test(domain)) {
    reason = 'redirect_like';
  } else {
    const domainSlug = slugify(domain.replace(/\.(com|net|org|io|co|us|ai|store|shop)$/i, ''));
    const domainTokens = domainSlug.split('-').filter(Boolean);
    const matched = allTokens.some(t => domainTokens.includes(t));
    const knownAlias = [
      ['academy-sports-outdoors', ['academy']],
      ['bath-body-works', ['bath', 'body', 'works']],
      ['banana-republic', ['banana', 'republic']],
      ['american-eagle', ['american', 'eagle']],
      ['b-h-photo', ['bh', 'photo', 'video']],
      ['1-800-flowers', ['flowers']],
      ['1-800-petmeds', ['petmeds']],
      ['fred-meyer', ['fred', 'meyer']],
      ['louis-vuitton', ['louis', 'vuitton']],
      ['saint-laurent', ['saint', 'laurent', 'ysl']],
      ['ysl', ['ysl', 'saint', 'laurent']],
    ];
    const aliasTokens = (knownAlias.find(([k]) => k === e.key)?.[1] || []);
    const aliasMatched = aliasTokens.some(t => domainTokens.includes(t));
    if (!matched && !aliasMatched) {
      // stronger signal for obvious cross-wire: unrelated merchant domain from common sample stores
      if (domain && !/rakuten|cj|impact|anrdoezrs|linksynergy|shareasale|awin|partnerize|skimresources|go2cloud|howl|flexoffers/i.test(domain)) {
        reason = 'likely_crosswired';
      } else {
        reason = 'unknown_domain';
      }
    }
  }

  if (reason) {
    summary.categories[reason] = (summary.categories[reason] || 0) + 1;
    suspicious.push({
      storeId: e.key,
      storeName,
      reason,
      domain,
      url: e.url,
    });
  }
}

summary.suspiciousCount = suspicious.length;
fs.mkdirSync(path.join(root, 'tmp'), { recursive: true });
fs.writeFileSync(outJson, JSON.stringify({ summary, suspicious }, null, 2));
const csv = ['store_id,store_name,reason,domain,url', ...suspicious.map(r => {
  const esc = v => '"' + String(v ?? '').replace(/"/g, '""') + '"';
  return [r.storeId, r.storeName, r.reason, r.domain, r.url].map(esc).join(',');
})].join('\n');
fs.writeFileSync(outCsv, csv);

console.log(`Override entries: ${summary.totalOverrideEntries}`);
console.log(`Suspicious override mappings: ${summary.suspiciousCount}`);
for (const [k, v] of Object.entries(summary.categories)) {
  console.log(`- ${k}: ${v}`);
}
console.log('');
console.log('Top suspicious override mappings:');
for (const row of suspicious.slice(0, 40)) {
  console.log(`- ${row.storeId} | ${row.storeName} | ${row.reason} | ${row.domain || 'n/a'} | ${row.url || 'n/a'}`);
}
console.log('');
console.log(`Saved JSON report: ${outJson}`);
console.log(`Saved CSV report: ${outCsv}`);

const maybeBrokenRouterHints = [];
if (/shopconnect\.com\/r\//i.test(overridesText) || /shopconnect\.com\/r\//i.test(routerText)) {
  maybeBrokenRouterHints.push('Internal redirect-style URLs detected (shopconnect.com/r/...).');
}
if (maybeBrokenRouterHints.length) {
  console.log('');
  console.log('Hints:');
  for (const h of maybeBrokenRouterHints) console.log(`- ${h}`);
}
