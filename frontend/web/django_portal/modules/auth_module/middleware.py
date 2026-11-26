from django.shortcuts import redirect
from django.http import HttpResponseForbidden
from .models import DemoNgoMembership

# The Django demo is local-only. Restrict every role-specific URL, not just navigation.
ROLE_PREFIXES = {
    "admin-portal": "admin",
    "membership": "membership",
    "ngo": "ngo",
    "pharmacy": "pharmacy",
    "lab": "lab",
    "restaurant": "restaurant",
    "beneficiary": "beneficiary",
    "sponsor": "sponsor",
}

class DemoRoleMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        prefix = request.path_info.strip("/").split("/")[0]
        role = ROLE_PREFIXES.get(prefix)
        user = request.session.get("cg_user")
        if role:
            if not user:
                return redirect("web_login")
            if user.get("role") != role:
                return HttpResponseForbidden("This workspace is not assigned to your demo account.")
        if user and user.get("role") == "ngo" and (role or prefix in {"features", "preview-files"}):
            membership = DemoNgoMembership.objects.filter(email=user.get("email")).first()
            if not membership or not membership.active:
                request.session.pop("cg_user", None)
                return redirect("web_login")
        return self.get_response(request)
