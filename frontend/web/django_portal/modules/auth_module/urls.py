from django.urls import path
from . import views

urlpatterns = [
    path('', views.home_redirect, name='home'),
    path('login/', views.web_login_view, name='web_login'),
    path('logout/', views.web_logout_view, name='web_logout'),
]
