from django.urls import path
from . import views

urlpatterns = [
    path('portal/', views.lab_portal, name='lab_portal'),
]
