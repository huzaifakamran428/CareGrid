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
