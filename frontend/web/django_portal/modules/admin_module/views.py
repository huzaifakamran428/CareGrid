from datetime import datetime
from django.shortcuts import render, redirect
from django.contrib import messages

DEFAULT_USERS = [
    {"id": 1, "name": "Dr. Kamran Siddiqui", "email": "kamran@alkhidmat-lhr.org", "code": "#USR-104", "role": "NGO Admin", "status": "ACTIVE"},
    {"id": 2, "name": "MedPlus Care Pharmacy", "email": "pharmacy@medpluscare.org", "code": "#USR-409", "role": "Pharmacy", "status": "AUTHORIZED"},
    {"id": 3, "name": "Nadia Tariq (Volunteer)", "email": "nadia.tariq@email.com", "code": "#USR-218", "role": "Volunteer", "status": "SUSPENDED"},
    {"id": 4, "name": "Lahore Kitchen Relief", "email": "ops@lahorekitchen.pk", "code": "#USR-312", "role": "Restaurant", "status": "ACTIVE"},
    {"id": 5, "name": "Chughtai Diagnostic Lab", "email": "lab@chughtai-care.org", "code": "#USR-204", "role": "Lab", "status": "ACTIVE"},
]

DEFAULT_LOGS = [
    {"timestamp": "15 Nov 2026 12:30", "message": "Root Admin activated authorized account: MedPlus Care Pharmacy (ID #USR-409)"},
    {"timestamp": "14 Nov 2026 18:12", "message": "Root Admin suspended account: Nadia Tariq (Reason: Policy Verification Pending)"},
]

BENEFICIARY_REGISTRY = [
    {"digital_id": "CG-BID-2026-0842", "name": "Ayesha Bibi", "ngo": "Al-Khidmat Care", "status": "Verified", "region": "Lahore, Punjab", "food_rations": 6, "vouchers": "3 ($145 Aid)"},
    {"digital_id": "CG-BID-2026-0843", "name": "Tariq Mahmood", "ngo": "Hope & Health", "status": "Verified", "region": "Lahore, Punjab", "food_rations": 4, "vouchers": "2 ($90 Aid)"},
    {"digital_id": "CG-BID-2026-0849", "name": "Sanaullah Khan", "ngo": "Edhi Welfare", "status": "Verified", "region": "Rawalpindi, Punjab", "food_rations": 8, "vouchers": "4 ($210 Aid)"},
]

FOOD_BATCHES = [
    {"batch_id": "#FD-904", "donor": "Spice Bazaar (120 Meals)", "listed": "15 Nov, 10:15 AM", "ngo": "Al-Khidmat Care", "collection": "Collected ✓", "status": "DISTRIBUTED"},
    {"batch_id": "#FD-905", "donor": "Pearl Continental (85 Packs)", "listed": "Volunteer Rider: Bilal R. En Route", "ngo": "Hope & Health", "collection": "In Transit", "status": "PENDING DROP-OFF"},
    {"batch_id": "#FD-906", "donor": "Gourmet Bakers (60 Boxes)", "listed": "15 Nov, 12:10 PM", "ngo": "Edhi Welfare", "collection": "Scheduled", "status": "REQUEST APPROVED"},
    {"batch_id": "#FD-901", "donor": "Bundu Khan (150 Meals)", "listed": "Verified via Beneficiary Digital IDs", "ngo": "Green Valley", "collection": "Collected ✓", "status": "DISTRIBUTED"},
]

def _get_session_users(request):
    if "cg_users" not in request.session:
        request.session["cg_users"] = DEFAULT_USERS
    if "cg_logs" not in request.session:
        request.session["cg_logs"] = DEFAULT_LOGS
    return request.session["cg_users"], request.session["cg_logs"]

def admin_dashboard_view(request):
    users_list, audit_logs = _get_session_users(request)
    return render(request, "admin/user_management.html", {
        "active_tab": "dashboard",
        "users_list": users_list,
        "audit_logs": audit_logs,
        "beneficiaries": BENEFICIARY_REGISTRY,
        "food_batches": FOOD_BATCHES,
    })

def user_management_view(request):
    users_list, audit_logs = _get_session_users(request)
    return render(request, "admin/user_management.html", {
        "active_tab": "users",
        "users_list": users_list,
        "audit_logs": audit_logs,
        "beneficiaries": BENEFICIARY_REGISTRY,
        "food_batches": FOOD_BATCHES,
    })

def beneficiary_registry_view(request):
    users_list, audit_logs = _get_session_users(request)
    return render(request, "admin/user_management.html", {
        "active_tab": "beneficiaries",
        "users_list": users_list,
        "audit_logs": audit_logs,
        "beneficiaries": BENEFICIARY_REGISTRY,
        "food_batches": FOOD_BATCHES,
    })

def food_logs_view(request):
    users_list, audit_logs = _get_session_users(request)
    return render(request, "admin/user_management.html", {
        "active_tab": "food",
        "users_list": users_list,
        "audit_logs": audit_logs,
        "beneficiaries": BENEFICIARY_REGISTRY,
        "food_batches": FOOD_BATCHES,
    })

def toggle_user_status(request, user_id):
    if request.method == "POST":
        users_list, audit_logs = _get_session_users(request)
        action = request.POST.get("action")
        now_str = datetime.now().strftime("%d %b %Y %H:%M")
        for u in users_list:
            if u["id"] == user_id:
                if action == "suspend":
                    u["status"] = "SUSPENDED"
                    audit_logs.insert(0, {"timestamp": now_str, "message": f"Root Admin suspended account: {u['name']} ({u['code']})"})
                elif action in ("activate", "reactivate"):
                    u["status"] = "ACTIVE"
                    audit_logs.insert(0, {"timestamp": now_str, "message": f"Root Admin activated account: {u['name']} ({u['code']})"})
                break
        request.session["cg_users"] = users_list
        request.session["cg_logs"] = audit_logs
    return redirect("user_management")

def authorize_new_user(request):
    if request.method == "POST":
        users_list, audit_logs = _get_session_users(request)
        name = request.POST.get("name", "").strip()
        email = request.POST.get("email", "").strip()
        role = request.POST.get("role", "NGO Admin")
        if name and email:
            new_id = max([u["id"] for u in users_list], default=0) + 1
            code = f"#USR-{500 + new_id}"
            users_list.insert(0, {
                "id": new_id,
                "name": name,
                "email": email,
                "code": code,
                "role": role,
                "status": "AUTHORIZED",
            })
            now_str = datetime.now().strftime("%d %b %Y %H:%M")
            audit_logs.insert(0, {"timestamp": now_str, "message": f"Root Admin pre-authorized {role}: {name} ({code})"})
            request.session["cg_users"] = users_list
            request.session["cg_logs"] = audit_logs
            messages.success(request, f"{name} authorized successfully.")
    return redirect("user_management")
