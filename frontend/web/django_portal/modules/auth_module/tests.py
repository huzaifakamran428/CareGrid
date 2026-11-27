from datetime import date
from django.test import TestCase
from django.urls import reverse
from .demo_memberships import add_months
from .models import DemoNgoMembership, DemoNgoDocument
from django.core.files.uploadedfile import SimpleUploadedFile
from django.utils import timezone

class DemoFlowTests(TestCase):
    def login(self, email, password):
        return self.client.post(reverse("web_login"), {"username": email, "password": password})

    def test_calendar_months(self):
        self.assertEqual(add_months(date(2026, 1, 31), 1), date(2026, 2, 28))
        self.assertEqual(add_months(date(2024, 2, 29), 12), date(2025, 2, 28))

    def test_membership_registration_expiry_and_renewal(self):
        self.assertRedirects(self.login("membership@caregrid.example", "Member@123"), reverse("membership_dashboard"))
        self.assertEqual(self.client.get(reverse("user_management")).status_code, 403)
        self.client.post(reverse("membership_register"), {"name": "Test NGO", "email": "test@caregrid.example", "password": "Example123"})
        ngo = DemoNgoMembership.objects.get(email="test@caregrid.example")
        self.assertTrue(ngo.active)
        self.assertEqual(ngo.plan, "Trial")
        self.client.get(reverse("web_logout"))
        self.assertRedirects(self.login(ngo.email, "Example123"), reverse("ngo_dashboard"))
        self.assertEqual(self.client.get(reverse("membership_dashboard")).status_code, 403)
        self.assertEqual(self.client.get(reverse("preview_file", args=["admin_portal/index.html"])).status_code, 403)
        self.client.get(reverse("web_logout"))
        self.assertEqual(self.login("expired@caregrid.example", "Ngo@123").status_code, 200)
        self.login("membership@caregrid.example", "Member@123")
        expired = DemoNgoMembership.objects.get(email="expired@caregrid.example")
        self.client.post(reverse("membership_renew", args=[expired.pk]))
        expired.refresh_from_db()
        self.assertTrue(expired.active)
        self.assertEqual(expired.plan, "Annual")
        self.client.get(reverse("web_logout"))
        self.assertRedirects(self.login(expired.email, "Ngo@123"), reverse("ngo_dashboard"))

    def test_web_roles_and_mobile_only_accounts(self):
        for email, password, target in [
            ("admin@caregrid.org", "Admin@123", "user_management"),
            ("membership@caregrid.example", "Member@123", "membership_dashboard"),
            ("kamran@alkhidmat-lhr.org", "Ngo@123", "ngo_dashboard"),
            ("pharmacy@medpluscare.org", "Pharm@123", "pharmacy_portal"),
            ("lab@chughtai-care.org", "Lab@123", "lab_portal"),
        ]:
            self.assertRedirects(self.login(email, password), reverse(target))
            self.client.get(reverse("web_logout"))
        for email, password in [
            ("sponsor@caregrid.example", "Sponsor@123"),
            ("ops@lahorekitchen.pk", "Food@123"),
            ("ayesha.bibi@caregrid.pk", "Ben@123"),
        ]:
            result = self.login(email, password)
            self.assertContains(result, "mobile-only")
            self.assertNotIn("cg_user", self.client.session)
            self.assertNotContains(self.client.get(reverse("web_login")), email)
        for url in ["/sponsor/", "/sponsor/donate/", "/restaurant/", "/beneficiary/"]:
            self.assertEqual(self.client.get(url).status_code, 404)
        session = self.client.session
        session["cg_user"] = {"role": "beneficiary", "email": "ayesha.bibi@caregrid.pk"}
        session.save()
        self.client.get(reverse("web_login"))
        self.assertNotIn("cg_user", self.client.session)
        self.login("admin@caregrid.org", "Admin@123")
        self.assertEqual(self.client.get(reverse("membership_dashboard")).status_code, 403)

    def test_ngo_license_and_document_visibility(self):
        self.login("membership@caregrid.example", "Member@123")
        self.client.post(reverse("membership_register"), {
            "name": "Document NGO", "email": "docs@caregrid.example", "password": "Example123",
            "registration_certificate": SimpleUploadedFile("sample.pdf", b"%PDF-1.4\nfictional demo"),
        })
        ngo = DemoNgoMembership.objects.get(email="docs@caregrid.example")
        document = ngo.documents.get()
        self.assertEqual(ngo.days_left, (ngo.expires_on - timezone.localdate()).days)
        self.assertEqual(self.client.get(reverse("membership_document", args=[document.pk])).content, b"%PDF-1.4\nfictional demo")
        self.client.get(reverse("web_logout"))
        self.login(ngo.email, "Example123")
        page = self.client.get(reverse("ngo_dashboard"))
        self.assertContains(page, "One-month free trial")
        self.assertContains(page, "Days remaining")
        self.assertContains(page, "Document NGO")
        self.assertEqual(self.client.get(reverse("membership_document", args=[document.pk])).status_code, 403)
        self.client.get(reverse("web_logout"))
        self.login("admin@caregrid.org", "Admin@123")
        self.assertEqual(self.client.get(reverse("membership_document", args=[document.pk])).status_code, 403)
        self.assertNotContains(self.client.get(reverse("user_management")), "Days remaining")
        self.client.get(reverse("web_logout"))
        self.login("membership@caregrid.example", "Member@123")
        self.client.post(reverse("membership_renew", args=[ngo.pk]))
        self.client.get(reverse("web_logout"))
        self.login(ngo.email, "Example123")
        self.assertContains(self.client.get(reverse("ngo_dashboard")), "Yearly license")

    def test_bad_document_rejected(self):
        self.login("membership@caregrid.example", "Member@123")
        self.client.post(reverse("membership_register"), {
            "name": "Invalid", "email": "bad-doc@caregrid.example", "password": "Example123",
            "registration_certificate": SimpleUploadedFile("fake.pdf", b"not a pdf"),
        })
        self.assertFalse(DemoNgoMembership.objects.filter(email="bad-doc@caregrid.example").exists())
