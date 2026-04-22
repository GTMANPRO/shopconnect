#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const { initializeApp } = require('firebase/app');
const { getFirestore, collection, getDocs, query, where } = require('firebase/firestore');

const projectRoot = process.cwd();
const firebaseOptionsPath = path.join(projectRoot, 'lib', 'firebase_options.dart');
const overridesPath = path.join(projectRoot, 'lib', 'data', 'monetization_overrides.dart');
const routerPath = path.join(projectRoot, 'lib', 'services', 'monetization_router.dart');
const outDir = path.join(projectRoot, 'tmp');
fs.mkdirSync(outDir, { recursive: true });

function readText(p) {
  try { return fs.readFileSync(p, 'utf8'); } catch (_) { return ''; }
}

function extractCurrentPlatformBlock(dart) {
  const m = dart.match(/DefaultFirebaseOptions\s*\{[\s\S]*?currentPlatform\s*=>[\s\S]*?return\s+web;[\s\S]*?static const FirebaseOptions web = FirebaseOptions\(([\s\S]*?)\);/);
  if (m && m[1]) return m[1];
  const m2 = dart.match(/static const FirebaseOptions web = FirebaseOptions\(([\s\S]*?)\);/);
  return m2 ? m2[1] : '';
}

function extractField(block, name) {
  const re = new RegExp(name + String.raw`\s*:\s*'([^']*)'`);
  const m = block.match(re);
  return m ? m[1] : '';
}

function loadFirebaseOptions() {
  const dart = readText(firebaseOptionsPath);
  if (!dart) throw new Error('Could not read lib/firebase_options.dart');
  const block = extractCurrentPlatformBlock(dart);
  const options = {
    apiKey: extractField(block, 'apiKey'),
    appId: extractField(block, 'appId'),
    messagingSenderId: extractField(block, 'messagingSenderId'),
    projectId: extractField(block, 'projectId'),
    authDomain: extractField(block, 'authDomain'),
    storageBucket: extractField(block, 'storageBucket'),
    measurementId: extractField(block, 'measurementId'),
  };
  if (!options.apiKey || !options.appId || !options.projectId) {
    throw new Error('Failed to parse Firebase web options from lib/firebase_options.dart');
  }
  return options;
}

function slugify(s) {
  return String(s || '')
    .toLowerCase()
    .replace(/&/g, ' and ')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

function storeTokens(store) {
  const base = new Set();
  const parts = [store.id, store.name]
    .join(' ')
    .toLowerCase()
    .replace(/&/g, ' and ')
    .replace(/[^a-z0-9]+/g, ' ')
    .split(/\s+/)
    .filter(Boolean);
  const stop = new Set(['the','and','of','com','co','inc','llc','ltd','shop','store','stores','official','group','company','wholesale']);
  for (const p of parts) if (p.length >= 3 && !stop.has(p)) base.add(p);
  const slug = slugify(store.name);
  if (slug) base.add(slug.replace(/-/g,''));
  const idSlug = slugify(store.id);
  if (idSlug) base.add(idSlug.replace(/-/g,''));
  return Array.from(base);
}

function extractUrlsNearNeedles(text, needles) {
  const urls = [];
  for (const needle of needles) {
    if (!needle) continue;
    let idx = -1;
    while ((idx = text.toLowerCase().indexOf(needle.toLowerCase(), idx + 1)) !== -1) {
      const start = Math.max(0, idx - 500);
      const end = Math.min(text.length, idx + 800);
      const chunk = text.slice(start, end);
      const matches = chunk.match(/https?:\/\/[^'"\s)>,]+/g) || [];
      for (const u of matches) urls.push(u.replace(/[,'")]+$/g, ''));
      if (urls.length >= 8) return urls;
    }
  }
  return urls;
}

const SEARCH_HOSTS = ['google.', 'bing.', 'yahoo.', 'duckduckgo.', 'search.yahoo.', 'search.brave.'];
const AFFILIATE_HOSTS = ['anrdoezrs.net','jdoqocy.com','tkqlhce.com','dpbolvw.net','kqzyfj.com','commission-junction.com','linksynergy.com','click.linksynergy.com','shareasale.com','awin1.com','impact.com','go.redirectingat.com','skimresources.com','rakutenadvertising.com','partnerize.com','partnerlinks.io'];
const MARKETPLACE_STYLE = ['amazon.','ebay.','aliexpress.','etsy.','walmart.'];

function safeUrl(u) {
  try { return new URL(u); } catch (_) { return null; }
}

function classifyUrl(url, store) {
  if (!url) return { kind: 'unresolved', confidence: 'high', reason: 'No URL found', hostname: '' };
  const parsed = safeUrl(url);
  if (!parsed) return { kind: 'invalid_url', confidence: 'high', reason: 'Malformed URL', hostname: '' };
  const host = parsed.hostname.toLowerCase().replace(/^www\./, '');
  if (SEARCH_HOSTS.some(h => host.includes(h))) {
    return { kind: 'search_fallback', confidence: 'high', reason: 'Search-engine host', hostname: host };
  }
  if (AFFILIATE_HOSTS.some(h => host.includes(h))) {
    return { kind: 'affiliate_redirect', confidence: 'medium', reason: 'Affiliate-network host', hostname: host };
  }
  const tokens = storeTokens(store);
  const hostPlain = host.replace(/[^a-z0-9]/g, '');
  const tokenMatch = tokens.find(t => hostPlain.includes(t.replace(/[^a-z0-9]/g, '')));
  if (tokenMatch) {
    return { kind: 'direct_merchant_like', confidence: 'medium', reason: `Hostname matches token ${tokenMatch}`, hostname: host };
  }
  if (MARKETPLACE_STYLE.some(h => host.includes(h))) {
    return { kind: 'marketplace_like', confidence: 'medium', reason: 'Marketplace-style host', hostname: host };
  }
  return { kind: 'unknown_domain', confidence: 'low', reason: 'Hostname does not resemble merchant or known affiliate network', hostname: host };
}

function chooseCandidateUrl(store, sourceText) {
  const affiliateUrl = String(store.affiliateUrl || '').trim();
  if (affiliateUrl) return { url: affiliateUrl, source: 'firestore.affiliateUrl' };
  const directUrl = String(store.outboundUrl || '').trim();
  if (directUrl) return { url: directUrl, source: 'firestore.outboundUrl' };
  const needles = [store.id, slugify(store.id), store.name, slugify(store.name)].filter(Boolean);
  const urls = extractUrlsNearNeedles(sourceText, needles);
  if (urls.length) return { url: urls[0], source: 'source_scan' };
  return { url: '', source: 'none' };
}

async function main() {
  const options = loadFirebaseOptions();
  const app = initializeApp(options);
  const db = getFirestore(app);

  const sourceText = [readText(overridesPath), readText(routerPath)].join('\n\n');
  const qy = query(collection(db, 'stores'), where('active', '==', true));
  const snap = await getDocs(qy);
  const stores = snap.docs.map((d) => {
    const data = d.data() || {};
    const rawCats = Array.isArray(data.categories) ? data.categories : (data.categoryId ? [String(data.categoryId)] : []);
    return {
      id: d.id,
      name: String(data.name || '').trim(),
      affiliateUrl: String(data.affiliateUrl || '').trim(),
      outboundUrl: String(data.outboundUrl || '').trim(),
      categories: rawCats.map(v => String(v || '').trim()).filter(Boolean),
      network: String(data.network || '').trim(),
      active: !!data.active,
    };
  }).sort((a,b)=>a.name.localeCompare(b.name));

  const rows = stores.map((store) => {
    const candidate = chooseCandidateUrl(store, sourceText);
    const cls = classifyUrl(candidate.url, store);
    return {
      category: store.categories[0] || '',
      storeId: store.id,
      storeName: store.name,
      candidateUrl: candidate.url,
      candidateSource: candidate.source,
      classification: cls.kind,
      confidence: cls.confidence,
      reason: cls.reason,
      hostname: cls.hostname,
      affiliateUrlPresent: !!store.affiliateUrl,
    };
  });

  const counts = {};
  for (const r of rows) counts[r.classification] = (counts[r.classification] || 0) + 1;

  const suspicious = rows.filter(r => ['search_fallback','unknown_domain','invalid_url','unresolved'].includes(r.classification));
  const affiliate = rows.filter(r => r.classification === 'affiliate_redirect');
  const direct = rows.filter(r => r.classification === 'direct_merchant_like');
  const marketplace = rows.filter(r => r.classification === 'marketplace_like');

  const summary = {
    activeStores: rows.length,
    classificationCounts: counts,
    suspiciousCount: suspicious.length,
    directMerchantLikeCount: direct.length,
    affiliateRedirectCount: affiliate.length,
    marketplaceLikeCount: marketplace.length,
    generatedAt: new Date().toISOString(),
  };

  const jsonPath = path.join(outDir, 'live_routing_classifier_report.json');
  fs.writeFileSync(jsonPath, JSON.stringify({ summary, rows }, null, 2));

  const csvPath = path.join(outDir, 'live_routing_classifier_suspicious.csv');
  const header = ['category','storeId','storeName','classification','confidence','hostname','candidateSource','candidateUrl','reason'];
  const lines = [header.join(',')];
  for (const r of suspicious) {
    lines.push(header.map(k => '"' + String(r[k] ?? '').replace(/"/g, '""') + '"').join(','));
  }
  fs.writeFileSync(csvPath, lines.join('\n'));

  console.log(`Active stores: ${rows.length}`);
  console.log(`Direct merchant-like: ${direct.length}`);
  console.log(`Affiliate redirect: ${affiliate.length}`);
  console.log(`Marketplace-like: ${marketplace.length}`);
  console.log(`Suspicious: ${suspicious.length}`);
  console.log('');
  const order = ['search_fallback','unknown_domain','invalid_url','unresolved','affiliate_redirect','direct_merchant_like','marketplace_like'];
  for (const key of order) {
    if (counts[key] != null) console.log(`- ${key}: ${counts[key]}`);
  }
  if (suspicious.length) {
    console.log('');
    console.log('Top suspicious cases:');
    for (const r of suspicious.slice(0, 40)) {
      console.log(`- ${r.storeId} | ${r.storeName} | ${r.classification} | ${r.hostname || 'n/a'} | ${r.candidateUrl || 'n/a'}`);
    }
  }
  console.log('');
  console.log(`Saved JSON report: ${jsonPath}`);
  console.log(`Saved CSV report: ${csvPath}`);
}

main().catch((err) => {
  console.error(err && err.stack ? err.stack : err);
  process.exit(1);
});
