from calendar import monthrange
from datetime import date, timedelta
from django.contrib.auth.hashers import make_password
from django.utils import timezone
from .models import DemoNgoMembership

def add_months(day, months):
    year, month0 = divmod(day.year * 12 + day.month - 1 + months, 12)
    month = month0 + 1
    return date(year, month, min(day.day, monthrange(year, month)[1]))

def seed_demo_memberships():
    today = timezone.localdate()
    DemoNgoMembership.objects.get_or_create(
        email="kamran@alkhidmat-lhr.org",
        defaults={"name": "Al-Khidmat Care (demo)", "password_hash": make_password("Ngo@123"),
                  "plan": "Trial", "expires_on": add_months(today, 1)},
    )
    DemoNgoMembership.objects.get_or_create(
        email="expired@caregrid.example",
        defaults={"name": "Expired NGO (demo)", "password_hash": make_password("Ngo@123"),
                  "plan": "Annual", "expires_on": today - timedelta(days=1)},
    )
