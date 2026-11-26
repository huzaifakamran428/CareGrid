from django.db import models
from django.utils import timezone

class DemoNgoMembership(models.Model):
    email = models.EmailField(unique=True)
    name = models.CharField(max_length=160)
    password_hash = models.CharField(max_length=256)
    plan = models.CharField(max_length=16, default="Trial")
    expires_on = models.DateField()

    @property
    def active(self):
        return timezone.localdate() < self.expires_on

    @property
    def status(self):
        return self.plan if self.active else "Expired"

    @property
    def days_left(self):
        return max(0, (self.expires_on - timezone.localdate()).days)

    @property
    def plan_label(self):
        return "One-month free trial" if self.plan == "Trial" else "Yearly license"


class DemoNgoDocument(models.Model):
    membership = models.ForeignKey(DemoNgoMembership, on_delete=models.CASCADE, related_name="documents")
    category = models.CharField(max_length=40)
    filename = models.CharField(max_length=255)
    content = models.BinaryField()
