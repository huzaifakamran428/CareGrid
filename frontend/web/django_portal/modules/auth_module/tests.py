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

    def test_role_guards_and_sponsor(self):
        self.assertRedirects(self.client.get(reverse("sponsor_dashboard")), reverse("web_login"))
        self.login("admin@caregrid.org", "Admin@123")
        self.assertEqual(self.client.get(reverse("membership_dashboard")).status_code, 403)
        self.client.get(reverse("web_logout"))
        self.assertRedirects(self.login("sponsor@caregrid.example", "Sponsor@123"), reverse("sponsor_dashboard"))
        ngo = DemoNgoMembership.objects.get(email="kamran@alkhidmat-lhr.org")
        self.client.post(reverse("sponsor_donate"), {"ngo": ngo.pk, "amount": "1000", "cause": "Healthcare"})
        self.assertEqual(len(self.client.session["cg_demo_receipts"]), 1)
        self.assertEqual(self.client.get(reverse("user_management")).status_code, 403)

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
