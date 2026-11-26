from django.shortcuts import render, redirect
from django.contrib import messages

CREDENTIAL_DIRECTORY = {
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
        account = CREDENTIAL_DIRECTORY.get(email)
        if account and account["password"] == password:
            request.session["cg_user"] = {
                "email": email,
                "name": account["name"],
                "role": account["role"],
            }
            return redirect(account["redirect_url"])
        messages.error(request, "Invalid email or password. Please verify your credentials.")
    return render(request, "auth/web_login.html")

def web_logout_view(request):
    request.session.pop("cg_user", None)
    return redirect("web_login")
