# CareGrid UI contribution — NGO, Admin, Complaints & Beneficiary

**Contributor workstream:** frontend user interfaces only. The Django/FastAPI backend, database, and other teammates' modules are intentionally untouched.

## Scope
- NGO web portal: dashboard, beneficiary records, walk-in registration with CNIC and three-month bill upload, local demonstration digital ID issuance and management (view, block/unblock, delete/reissue), provider and sponsor sample screens.
- Admin web portal: dashboard, registration requests, beneficiary/NGO/pharmacy/restaurant/lab records, monitoring, reports and complaint handling.
- Flutter beneficiary UI: Digital ID display, complaint submission, complaint list/history and complaint status/details.
- CareGrid logo and local run instructions.

## Local preview (frontend-only)
Run these commands from the repository root in separate terminals:

```bash
python3 -m http.server 8001 --directory frontend/web/ngo_portal
python3 -m http.server 8002 --directory frontend/web/admin_portal
```

For Flutter, from `frontend/mobile_app`:

```bash
flutter create --project-name caregrid_mobile --platforms=ios,android,web .
flutter pub get
flutter run -d chrome
```

## Integration/privacy notes
These are static UI previews only: no real authentication, API connections, secure document storage, or backend role authorization. **Separate web preview directories do not replace server-side RBAC.** Do not upload or test with real CNICs, bills, salary slips or medical information. Real beneficiary IDs must be issued and verified by a secured backend before production use.

## Contribution branch
`feature/ngo-admin-beneficiary-ui` — created from `main` so other teammates' work is not overwritten. The NGO and Admin web sources and Flutter beneficiary UI have been merged into `main`. The redundant beneficiary browser-only preview was subsequently removed.
