# CareGrid unified local demonstration

One login per platform. The Flutter app supports Beneficiary, Restaurant and Sponsor only. The Django web demo supports System Admin, Membership Admin, NGO, Pharmacy and Laboratory only. Sign out and sign in as another supported role without restarting. The following are fictional local-demo accounts only; never use them in production.

| Role | Email | Password | Platform |
|---|---|---|---|
| Operations administrator | admin@caregrid.org | Admin@123 | Web only |
| Membership administrator | membership@caregrid.example | Member@123 | Web only |
| NGO | kamran@alkhidmat-lhr.org | Ngo@123 | Web only |
| Beneficiary | ayesha.bibi@caregrid.pk | Ben@123 | Mobile only |
| Pharmacy | pharmacy@medpluscare.org | Pharm@123 | Web only |
| Lab | lab@chughtai-care.org | Lab@123 | Web only |
| Restaurant | ops@lahorekitchen.pk | Food@123 | Mobile only |
| Sponsor | sponsor@caregrid.example | Sponsor@123 | Mobile only |
| Expired NGO (renewal test) | expired@caregrid.example | Ngo@123 | Web only |

## Web
From the repository root:

```bash
cd frontend/web/django_portal
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
python manage.py migrate
python manage.py runserver 127.0.0.1:8000
```

Open http://127.0.0.1:8000/ in your browser. Stop other servers using port 8000 first. The web login page has a picker for the five web roles only: System Admin, Membership Admin, NGO, Pharmacy and Laboratory. Beneficiaries, restaurants and sponsors must use the mobile application. Their former web URLs are disabled; existing legacy files are not deleted. The persistent role sidebar opens existing feature modules inside the dashboard without starting another server. Existing complex previews remain same-origin embedded panels, not rewritten services. The current section is highlighted and shown in the header. Unused mobile-only web prototypes are retained in source but their web entry routes are disabled.

## Mobile

```bash
cd frontend/mobile_app
# If ios/Runner.xcodeproj is missing:
flutter create --platforms=ios .
flutter pub get
flutter devices
flutter run -d 206D287C-9F48-49AB-830D-C1E894C2AB9C
```

Use your actual simulator ID if different. Run from a local development folder outside an iCloud-synced Desktop/Documents if codesign encounters Finder metadata. Use the three-account mobile demo picker. Staff and NGO accounts are not part of the mobile authentication directory. Beneficiary can sign out from Profile; other roles use their app bar. Restaurant opens four food-listing screens; Sponsor opens the integrated donation flow and history.

## Membership demonstration
1. Sign in as Membership Administrator, register a fictional NGO with a unique email and password of at least eight characters. Its trial lasts one calendar month.
2. Sign out and sign in as the new NGO. Operations Admin can inspect NGO records, but cannot issue NGO licenses.
3. Try the expired NGO demo login. It is denied until renewed.
4. Return to Membership Administrator, activate or renew an annual license. Early renewal preserves unused time and extends expiry by 12 calendar months; expired accounts start the new term from renewal.
5. Sign in as the renewed NGO. Access is restored.
6. Sign in as Sponsor in the mobile app to simulate a donation. No money is transferred.

## Frontend-only additions
- Membership Admin can suspend, block and reactivate a license in this browser. This hides the NGO workspace in this browser, but does not change server authorization or subscription dates.
- Mobile beneficiary > Prescription upload: select a fictional PDF/JPG/PNG (up to 5 MB). For the web pharmacy demo, transfer the fictional file to the computer and choose Import mobile demo prescription in the pharmacy inbox. This is a manual handoff, not synchronization. The inbox supports download, simulated OCR review, manual medicine transcription, example subsidy calculation, and a mock dispense status. Web file bytes use IndexedDB; metadata uses localStorage. No real OCR, clinical validation or dispensing.
- All five web roles have a browser-only FAQ assistant. Existing standalone prototype state is not automatically synchronized.
- Mobile beneficiary prescription selection and export are local demo actions. Use Choose File and Export prescription for manual transfer to the web pharmacy. Records reset on restart; no automatic synchronization. NGO licensing and membership controls are web-only.
- The existing web registration and annual renewal demo actions remain unchanged. Never use genuine documents or health information.

## Validation and limits
Run `python manage.py check` and `python manage.py test modules.auth_module` inside the Django virtual environment. Run `flutter analyze --no-fatal-infos --no-fatal-warnings` and `flutter test` in the mobile app.

This is an FYP UI prototype, not a production service. Web membership records persist in local SQLite; mobile records are in-memory and reset on app restart. Web and mobile are not synchronized. Existing team feature previews retain independent fictional data and mock interactions, and their assistant preview does not use the separate shared SQLite assistant runner. No real payments, clinical record handling, identity verification, production authorization or license billing. Use fictional data only. The web gateway role guards do not protect separately launched static demo servers. Not every screen has been individually visually reviewed.
