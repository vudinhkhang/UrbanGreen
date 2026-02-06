from django.shortcuts import render
from .models import UrbanTree

def home_view(request):
    # Lấy toàn bộ cây từ Database (ORM)
    trees = UrbanTree.objects.all()
    
    # Đẩy dữ liệu sang HTML
    return render(request, 'index.html', {'trees': trees})