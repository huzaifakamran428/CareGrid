from django.urls import path
from . import views

urlpatterns = [
    path('portal/', views.restaurant_portal, name='restaurant_portal'),
]
