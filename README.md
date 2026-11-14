# CareGrid

Integrated welfare platform linking restaurants, NGOs, pharmacies, labs, donors and beneficiaries
for food redistribution and subsidised healthcare.

| Folder | What | Tech |
|---|---|---|
| `backend/` | Web portal (Admin, NGO, Pharmacy, Lab) + REST APIs, one Django service per module | Django (MVT), DRF, PostgreSQL |
| `ai-services/` | Food demand prediction, prescription OCR, RAG chatbot | FastAPI, pgvector, LangChain, Gemini |
| `mobile/` | Beneficiary, Restaurant, Donor app | Flutter |
| `docs/` | SRS, SDD, API contracts, test plans, user manual | - |

## Team workflow
- `main` = stable, `develop` = integration, `feature/<BACKLOG-ID>-<name>` = your work.
- Work only in the folders you own (see `.github/CODEOWNERS`).
- Open a Pull Request into `develop`; the code owner reviews.
- Commit style: `feat(auth): BR-01 signup form`

```bash
git checkout develop && git pull origin develop
git checkout -b feature/BR-01-signup
# work, then:
git add . && git commit -m "feat(auth): BR-01 signup"
git push origin feature/BR-01-signup
```

## Ports
auth 8001 · ngo 8002 · food 8003 · medical 8004 · finance 8005 · notification 8006 · admin_portal 8007 · food_demand 9001 · ocr 9002 · chatbot 9003
