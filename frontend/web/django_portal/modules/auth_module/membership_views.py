from django.contrib import messages
from django.contrib.auth.hashers import make_password
from django.core.exceptions import ValidationError
from django.core.validators import validate_email
from django.db import IntegrityError, transaction
from django.shortcuts import render, redirect, get_object_or_404
from django.utils import timezone
from django.views.decorators.http import require_POST
from .models import DemoNgoMembership
from .demo_memberships import add_months, seed_demo_memberships

def dashboard(request):
    seed_demo_memberships()
    return render(request, "membership/dashboard.html", {"memberships": DemoNgoMembership.objects.order_by("name")})

@require_POST
def register(request):
    from .views import CREDENTIAL_DIRECTORY
    seed_demo_memberships()
    name = request.POST.get("name", "").strip()
    email = request.POST.get("email", "").strip().lower()
    password = request.POST.get("password", "")
    try:
        validate_email(email)
        if not name or len(name) > 160 or len(email) > 254 or len(password) < 8 or len(password) > 128 or email in CREDENTIAL_DIRECTORY:
            raise ValidationError("Invalid or reserved demo credentials.")
        DemoNgoMembership.objects.create(name=name, email=email, password_hash=make_password(password),
            plan="Trial", expires_on=add_months(timezone.localdate(), 1))
    except (ValidationError, IntegrityError):
        messages.error(request, "Enter a unique demo email, NGO name and password of 8–128 characters.")
    else:
        messages.success(request, "NGO registered. Its one-month trial and assigned login are active.")
    return redirect("membership_dashboard")

@require_POST
@transaction.atomic
def renew(request, pk):
    item = get_object_or_404(DemoNgoMembership.objects.select_for_update(), pk=pk)
    item.expires_on = add_months(max(timezone.localdate(), item.expires_on), 12)
    item.plan = "Annual"
    item.save(update_fields=["expires_on", "plan"])
    messages.success(request, "Annual demo license activated or renewed for " + item.name + ".")
    return redirect("membership_dashboard")
