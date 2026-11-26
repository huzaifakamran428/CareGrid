from django.contrib import admin
from django.urls import path, include
from modules.auth_module import membership_views, sponsor_views

urlpatterns = [
    path('membership/', membership_views.dashboard, name='membership_dashboard'),
    path('membership/register/', membership_views.register, name='membership_register'),
    path('membership/<int:pk>/renew/', membership_views.renew, name='membership_renew'),
    path('sponsor/', sponsor_views.dashboard, name='sponsor_dashboard'),
    path('sponsor/donate/', sponsor_views.donate, name='sponsor_donate'),
    path('django-admin/', admin.site.urls),
    path('', include('modules.auth_module.urls')),
    path('admin-portal/', include('modules.admin_module.urls')),
    path('ngo/', include('modules.ngo_module.urls')),
    path('pharmacy/', include('modules.pharmacy_module.urls')),
    path('lab/', include('modules.lab_module.urls')),
    path('restaurant/', include('modules.restaurant_module.urls')),
    path('beneficiary/', include('modules.beneficiary_module.urls')),
]
