from django.db import migrations, models

class Migration(migrations.Migration):
    initial = True
    dependencies = []
    operations = [
        migrations.CreateModel(
            name="DemoNgoMembership",
            fields=[
                ("id", models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name="ID")),
                ("email", models.EmailField(max_length=254, unique=True)),
                ("name", models.CharField(max_length=160)),
                ("password_hash", models.CharField(max_length=256)),
                ("plan", models.CharField(default="Trial", max_length=16)),
                ("expires_on", models.DateField()),
            ],
        ),
    ]
