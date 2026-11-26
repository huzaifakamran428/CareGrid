from django.shortcuts import render, redirect
from modules.auth_module.models import DemoNgoMembership

def ngo_dashboard(request):
    user = request.session.get("cg_user", {})
    membership = DemoNgoMembership.objects.filter(email=user.get("email"),).first()
    if not membership or not membership.active:
        request.session.pop("cg_user", None)
        return redirect("web_login")
    return render(request, "ngo/ngo_dashboard.html", {"membership": membership})
