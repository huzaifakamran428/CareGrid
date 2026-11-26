from django.shortcuts import render

def ngo_dashboard(request):
    return render(request, "ngo/ngo_dashboard.html")
