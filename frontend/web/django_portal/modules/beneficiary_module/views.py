from django.shortcuts import render

def beneficiary_portal(request):
    return render(request, "beneficiary/beneficiary_portal.html")
