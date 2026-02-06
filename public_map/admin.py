from django.contrib import admin
from .models import TreeSpecies, UrbanTree

# Đăng ký để quản lý trong trang Admin
admin.site.register(TreeSpecies)
admin.site.register(UrbanTree)