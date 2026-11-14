# CareGrid

Integrated welfare platform linking restaurants, NGOs, pharmacies, labs, donors and beneficiaries for food redistribution and subsidised healthcare.

## Repository structure

| Folder | What | Tech |
|---|---|---|
| `frontend/mobile_app/` | Beneficiary, Restaurant and Sponsor/Donor app | Flutter |
| `frontend/web/shared/` | Shared web UI (base layout, components, Bootstrap, theme) extended by every Django service | HTML, CSS, Bootstrap |
| `backend/services/` | 11 Django microservices (MVT), one database each, own models, views and templates per module | Djang, PostgreSQL |
| `backend/ai_services/` | Food demand prediction, prescription OCR, RAG chatbot | FastAPI, pgvector, LangChain, Gemini |
| `backend/gateway/` | Single entry point for web and mobile | Nginx |
| `backend/shared/` | `caregrid_common` library (JWT, roles, audit log, service clients) | Python |
| `backend/database/` | DB init scripts, seed data, backups, ERD | PostgreSQL |
| `docs/` | SRS chapters, sprints, architecture, API specs, user manuals | - |
| `tests/` | Integration, e2e, performance, security, UAT | - |
| `infrastructure/` | Deployment, CI/CD, environment files | Docker |
| `design/`, `scripts/` | Figma exports and branding, setup and run scripts | - |

## Services and ports

| Service | Port | Service | Port |
|---|---|---|---|
| auth_service | 8001 | finance_service | 8007 |
| beneficiary_service | 8002 | subscription_service | 8008 |
| organization_service | 8003 | notification_service | 8009 |
| food_service | 8004 | feedback_service | 8010 |
| pharmacy_service | 8005 | admin_service | 8011 |
| lab_service | 8006 | | |
| food_demand_service | 9001 | ocr_service | 9002 |
| chatbot_service | 9003 | | |

## Team workflow

- `main` = stable (updated at the end of each sprint), `develop` = integration.
- Each member has a personal branch; `feature/<BACKLOG-ID>-<name>` is used for separate features.
- Work only in the folders you own (see `.github/CODEOWNERS`).
- Open a Pull Request into `develop`; a teammate reviews it before merge.
- Commit style: `feat(auth): BR-01 signup form`

Daily routine:

    git checkout <your-branch>
    git fetch origin
    git merge origin/develop
    # work, then:
    git add <your folders>
    git commit -m "feat(auth): BR-01 signup"
    git push origin <your-branch>

New feature branch:

    git checkout develop && git pull origin develop
    git checkout -b feature/BR-01-signup

Never commit `.env` files, API keys or real user data. Commit only `.env.example`.
