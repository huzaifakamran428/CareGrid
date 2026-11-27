# CareGrid unified local demonstration

One login per platform. Sign out and sign in as another role without restarting. The following are fictional local-demo accounts only; never use them in production.

| Role | Email | Password |
|---|---|---|
| Operations administrator | admin@caregrid.org | Admin@123 |
| Membership administrator | membership@caregrid.example | Member@123 |
| NGO | kamran@alkhidmat-lhr.org | Ngo@123 |
| Beneficiary | ayesha.bibi@caregrid.pk | Ben@123 |
| Pharmacy | pharmacy@medpluscare.org | Pharm@123 |
| Lab | lab@chughtai-care.org | Lab@123 |
| Restaurant | ops@lahorekitchen.pk | Food@123 |
| Sponsor | sponsor@caregrid.example | Sponsor@123 |
| Expired NGO (renewal test) | expired@caregrid.example | Ngo@123 |

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

Open http://127.0.0.1:8000/ in your browser. Stop other servers using port 8000 first. The login page has a demo-account picker. The persistent role sidebar opens existing feature modules inside the dashboard without starting another server. Existing complex previews remain same-origin embedded panels, not rewritten services. The current section is highlighted and shown in the header. Existing legacy files are retained, not deleted.

## Mobile

```bash
cd frontend/mobile_app
# If ios/Runner.xcodeproj is missing:
flutter create --platforms=ios .
flutter pub get
flutter devices
flutter run -d 206D287C-9F48-49AB-830D-C1E894C2AB9C
```

Use your actual simulator ID if different. Run from a local development folder outside an iCloud-synced Desktop/Documents if codesign encounters Finder metadata. Use the demo-account picker. Beneficiary can sign out from Profile; other roles use their app bar. Restaurant opens four food-listing screens; Sponsor opens the integrated donation flow and history.

## Membership demonstration
1. Sign in as Membership Administrator, register a fictional NGO with a unique email and password of at least eight characters. Its trial lasts one calendar month.
2. Sign out and sign in as the new NGO. Operations Admin can inspect NGO records, but cannot issue NGO licenses.
3. Try the expired NGO demo login. It is denied until renewed.
4. Return to Membership Administrator, activate or renew an annual license. Early renewal preserves unused time and extends expiry by 12 calendar months; expired accounts start the new term from renewal.
5. Sign in as the renewed NGO. Access is restored.
6. Sign in as Sponsor to simulate a donation. No money is transferred.

## Frontend-only additions
- Membership Admin can suspend, block and reactivate a license in this browser. This hides the NGO workspace in this browser, but does not change server authorization or subscription dates.
- Beneficiary > Prescription upload: select a fictional PDF/JPG/PNG (up to 5 MB). Sign out, then sign in as the assigned pharmacy in the same browser. Prescription inbox supports original-file download, simulated OCR review, manual medicine transcription, example subsidy calculation, and a mock dispense status. File bytes use IndexedDB; metadata uses localStorage. No real OCR, clinical validation, or dispensing.
- All eight web roles have a browser-only FAQ assistant. Existing standalone prototype state is not automatically synchronized.
- The existing web registration and annual renewal demo actions remain unchanged. Never use genuine documents or health information.

## Validation and limits
Run `python manage.py check` and `python manage.py test modules.auth_module` inside the Django virtual environment. Run `flutter analyze --no-fatal-infos --no-fatal-warnings` and `flutter test` in the mobile app.

This is an FYP UI prototype, not a production service. Web membership records persist in local SQLite; mobile records are in-memory and reset on app restart. Web and mobile are not synchronized. Existing team feature previews retain independent fictional data and mock interactions, and their assistant preview does not use the separate shared SQLite assistant runner. No real payments, clinical record handling, identity verification, production authorization or license billing. Use fictional data only. The web gateway role guards do not protect separately launched static demo servers. Not every screen has been individually visually reviewed.
