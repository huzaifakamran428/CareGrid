from django.shortcuts import render

def lab_portal(request):
    return render(request, "lab/lab_portal.html")
