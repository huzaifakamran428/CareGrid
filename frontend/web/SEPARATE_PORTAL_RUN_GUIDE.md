# CareGrid V8 — separate role-based UI previews

This release fixes a navigation/architecture mistake in the old UI showcase: **the NGO and Admin no longer have links to a screen launcher or to each other's portals**. The old `frontend/web/ui_preview/` showcase has been removed.

## Where the screens live

- `frontend/web/ngo_portal/index.html` — NGO-only web preview: dashboard, walk-in registration, beneficiaries, digital IDs, providers, sponsors.
- `frontend/web/admin_portal/index.html` — Admin-only web preview: dashboard, registration requests, beneficiary/organization records, monitoring, reports, and complaints.

## Run in VS Code on macOS

Open a VS Code terminal **at the caregrid root**. Run NGO portal:

```bash
python3 -m http.server 8001 --directory frontend/web/ngo_portal
```

Open `http://127.0.0.1:8001/` in Safari.

To run Admin separately, open a **second terminal** (still at caregrid root):

```bash
python3 -m http.server 8002 --directory frontend/web/admin_portal
```

Open `http://127.0.0.1:8002/` in Safari. Admin Complaints: `http://127.0.0.1:8002/#complaints`.

If you are currently running the earlier `ui_preview` on port 8000, press `Ctrl+C` in that terminal and close/reload its old Safari tabs. Run the new versions above. Don't run Live Server from the overall repository root for a privacy demonstration: the old shared-root approach exposes all static files.

## What was corrected

1. Removed the all-roles launcher and cross-portal sidebar/navigation links.
2. Split static preview pages and assets into separate NGO and Admin directories.
3. Each portal's main JavaScript entry is pinned to its own role, rather than detecting a switchable role from the page HTML.
4. Admin Complaints remains an Admin sidebar section; it is *not* exposed as a link from NGO.
5. Prevented the NGO browser UI from exporting demo personal records into the previous shared browser localStorage archive.
6. Unrelated Django/backend, Flutter, and original project scaffolding files are unchanged.

## Security and functional limits — IMPORTANT

**This is still UI-only, not a secure login system.** Static HTML cannot authenticate users or restrict authorization. Anyone who has access to the Admin URL can open its fictional preview; there is no authentication or permissions check. Separating the two Python static-server roots means the NGO server does not serve the Admin page, which prevents accidental switching in development **but is not production-grade access control**.

The two distinct ports have separate browser origins, so NGO test uploads and local records **do not automatically appear in Admin or the Flutter beneficiary app**. Implementing cross-role access safely requires a backend with user login, role-based permission checks on every record/file request, NGO ownership checks, and private audited document storage. Until then, use **fictional names, CNICs, photographs and documents only**, never real beneficiary records.

For production, do not publish either static preview as a portal handling real records.
