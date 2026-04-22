#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

const root = path.resolve(__dirname, '..');
const libDir = path.join(root, 'lib');
const outDir = path.join(root, 'tmp');
const reportPath = path.join(outDir, 'flutter_perf_audit_report.json');

const rules = [
  { key: 'shrinkWrap_true', regex: /shrinkWrap\s*:\s*true/g, note: 'Can force expensive layout in long lists.' },
  { key: 'single_child_scroll_view', regex: /SingleChildScrollView\s*\(/g, note: 'Watch for large child trees and nested scrollables.' },
  { key: 'intrinsic_height', regex: /IntrinsicHeight\s*\(/g, note: 'Intrinsic passes are expensive.' },
  { key: 'intrinsic_width', regex: /IntrinsicWidth\s*\(/g, note: 'Intrinsic passes are expensive.' },
  { key: 'opacity_widget', regex: /Opacity\s*\(/g, note: 'Opacity can trigger extra compositing.' },
  { key: 'backdrop_filter', regex: /BackdropFilter\s*\(/g, note: 'BackdropFilter is expensive on web/mobile.' },
  { key: 'clip_r_rect', regex: /ClipRRect\s*\(/g, note: 'Clipping many list items can be expensive.' },
  { key: 'image_network', regex: /Image\.network\s*\(/g, note: 'Check caching and image dimensions.' },
  { key: 'cached_network_image', regex: /CachedNetworkImage\s*\(/g, note: 'Good for caching, but still audit image size/count.' },
  { key: 'future_builder', regex: /FutureBuilder\s*</g, note: 'Ensure it is not recreated on every build.' },
  { key: 'stream_builder', regex: /StreamBuilder\s*</g, note: 'Audit rebuild frequency.' },
  { key: 'animated_container', regex: /AnimatedContainer\s*\(/g, note: 'Fine in isolation, expensive in large lists.' },
  { key: 'shader_mask', regex: /ShaderMask\s*\(/g, note: 'ShaderMask can be expensive.' },
  { key: 'where_to_list', regex: /\.where\([^\n]+\)\.toList\(/g, note: 'Watch for repeated filtering in build methods.' },
];

function walk(dir, acc = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, entry.name);
    if (entry.isDirectory()) walk(p, acc);
    else if (entry.isFile() && p.endsWith('.dart')) acc.push(p);
  }
  return acc;
}

function lineNumberAtIndex(text, idx) {
  return text.slice(0, idx).split('\n').length;
}

const files = fs.existsSync(libDir) ? walk(libDir) : [];
const findings = [];

for (const file of files) {
  const text = fs.readFileSync(file, 'utf8');
  for (const rule of rules) {
    const matches = [...text.matchAll(rule.regex)];
    for (const match of matches) {
      findings.push({
        file: path.relative(root, file),
        rule: rule.key,
        line: lineNumberAtIndex(text, match.index || 0),
        note: rule.note,
        snippet: match[0],
      });
    }
  }
}

fs.mkdirSync(outDir, { recursive: true });
const summary = rules.map((rule) => ({
  rule: rule.key,
  count: findings.filter((f) => f.rule === rule.key).length,
  note: rule.note,
}));
fs.writeFileSync(reportPath, JSON.stringify({ generatedAt: new Date().toISOString(), summary, findings }, null, 2));

console.log('\nFlutter performance audit summary');
for (const item of summary) {
  console.log(`- ${item.rule}: ${item.count}`);
}
console.log(`\nSaved report: ${reportPath}`);
if (findings.length) {
  console.log('\nTop findings:');
  for (const finding of findings.slice(0, 40)) {
    console.log(`- ${finding.file}:${finding.line} [${finding.rule}] ${finding.note}`);
  }
}
