from django.db import migrations, models
import django.db.models.deletion

class Migration(migrations.Migration):
    dependencies = [("auth_module", "0001_initial")]
    operations = [
        migrations.CreateModel(
            name="DemoNgoDocument",
            fields=[
                ("id", models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name="ID")),
                ("category", models.CharField(max_length=40)),
                ("filename", models.CharField(max_length=255)),
                ("content", models.BinaryField()),
                ("membership", models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name="documents", to="auth_module.demongomembership")),
            ],
        ),
    ]
