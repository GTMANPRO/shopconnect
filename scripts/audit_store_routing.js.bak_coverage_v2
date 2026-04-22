#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const storesPath = path.join(root, 'assets', 'data', 'stores.production.json');
const outDir = path.join(root, 'tmp');
const jsonReportPath = path.join(outDir, 'routing_audit_report.json');
const csvReportPath = path.join(outDir, 'routing_audit_missing.csv');

function normalize(value) {
  return String(value || '')
    .trim()
    .toLowerCase()
    .replace(/&/g, 'and')
    .replace(/\+/g, 'plus')
    .replace(/'/g, '')
    .replace(/!/g, '')
    .replace(/[^a-z0-9]+/g, '_')
    .replace(/_+/g, '_')
    .replace(/^_|_$/g, '');
}

const stores = JSON.parse(fs.readFileSync(storesPath, 'utf8')).stores || [];
const overridesDart = fs.readFileSync(path.join(root, 'lib', 'data', 'monetization_overrides.dart'), 'utf8');

function hasMapping(id, name) {
  const a = normalize(id);
  const b = normalize(name);
  return overridesDart.includes(`'${a}':`) || overridesDart.includes(`'${b}':`) || overridesDart.includes(`'${name}':`);
}

const byCategory = new Map();
for (const store of stores) {
  const category = Array.isArray(store.categories) && store.categories.length ? store.categories[0] : 'uncategorized';
  if (!byCategory.has(category)) byCategory.set(category, []);
  byCategory.get(category).push(store);
}

const report = [];
const csvRows = [['category', 'id', 'name']];
for (const [category, items] of [...byCategory.entries()].sort()) {
  const missing = items.filter((s) => !hasMapping(s.id, s.name));
  const entry = {
    category,
    total: items.length,
    mapped: items.length - missing.length,
    missing: missing.map((s) => ({ id: s.id, name: s.name })),
  };
  report.push(entry);
  console.log(`\n${category}: ${items.length} stores, ${entry.mapped} mapped, ${missing.length} missing`);
  for (const store of missing) {
    console.log(`  - ${store.id} | ${store.name}`);
    csvRows.push([category, store.id, store.name]);
  }
}

fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(jsonReportPath, JSON.stringify({ generatedAt: new Date().toISOString(), categories: report }, null, 2));
fs.writeFileSync(csvReportPath, csvRows.map((row) => row.map((v) => String(v).includes(',') ? `"${String(v).replace(/"/g, '""')}"` : String(v)).join(',')).join('\n'));

console.log(`\nSaved JSON report: ${jsonReportPath}`);
console.log(`Saved CSV report: ${csvReportPath}`);
