from datetime import date
from django.test import TestCase
from django.urls import reverse
from .demo_memberships import add_months
from .models import DemoNgoMembership

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
