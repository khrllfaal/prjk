# Smoke tests

Basic regression checks for `frontend/index.html` — every menu page,
the core add/edit/delete-and-it-actually-links flow, and the Ref No
numbering scheme. Uses real company data if you have
`frontend/data.local.js` set up (see `docs/SETUP.md`); otherwise runs
against the placeholder demo data baked into `index.html`.

## Run

```bash
cd tests
npm install
npx playwright install chromium
npm test
```

Prints a pass/fail line per check and exits non-zero if anything
fails — safe to wire into CI later. No server needs to be running
first; the script starts and stops its own on a free port.
