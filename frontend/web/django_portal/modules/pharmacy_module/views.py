from django.shortcuts import render, redirect
from django.contrib import messages

BENEFICIARIES_DB = {
    "CG-BEN-2026-009481": {
        "digital_id": "CG-BEN-2026-009481",
        "name": "Ayesha Bibi",
        "cnic": "35202-8492014-6",
        "ngo": "Al-Khidmat Foundation",
        "status": "APPROVED",
        "subsidy_pct": 80,
        "remaining_limit": "4,200 / 5,000",
    },
    "CG-DID-7840-1928": {
        "digital_id": "CG-DID-7840-1928",
        "name": "Fatima Bibi",
        "cnic": "35201-9847123-2",
        "ngo": "Al-Khidmat Foundation",
        "status": "APPROVED",
        "subsidy_pct": 80,
        "remaining_limit": "5,000 / 5,000",
    },
}

def pharmacy_portal_view(request):
    digital_id = request.GET.get("digital_id", "CG-BEN-2026-009481").strip()
    beneficiary = BENEFICIARIES_DB.get(digital_id)
    if not beneficiary:
        messages.warning(request, f"No verified beneficiary found for ID '{digital_id}'. Showing sample verified record.")
        beneficiary = BENEFICIARIES_DB["CG-BEN-2026-009481"]
    return render(request, "pharmacy/pharmacy_portal.html", {"beneficiary": beneficiary})

def pharmacy_submit_bill(request):
    if request.method == "POST":
        total = request.POST.get("total_amount", "1000")
        digital_id = request.POST.get("beneficiary_digital_id", "CG-BEN-2026-009481")
        messages.success(request, f"Subsidized Bill (PKR {total}) verified & uploaded for {digital_id}!")
    return redirect("pharmacy_portal")
