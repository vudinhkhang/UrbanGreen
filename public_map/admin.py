from django.contrib import admin
from .models import TreeSpecies, UrbanTree
try:
    from .models import MaintenanceLog
    admin.site.register(MaintenanceLog)
except ImportError:
    pass

# Đăng ký để quản lý trong trang Admin
admin.site.register(TreeSpecies)
admin.site.register(UrbanTree)