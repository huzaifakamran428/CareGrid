# CareGrid
CareGrid is a welfare coordination FYP frontend demonstration, with role-specific workspaces for NGO administration, subsidized services, surplus food and donations.

## Platform responsibilities

| Web (Django) | Mobile (Flutter) |
|---|---|
| System Admin | Beneficiary |
| Membership Admin | Restaurant |
| NGO | Sponsor |
| Pharmacy | |
| Laboratory | |

The Flutter application retains beneficiary lab bookings and prescription upload/export; these are beneficiary features, not staff portals. Licensing administration is web-only.

## Local demonstration
Follow [DEMO_RUN.md](DEMO_RUN.md) for setup, fictional credentials, simulator commands, and the manual prescription handoff.

## Current scope
The frontend uses demo accounts and fictional data. The web and mobile datasets are independent. OCR, dispensing and payment flows are demonstrations, not production services. Do not use actual personal or medical documents. Backend directories are outside this frontend validation scope.

## Validation
- Flutter: `flutter analyze --no-fatal-infos --no-fatal-warnings` and `flutter test` from `frontend/mobile_app`.
- Web: `python manage.py check` and `python manage.py test modules.auth_module` from `frontend/web/django_portal` with its virtual environment active.
- GitHub Actions: see [workflow runs](https://github.com/huzaifakamran428/CareGrid/actions).
