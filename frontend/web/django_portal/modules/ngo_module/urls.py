from django.urls import path
from . import views

urlpatterns = [
    path('dashboard/', views.ngo_dashboard, name='ngo_dashboard'),
]
