from django.urls import path
from . import views

urlpatterns = [
    path('portal/', views.beneficiary_portal, name='beneficiary_portal'),
]
