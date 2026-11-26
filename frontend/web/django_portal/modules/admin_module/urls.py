from django.urls import path
from . import views

urlpatterns = [
    path('dashboard/', views.admin_dashboard_view, name='admin_dashboard'),
    path('users/', views.user_management_view, name='user_management'),
    path('users/<int:user_id>/toggle/', views.toggle_user_status, name='toggle_user_status'),
    path('users/authorize/', views.authorize_new_user, name='authorize_new_user'),
    path('beneficiaries/', views.beneficiary_registry_view, name='admin_beneficiaries'),
    path('food-logs/', views.food_logs_view, name='admin_food_logs'),
]
