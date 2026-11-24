# CareGrid local assistant — shared SQLite demo

The **NGO, Admin, Labs, and Pharmacy** frontend previews now use a **single same-origin localhost API** for their admin-managed FAQ responses and demo conversation history. The service persists fictional examples in SQLite on this Mac; answers are still **rule-based, not generative AI**.

## 1. Start the demo from the CareGrid repository root

In a new Terminal window:

```bash
cd ~/Desktop/CareGrid-Fresh
git pull origin main

# Generate a fresh local-demo administrator key (16+ characters).
export CAREGRID_DEMO_ADMIN_KEY="$(python3 -c 'import secrets;print(secrets.token_urlsafe(24))')"
printf 'Local demo admin key: %s\n' "$CAREGRID_DEMO_ADMIN_KEY"
python3 frontend/web/run_local_demo.py
```

If the repo was moved, use its actual location, such as `~/Developer/CareGrid-Fresh`. The admin key is **not** committed in GitHub or saved in your browser. Copy the generated key somewhere temporary so you can unlock the Admin page. Restarting the app with a different key does not erase SQLite records.

The demo uses Python's standard library (no extra packages). The database is created at `~/.caregrid_demo/assistant.sqlite3` by default and remains after you close Safari or restart the app. To use another path, set `CAREGRID_DEMO_DB` before starting the server. Store only fictional data.

## 2. Open the four portal previews

Open these in any browser, on the same Mac:

| Role | URL |
|---|---|
| NGO | http://127.0.0.1:8000/ngo_portal/index.html |
| Admin | http://127.0.0.1:8000/admin_portal/index.html |
| Admin Assistant Control | http://127.0.0.1:8000/admin_portal/assistant_control.html |
| Lab | http://127.0.0.1:8000/labs/templates/dashboard.html |
| Pharmacy | http://127.0.0.1:8000/pharmacy_portal/index.html |
| Lab chatbot full-screen | http://127.0.0.1:8000/chatbot/templates/chatbot.html |

Use the **Ask CareGrid** button at the bottom right of any portal. The widget will say **"Shared localhost FAQ server"** when connected. If you open a page without the runner, it explicitly falls back to a **browser-only demo**, which does **not** synchronize.

## 3. Use Admin Assistant Control

From the Admin sidebar choose **Assistant Control**. Enter the generated local demo admin key at the "Shared assistant connection" panel. The admin controls stay locked until the server accepts the key.

You can:
- Add/edit/disable/delete FAQ entries, keywords, response text and which roles see them.
- Change the minimum keyword matches, question-length cap, prohibited topics and fallback response.
- Enable/disable local history storage.
- Refresh history from the shared SQLite server, filter by role, export demo JSON or delete all demo turns.

Try asking the Pharmacy assistant one question. Then open Admin Assistant Control from **another browser profile on the same Mac**, unlock it and choose **Refresh server data**. That pharmacy turn should appear in the admin history. This is now **server-shared on one Mac** and isn't limited to the same Safari profile.

If you restart the server, rules and history remain in SQLite. The SQLite store keeps the most recent 500 demo chat turns; this is a convenience cap, not a retention policy suitable for real personal data.

## 4. Troubleshooting

- **"No localhost API":** start the unified runner; the old `python3 -m http.server` command does not expose the assistant API.
- **"Admin key not configured":** stop the runner with `Ctrl+C`, set `CAREGRID_DEMO_ADMIN_KEY` (16+ characters), and restart it.
- **"Invalid local demo administrator key":** use the same value from the Terminal that started the currently running server.
- **Port already in use:** stop any existing web server on port 8000 before starting this one.
- **Wrong portal responses:** refresh the page. The new widget reloads FAQs from the server when opened.
- **Existing offline demo records not appearing:** legacy `localStorage` data is intentionally **not automatically imported** into server history, to avoid silently uploading browser data. New questions will be centrally recorded.

## 5. Security and technical limits (important)

This is a **local-only prototype**. The demo runner binds to `127.0.0.1` and has a rudimentary admin-key gate, but the role UIs themselves do **not** authenticate or authorize real people, and users can claim portal roles. Do not publish or deploy this as a production service.

The redaction patterns catch common CNICs, phone numbers and emails, but **do not guarantee removal of all sensitive information**. Never type genuine CNICs, passwords, medical records, names of actual beneficiaries or payment information.

Real deployment requires:
- Authenticated identities, organization ownership and per-record role-based permissions
- Signed, expiring sessions and secure server-side authentication with rate limits and audit trails
- HTTPS; robust privacy and retention handling, deletion workflows, and professional review
- Real approved knowledge ingestion and a reviewed AI/RAG pipeline if live AI is desired
- Integration with verified beneficiary, laboratory, pharmacy and NGO APIs

The Flutter beneficiary chatbot remains a **separate in-memory demo** in this phase. It is not connected to this local web API, and actual web-to-mobile account synchronization is still not implemented.
