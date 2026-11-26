from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('django-admin/', admin.site.urls),
    path('', include('modules.auth_module.urls')),
    path('admin-portal/', include('modules.admin_module.urls')),
    path('ngo/', include('modules.ngo_module.urls')),
    path('pharmacy/', include('modules.pharmacy_module.urls')),
    path('lab/', include('modules.lab_module.urls')),
    path('restaurant/', include('modules.restaurant_module.urls')),
    path('beneficiary/', include('modules.beneficiary_module.urls')),
]
