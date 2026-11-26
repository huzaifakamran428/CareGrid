from django.urls import path
from . import views

urlpatterns = [
    path('portal/', views.pharmacy_portal_view, name='pharmacy_portal'),
    path('submit-bill/', views.pharmacy_submit_bill, name='pharmacy_submit_bill'),
]
