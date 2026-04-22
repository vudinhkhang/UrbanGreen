from django.contrib import admin
from .models import TreeSpecies, UrbanTree, TreeImage, District, UserManagedDistrict, SoilQuality
try:
    from .models import MaintenanceLog
except ImportError:
    pass

# Inline display for Tree Images
class TreeImageInline(admin.TabularInline):
    model = TreeImage
    extra = 1
    fields = ('image', 'caption', 'uploaded_at')
    readonly_fields = ('uploaded_at',)

# Customize MaintenanceLog admin
class MaintenanceLogAdmin(admin.ModelAdmin):
    list_display = ('tree', 'date', 'action', 'performer', 'get_action_details')
    search_fields = ('tree__code', 'performer', 'note')
    list_filter = ('action', 'date')
    date_hierarchy = 'date'
    readonly_fields = ('tree',)
    
    def get_action_details(self, obj):
        """Hiển thị chi tiết hành động tùy theo loại"""
        if obj.action == 'BON_PHAN' and obj.fertilizer_name:
            return f"🌿 {obj.fertilizer_name}"
        elif obj.action == 'PHUN_THUOC' and obj.pesticide_name:
            return f"💊 {obj.pesticide_name}"
        elif obj.action == 'TUOI_NUOC' and obj.water_amount:
            return f"💧 {obj.water_amount} lít"
        elif obj.action == 'CAT_TIA' and obj.measurement_canopy_diameter:
            return f"📏 Vòm: {obj.measurement_canopy_diameter}m²"
        elif obj.action == 'KIEM_TRA':
            details = []
            if obj.measurement_height:
                details.append(f"Cao: {obj.measurement_height}m")
            if obj.measurement_trunk_radius:
                details.append(f"Đường kính: {obj.measurement_trunk_radius}cm")
            if obj.measurement_canopy_diameter:
                details.append(f"Vòm: {obj.measurement_canopy_diameter}m²")
            return " | ".join(details) if details else "-"
        return "-"
    
    get_action_details.short_description = "Chi tiết"
    
    fieldsets = (
        ('Thông tin chung', {
            'fields': ('tree', 'date', 'action', 'performer', 'note')
        }),
        ('Bón phân', {
            'fields': ('fertilizer_name',),
            'classes': ('collapse',)
        }),
        ('Phun thuốc', {
            'fields': ('pesticide_name',),
            'classes': ('collapse',)
        }),
        ('Tưới nước', {
            'fields': ('water_amount',),
            'classes': ('collapse',)
        }),
        ('Đo lường cây (kiểm tra định kỳ & cắt tỉa)', {
            'fields': ('measurement_height', 'measurement_trunk_radius', 'measurement_canopy_diameter'),
            'classes': ('collapse',)
        }),
    )

# Customize UrbanTree admin
class UrbanTreeAdmin(admin.ModelAdmin):
    inlines = [TreeImageInline]
    list_display = ('code', 'species', 'height', 'status', 'district', 'address')
    search_fields = ('code', 'species__name', 'address')
    list_filter = ('status', 'species', 'district')
    fieldsets = (
        ('Thông tin cơ bản', {
            'fields': ('code', 'species', 'status', 'district', 'soil_qualities')
        }),
        ('Thông tin cây', {
            'fields': ('height', 'trunk_radius', 'canopy_diameter', 'planting_year'),
            'description': 'Thông tin đặc tính vật lý của cây xanh'
        }),
        ('Vị trí địa lý', {
            'fields': ('latitude', 'longitude', 'address'),
            'classes': ('collapse',)
        }),
        ('Hình ảnh', {
            'fields': ('image',),
            'classes': ('collapse',)
        }),
    )

# Customize District admin
class DistrictAdmin(admin.ModelAdmin):
    list_display = ('name', 'code', 'description')
    search_fields = ('name', 'code')
    readonly_fields = ('created_at',)

# Customize UserManagedDistrict admin - Inline for easier management
class UserManagedDistrictInline(admin.TabularInline):
    model = UserManagedDistrict
    extra = 1
    fields = ('district', 'created_at')
    readonly_fields = ('created_at',)

# Optional: Custom UserManagedDistrict admin
class UserManagedDistrictAdmin(admin.ModelAdmin):
    list_display = ('user', 'district', 'created_at')
    search_fields = ('user__username', 'district__name')
    list_filter = ('district', 'user')
    readonly_fields = ('created_at',)
    fieldsets = (
        ('Thông tin', {
            'fields': ('user', 'district', 'created_at')
        }),
    )

# Đăng ký để quản lý trong trang Admin
admin.site.register(TreeSpecies)
admin.site.register(UrbanTree, UrbanTreeAdmin)
admin.site.register(TreeImage)
admin.site.register(MaintenanceLog, MaintenanceLogAdmin)
admin.site.register(District, DistrictAdmin)
admin.site.register(UserManagedDistrict, UserManagedDistrictAdmin)
admin.site.register(SoilQuality)