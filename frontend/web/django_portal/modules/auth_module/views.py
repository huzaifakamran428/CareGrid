from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.hashers import check_password
from .demo_memberships import seed_demo_memberships
from .models import DemoNgoMembership

CREDENTIAL_DIRECTORY = {
    "membership@caregrid.example": {
        "password": "Member@123", "role": "membership",
        "name": "Membership Administrator", "redirect_url": "membership_dashboard",
    },
    "sponsor@caregrid.example": {
        "password": "Sponsor@123", "role": "sponsor",
        "name": "Demo Sponsor", "redirect_url": "sponsor_dashboard",
    },
    "admin@caregrid.org": {
        "password": "Admin@123",
        "role": "admin",
        "name": "Root System Administrator",
        "redirect_url": "user_management",
    },
    "kamran@alkhidmat-lhr.org": {
        "password": "Ngo@123",
        "role": "ngo",
        "name": "Dr. Kamran Siddiqui (Al-Khidmat NGO)",
        "redirect_url": "ngo_dashboard",
    },
    "pharmacy@medpluscare.org": {
        "password": "Pharm@123",
        "role": "pharmacy",
        "name": "MedPlus Care Pharmacy (#PHM-409)",
        "redirect_url": "pharmacy_portal",
    },
    "lab@chughtai-care.org": {
        "password": "Lab@123",
        "role": "lab",
        "name": "Chughtai Diagnostic Lab (#LAB-204)",
        "redirect_url": "lab_portal",
    },
    "ops@lahorekitchen.pk": {
        "password": "Food@123",
        "role": "restaurant",
        "name": "Lahore Kitchen Relief (#RST-312)",
        "redirect_url": "restaurant_portal",
    },
    "ayesha.bibi@caregrid.pk": {
        "password": "Ben@123",
        "role": "beneficiary",
        "name": "Ayesha Bibi (CG-BEN-2026-009481)",
        "redirect_url": "beneficiary_portal",
    },
}

def home_redirect(request):
    return redirect("web_login")

def web_login_view(request):
    if request.method == "POST":
        email = request.POST.get("username", "").strip().lower()
        password = request.POST.get("password", "").strip()
        seed_demo_memberships()
        membership = DemoNgoMembership.objects.filter(email=email).first()
        if membership:
            account = {"password": password, "name": membership.name, "role": "ngo", "redirect_url": "ngo_dashboard"} if membership.active and check_password(password, membership.password_hash) else None
        else:
            account = CREDENTIAL_DIRECTORY.get(email)
            if account and account['role'] == 'ngo':
                account = None
        if account and account["password"] == password:
            request.session.cycle_key()
            request.session["cg_user"] = {
                "email": email,
                "name": account["name"],
                "role": account["role"],
            }
            return redirect(account["redirect_url"])
        messages.error(request, "Invalid credentials or expired NGO membership.")
    if request.method == "GET" and request.session.get("cg_user"):
        role = request.session["cg_user"].get("role")
        targets = {"admin": "user_management", "membership": "membership_dashboard", "ngo": "ngo_dashboard", "pharmacy": "pharmacy_portal", "lab": "lab_portal", "restaurant": "restaurant_portal", "beneficiary": "beneficiary_portal", "sponsor": "sponsor_dashboard"}
        if role in targets:
            return redirect(targets[role])
    return render(request, "auth/web_login.html", {"demo_accounts": CREDENTIAL_DIRECTORY.items()})

def web_logout_view(request):
    request.session.pop("cg_user", None)
    return redirect("web_login")
