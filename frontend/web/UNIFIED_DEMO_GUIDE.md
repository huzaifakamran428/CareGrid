# CareGrid — unified local web preview

The NGO, Admin, Labs, and Pharmacy pages are separate role-specific UI previews, but they must share **one browser origin** for the local FAQ assistant settings and sanitized conversation history.

## Start the local browser demo

From the **CareGrid repository root**:

```bash
python3 frontend/web/run_local_demo.py
```

Open these URLs in **the same browser profile** (e.g. Safari):

| Portal | Local URL |
|---|---|
| NGO | http://127.0.0.1:8000/ngo_portal/index.html |
| Admin | http://127.0.0.1:8000/admin_portal/index.html |
| Assistant Control (Admin demo) | http://127.0.0.1:8000/admin_portal/assistant_control.html |
| Lab | http://127.0.0.1:8000/labs/templates/dashboard.html |
| Pharmacy | http://127.0.0.1:8000/pharmacy_portal/index.html |
| Standalone Lab assistant | http://127.0.0.1:8000/chatbot/templates/chatbot.html |
| Lab chat history | http://127.0.0.1:8000/chatbot/templates/chat_history.html |

Each portal includes an **Ask CareGrid** widget at the bottom right. The Admin portal also has an **Assistant Control** sidebar link. There, admins can add/edit/disable FAQ entries, choose role visibility, define matching thresholds and fallback criteria, turn demo history on/off, filter history by role, clear it and export JSON.

For a test, open NGO, ask a question, then open Admin → Assistant Control in another tab of the **same Safari profile**. The logged (redacted) demo conversation should appear. Data is stored under `caregrid.demo.assistant.*` in browser localStorage and is not shared between different browsers or machines.

## Important architecture and privacy boundaries

- These pages are **frontend-only prototypes**, not authenticated or secure role portals. The Admin URL is not protected by a login, and browser localStorage is visible to other pages of the same origin.
- **Never use real CNICs, medical details, credentials, patient data or other personal information.** The assistant attempts to redact common sensitive patterns but this is not comprehensive.
- This is a **rule/FAQ-based demo**, not actual generative AI or a live RAG system, and cannot verify subsidies, prescriptions, patient identities or transactions.
- The settings/history are **local to one browser profile and one origin**. Admin cannot see chats from another browser or device. Live shared chat history requires a backend with database, user authentication, RBAC, consent/retention rules and server-side audit logging.
- Keep the server on `127.0.0.1`. Do not deploy these sample portals publicly or handle actual records.
- Existing separate ports `8001` / `8002` do **not** share localStorage, and their isolated static roots cannot load the new shared CSS/JS. Use this unified local runner for the connected demo.
- Existing Backend Django/FastAPI folders are scaffolds. They are not connected by this change.

## Flutter beneficiary mobile

The Home dashboard and Digital ID Pass now share one screenshot-matched emerald/gold identity card. The name and identity values are fictional. Its footer explicitly states the card cannot be used for verification.

```bash
cd frontend/mobile_app
flutter pub get
flutter run -d <your-ios-simulator-uuid>
```

From an existing clone, `git pull origin main` after the integration PR merges. If `git pull` flags modifications from your generated iOS/Android folders, back them up instead of discarding them.
