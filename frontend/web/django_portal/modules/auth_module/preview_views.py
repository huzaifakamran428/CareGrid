from pathlib import Path
from django.http import FileResponse, Http404, HttpResponseForbidden
from django.shortcuts import redirect, render
from django.views.decorators.clickjacking import xframe_options_sameorigin

WEB_ROOT = Path(__file__).resolve().parents[3]
PREVIEWS = {
    "admin": [
        ("System administration", "admin_portal/index.html"),
        ("Complaints and service feedback", "admin_portal/complaint_resolution_service_feedback_figma.html"),
        ("Payment audit", "admin_portal/payment_audit_ngo_donations_figma.html"),
        ("Assistant controls (offline preview)", "admin_portal/assistant_control.html"),
    ],
    "ngo": [
        ("NGO operations", "ngo_portal/index.html"),
        ("Food collection requests", "ngo_portal/food_collection_request_alerts_figma.html"),
        ("Notifications", "ngo_portal/caregrid_notifications_console.html"),
        ("NGO funds", "ngo_portal/Sponse_web.html"),
    ],
    "lab": [
        ("Lab dashboard", "labs/templates/dashboard.html"),
        ("Appointments", "labs/templates/appointments.html"),
        ("Lab requests", "labs/templates/lab_requests.html"),
        ("Request details", "labs/templates/request_details.html"),
        ("Test catalogue", "labs/templates/lab_test_catalog.html"),
        ("Report upload", "labs/templates/lab_report_upload.html"),
        ("Chatbot", "chatbot/templates/chatbot.html"),
        ("Chat history", "chatbot/templates/chat_history.html"),
    ],
    "pharmacy": [("Pharmacy operations", "pharmacy_portal/index.html")],
}
ASSET_PREFIXES = {
    "admin": ("admin_portal/assets/",),
    "ngo": ("ngo_portal/assets/",),
    "lab": ("labs/assets/", "labs/templates/assets/"),
    "pharmacy": ("pharmacy_portal/assets/",),
}
COMMON_ASSETS = ("shared/", "admin_portal/assets/caregrid-logo.jpg")
ASSET_EXTENSIONS = {".css", ".js", ".jpg", ".jpeg", ".png", ".svg", ".ico", ".webp", ".woff", ".woff2"}

def library(request):
    user = request.session.get("cg_user")
    if not user:
        return redirect("web_login")
    return render(request, "auth/preview_library.html", {"previews": PREVIEWS.get(user["role"], [])})

def show(request, file_path):
    user = request.session.get("cg_user")
    if not user:
        return redirect("web_login")
    pages = dict((path, label) for label, path in PREVIEWS.get(user["role"], []))
    if file_path not in pages:
        return HttpResponseForbidden("This feature is not assigned to your demo role.")
    return render(request, "auth/preview.html", {"title": pages[file_path], "file_path": file_path})

@xframe_options_sameorigin
def file(request, file_path):
    user = request.session.get("cg_user")
    if not user:
        return redirect("web_login")
    if file_path == "labs/templates/lab_dashboard.html":
        file_path = "labs/templates/dashboard.html"
    role = user["role"]
    pages = {path for _, path in PREVIEWS.get(role, [])}
    allowed_assets = COMMON_ASSETS + ASSET_PREFIXES.get(role, ())
    path = (WEB_ROOT / file_path).resolve()
    if not path.is_relative_to(WEB_ROOT) or not path.is_file():
        raise Http404
    normalized = path.relative_to(WEB_ROOT).as_posix()
    if normalized != file_path:
        raise Http404
    if file_path not in pages and not (path.suffix.lower() in ASSET_EXTENSIONS and any(file_path.startswith(prefix) for prefix in allowed_assets)):
        return HttpResponseForbidden("This preview is not assigned to your demo role.")
    return FileResponse(path.open("rb"))
