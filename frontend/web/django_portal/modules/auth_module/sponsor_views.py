from decimal import Decimal, InvalidOperation
from uuid import uuid4
from django.contrib import messages
from django.shortcuts import render, redirect
from django.views.decorators.http import require_POST
from .models import DemoNgoMembership
from .demo_memberships import seed_demo_memberships

def dashboard(request):
    seed_demo_memberships()
    return render(request, "sponsor/dashboard.html", {
        "ngos": [item for item in DemoNgoMembership.objects.order_by("name") if item.active],
        "receipts": request.session.get("cg_demo_receipts", []),
    })

@require_POST
def donate(request):
    try:
        ngo = DemoNgoMembership.objects.get(pk=request.POST.get("ngo"))
        amount = Decimal(request.POST.get("amount", ""))
        cause = request.POST.get("cause", "")
        if not ngo.active or not amount.is_finite() or amount < 1 or amount > 1000000 or amount.as_tuple().exponent < -2 or cause not in {"Food support", "Healthcare", "Education"}:
            raise ValueError
    except (DemoNgoMembership.DoesNotExist, InvalidOperation, ValueError, TypeError):
        messages.error(request, "Choose an active NGO, cause and valid demo amount.")
        return redirect("sponsor_dashboard")
    receipts = request.session.get("cg_demo_receipts", [])
    receipts.insert(0, {"reference": "CG-DEMO-" + uuid4().hex[:8].upper(), "ngo": ngo.name, "amount": str(amount), "cause": cause})
    request.session["cg_demo_receipts"] = receipts[:100]
    messages.success(request, "Demo donation recorded. No money was transferred.")
    return redirect("sponsor_dashboard")
