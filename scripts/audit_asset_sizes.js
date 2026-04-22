#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const assetsDir = path.join(root, 'assets');
const outDir = path.join(root, 'tmp');
const reportPath = path.join(outDir, 'asset_size_audit_report.json');
const thresholdWarn = 200 * 1024;
const thresholdHot = 500 * 1024;

function walk(dir, acc = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, entry.name);
    if (entry.isDirectory()) walk(p, acc);
    else if (entry.isFile()) acc.push(p);
  }
  return acc;
}

const allowed = new Set(['.png', '.jpg', '.jpeg', '.webp', '.gif', '.svg', '.json']);
const files = fs.existsSync(assetsDir) ? walk(assetsDir).filter((f) => allowed.has(path.extname(f).toLowerCase())) : [];
const rows = files.map((file) => {
  const size = fs.statSync(file).size;
  return {
    file: path.relative(root, file),
    bytes: size,
    level: size >= thresholdHot ? 'hot' : size >= thresholdWarn ? 'warn' : 'ok',
  };
}).sort((a, b) => b.bytes - a.bytes);

fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(reportPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: rows }, null, 2));

console.log('\nLargest assets');
for (const row of rows.slice(0, 30)) {
  console.log(`- ${row.file} | ${row.bytes} bytes | ${row.level}`);
}
console.log(`\nSaved report: ${reportPath}`);
