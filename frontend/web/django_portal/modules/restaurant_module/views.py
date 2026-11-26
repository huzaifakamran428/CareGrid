from django.shortcuts import render

def restaurant_portal(request):
    return render(request, "restaurant/restaurant_portal.html")
