# finance_service

Apps: donations payments subsidy_rules ledger
Port: 8005

## Setup
```bash
cd backend/finance_service
python -m venv venv && source venv/bin/activate   # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env
python manage.py migrate
python manage.py runserver 8005
```

The placeholder files (config/, apps/*/models.py ...) are empty starters.
The service owner fills them in; add `manage.py` with `django-admin startproject config .`
(keep the existing config/settings/ split) and register each app in INSTALLED_APPS as `apps.<name>`.
