/*
 * Smoke test suite for the ACC v2 frontend.
 *
 * Covers what has broken in practice during development: every menu
 * rendering without a JS error, add/edit/delete on a transaction
 * correctly moving numbers on the Dashboard, and a Jurnal Umum nota
 * correctly appearing/updating/disappearing on Trial Hutang.
 *
 * Run:
 *   npm install --no-save playwright
 *   npx playwright install chromium
 *   node tests/smoke.test.js
 *
 * Starts its own static server on a free port, so nothing else needs
 * to be running first. Exits non-zero if any check fails.
 */
const { chromium } = require('playwright');
const http = require('http');
const fs = require('fs');
const path = require('path');

const FRONTEND_DIR = path.join(__dirname, '..', 'frontend');
const MIME = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css' };

let passed = 0, failed = 0;
function check(name, condition) {
  if (condition) { passed++; console.log('  ok   -', name); }
  else { failed++; console.log('  FAIL -', name); }
}

function startServer() {
  return new Promise((resolve) => {
    const server = http.createServer((req, res) => {
      let filePath = path.join(FRONTEND_DIR, decodeURIComponent(req.url.split('?')[0]));
      if (req.url === '/') filePath = path.join(FRONTEND_DIR, 'index.html');
      fs.readFile(filePath, (err, data) => {
        if (err) { res.writeHead(404); res.end(); return; }
        res.writeHead(200, { 'Content-Type': MIME[path.extname(filePath)] || 'application/octet-stream' });
        res.end(data);
      });
    });
    server.listen(0, () => resolve(server));
  });
}

(async () => {
  const server = await startServer();
  const port = server.address().port;
  const url = `http://localhost:${port}/index.html`;

  const browser = await chromium.launch();
  const page = await browser.newPage();
  const consoleErrors = [];
  page.on('pageerror', (err) => consoleErrors.push('pageerror: ' + err.message));
  page.on('console', (msg) => {
    const t = msg.text();
    if (msg.type() === 'error' && !t.includes('404') && !t.includes('RESET')) consoleErrors.push(t);
  });

  await page.goto(url, { waitUntil: 'networkidle' });
  await page.waitForTimeout(500);

  console.log('\n1. Every menu page renders without a console error');
  const navIds = await page.evaluate(() => NAV.flatMap((g) => g.items.map((i) => i.id)));
  for (const id of navIds) {
    consoleErrors.length = 0;
    await page.evaluate((pid) => go(pid), id);
    await page.waitForTimeout(200);
    check(`page "${id}" has no console errors`, consoleErrors.length === 0);
  }

  console.log('\n2. Kas Keluar: add -> Dashboard total moves -> edit category -> delete reverts');
  const projName = 'Kemhan Bangun Rumdis Cimahi';
  const before = await page.evaluate(
    (nm) => computeProjectProgressRows().find((r) => r.nama === nm),
    projName
  );
  await page.evaluate(() => go('kas_keluar'));
  await page.waitForTimeout(200);
  await page.click('#btnAdd');
  await page.waitForTimeout(200);
  await page.click('#f_akunLawan_ssel .ssel-input');
  await page.fill('#f_akunLawan_ssel .ssel-input', '5.1.1-Biaya Bahan');
  await page.waitForTimeout(150);
  await page.click('#f_akunLawan_ssel .ssel-opt[data-val]');
  await page.click('#f_project_ssel .ssel-input');
  await page.fill('#f_project_ssel .ssel-input', projName);
  await page.waitForTimeout(150);
  await page.click('#f_project_ssel .ssel-opt[data-val]');
  await page.fill('#f_amount', '1000000');
  await page.fill('#f_ket', 'SMOKE TEST TXN');
  await page.click('#mSave');
  await page.waitForTimeout(200);

  const afterAdd = await page.evaluate(
    (nm) => computeProjectProgressRows().find((r) => r.nama === nm),
    projName
  );
  check('adding a Biaya Bahan txn increases Dashboard bahan by 1,000,000',
    afterAdd.bahan === before.bahan + 1000000);

  const editBtn = await page.evaluateHandle(() => {
    const row = [...document.querySelectorAll('tr')].find((tr) => tr.textContent.includes('SMOKE TEST TXN'));
    return row ? row.querySelector('[data-edit]') : null;
  });
  await editBtn.asElement().click();
  await page.waitForTimeout(200);
  await page.click('#f_akunLawan_ssel .ssel-input');
  await page.fill('#f_akunLawan_ssel .ssel-input', '5.1.2-Biaya Upah');
  await page.waitForTimeout(150);
  await page.click('#f_akunLawan_ssel .ssel-opt[data-val]');
  await page.click('#mSave');
  await page.waitForTimeout(200);

  const afterEdit = await page.evaluate(
    (nm) => computeProjectProgressRows().find((r) => r.nama === nm),
    projName
  );
  check('editing to Biaya Upah moves the amount off bahan and onto upah',
    afterEdit.bahan === before.bahan && afterEdit.upah === before.upah + 1000000);

  const delBtn = await page.evaluateHandle(() => {
    const row = [...document.querySelectorAll('tr')].find((tr) => tr.textContent.includes('SMOKE TEST TXN'));
    return row ? row.querySelector('[data-del]') : null;
  });
  await delBtn.asElement().click();
  await page.waitForTimeout(200);
  await page.click('#mSave');
  await page.waitForTimeout(200);

  const afterDelete = await page.evaluate(
    (nm) => computeProjectProgressRows().find((r) => r.nama === nm),
    projName
  );
  check('deleting the txn reverts bahan/upah back to the original values',
    afterDelete.bahan === before.bahan && afterDelete.upah === before.upah);

  console.log('\n3. Jurnal Umum nota <-> Trial Hutang linking');
  await page.evaluate(() => go('jurnal'));
  await page.waitForTimeout(200);
  await page.click('#btnAdd');
  await page.waitForTimeout(200);
  await page.click('#f_akun_ssel .ssel-input');
  await page.fill('#f_akun_ssel .ssel-input', 'Hutang Dagang');
  await page.waitForTimeout(150);
  await page.click('#f_akun_ssel .ssel-opt[data-val]');
  await page.click('#f_relasi_ssel .ssel-input');
  await page.fill('#f_relasi_ssel .ssel-input', 'HU-Berkat');
  await page.waitForTimeout(150);
  await page.click('#f_relasi_ssel .ssel-opt[data-val]');
  await page.selectOption('#f_jenis', 'kredit');
  await page.fill('#f_amount', '4321000');
  await page.fill('#f_ket', 'SMOKE TEST NOTA');
  await page.click('#mSave');
  await page.waitForTimeout(200);

  const notaSeen = await page.evaluate(() =>
    computeHutangDagangRows().some((r) => r.ket === 'SMOKE TEST NOTA' && r.amount === 4321000 && r.status === 'BELUM_BAYAR')
  );
  check('new nota appears on Trial Hutang as BELUM_BAYAR', notaSeen);

  const jurnalDelBtn = await page.evaluateHandle(() => {
    const row = [...document.querySelectorAll('tr')].find((tr) => tr.textContent.includes('SMOKE TEST NOTA'));
    return row ? row.querySelector('[data-del]') : null;
  });
  await jurnalDelBtn.asElement().click();
  await page.waitForTimeout(200);
  await page.click('#mSave');
  await page.waitForTimeout(200);
  const notaGone = await page.evaluate(() => !computeHutangDagangRows().some((r) => r.ket === 'SMOKE TEST NOTA'));
  check('deleting the jurnal entry removes it from Trial Hutang', notaGone);

  console.log('\n4. Ref No numbering stays unique per prefix even after a mid-sequence delete');
  const refCheck = await page.evaluate(() => {
    const coTxns = DB.txns.filter((t) => t.ref && t.ref.startsWith('CO-'))
      .sort((a, b) => parseInt(a.ref.slice(a.ref.lastIndexOf('-') + 1)) - parseInt(b.ref.slice(b.ref.lastIndexOf('-') + 1)));
    const maxBefore = parseInt(coTxns[coTxns.length - 1].ref.slice(coTxns[coTxns.length - 1].ref.lastIndexOf('-') + 1));
    const midRef = coTxns[Math.floor(coTxns.length / 2)].ref;
    const snapshot = DB.txns;
    DB.txns = DB.txns.filter((t) => t.ref !== midRef);
    const next = nextRefFor('kas_keluar', '2026-08-24');
    DB.txns = snapshot; // restore
    const nextSeq = parseInt(next.slice(next.lastIndexOf('-') + 1));
    return { maxBefore, nextSeq };
  });
  check('next ref after a mid-sequence delete is still max+1 (no collision)',
    refCheck.nextSeq === refCheck.maxBefore + 1);

  await browser.close();
  server.close();

  console.log(`\n${passed} passed, ${failed} failed`);
  process.exit(failed ? 1 : 0);
})();
