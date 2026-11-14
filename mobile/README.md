# CareGrid Mobile (Flutter)

Roles: Beneficiary, Restaurant, Donor/Sponsor (+ volunteers for donations).

## First-time setup (team lead, once)
```bash
cd mobile
flutter create . --org com.caregrid --project-name caregrid
```
This generates `android/`, `ios/`, `pubspec.yaml` and `lib/main.dart` and keeps the
`lib/` folders from this repo. Commit the result, then everyone else just runs:
```bash
flutter pub get
flutter run
```

## Rules
- Work only inside your own `lib/features/<feature>/` folder.
- `lib/core/` changes go through a PR to the team lead.
- Pick ONE state management (Riverpod or Bloc) and use it everywhere.
- Never commit `google-services.json`.
