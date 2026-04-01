from django.contrib import admin
from .models import TreeSpecies, UrbanTree, TreeImage
try:
    from .models import MaintenanceLog
    admin.site.register(MaintenanceLog)
except ImportError:
    pass

# Inline display for Tree Images
class TreeImageInline(admin.TabularInline):
    model = TreeImage
    extra = 1
    fields = ('image', 'caption', 'uploaded_at')
    readonly_fields = ('uploaded_at',)

# Customize UrbanTree admin
class UrbanTreeAdmin(admin.ModelAdmin):
    inlines = [TreeImageInline]
    list_display = ('code', 'species', 'status', 'address')
    search_fields = ('code', 'species__name', 'address')
    list_filter = ('status', 'species')

# Đăng ký để quản lý trong trang Admin
admin.site.register(TreeSpecies)
admin.site.register(UrbanTree, UrbanTreeAdmin)
admin.site.register(TreeImage)