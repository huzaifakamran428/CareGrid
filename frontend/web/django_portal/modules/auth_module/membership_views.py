from django.contrib import messages
from django.contrib.auth.hashers import make_password
from django.core.exceptions import ValidationError
from django.core.validators import validate_email
from django.db import IntegrityError, transaction
from django.shortcuts import render, redirect, get_object_or_404
from django.utils import timezone
from django.views.decorators.http import require_POST
from .models import DemoNgoMembership, DemoNgoDocument
from django.http import HttpResponse
from django.utils.http import content_disposition_header
from pathlib import PurePath
from .demo_memberships import add_months, seed_demo_memberships

def dashboard(request):
    seed_demo_memberships()
    return render(request, "membership/dashboard.html", {"memberships": DemoNgoMembership.objects.prefetch_related("documents").order_by("name")})

@require_POST
@transaction.atomic
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
        documents = []
        for field, category in (("registration_certificate", "Registration certificate"), ("representative_id", "Representative ID"), ("supporting_document", "Supporting document")):
            upload = request.FILES.get(field)
            if upload is None:
                continue
            if not 0 < upload.size <= 5 * 1024 * 1024:
                raise ValidationError("Each file must be between 1 byte and 5 MB.")
            data = upload.read()
            suffix = PurePath(upload.name).suffix.lower()
            valid = (suffix == ".pdf" and data.startswith(b"%PDF-")) or (suffix == ".png" and data.startswith(b"\x89PNG\r\n\x1a\n")) or (suffix in (".jpg", ".jpeg") and data.startswith(b"\xff\xd8\xff"))
            if not valid:
                raise ValidationError("Only PDF, PNG and JPEG demo documents are accepted.")
            documents.append((category, PurePath(upload.name).name[:255], data))
        with transaction.atomic():
            membership = DemoNgoMembership.objects.create(name=name, email=email, password_hash=make_password(password),
                plan="Trial", expires_on=add_months(timezone.localdate(), 1))
            DemoNgoDocument.objects.bulk_create([DemoNgoDocument(membership=membership, category=category, filename=filename, content=data) for category, filename, data in documents])
    except ValidationError as error:
        messages.error(request, " ".join(error.messages))
    except IntegrityError:
        messages.error(request, "Enter a unique demo email.")
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

def download_document(request, pk):
    document = get_object_or_404(DemoNgoDocument, pk=pk)
    response = HttpResponse(bytes(document.content), content_type="application/octet-stream")
    response["Content-Disposition"] = content_disposition_header(True, document.filename)
    response["X-Content-Type-Options"] = "nosniff"
    response["Cache-Control"] = "no-store"
    return response
