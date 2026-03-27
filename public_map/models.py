from django.db import models
from django.conf import settings

# 1. Bảng Loại Cây
class TreeSpecies(models.Model):
    name = models.CharField(max_length=100, verbose_name="Tên loài")
    characteristics = models.TextField(verbose_name="Đặc tính", blank=True)

    # Đặc tính mở rộng cho AI đề xuất
    is_pest_prone = models.BooleanField(default=False, verbose_name="Dễ sâu bệnh")
    is_fall_prone = models.BooleanField(default=False, verbose_name="Dễ đổ/gãy")
    is_fast_growing = models.BooleanField(default=False, verbose_name="Mọc nhanh (cần cắt tỉa)")
    is_drought_sensitive = models.BooleanField(default=False, verbose_name="Nhạy cảm hạn hán")
    is_invasive_roots = models.BooleanField(default=False, verbose_name="Rễ xâm lấn")
    watering_frequency_days = models.PositiveIntegerField(default=7, verbose_name="Chu kỳ tưới nước (ngày)")
    inspection_frequency_days = models.PositiveIntegerField(default=90, verbose_name="Chu kỳ kiểm tra (ngày)")

    def __str__(self):
        return self.name

# 2. Bảng Cây Xanh
class UrbanTree(models.Model):
    species = models.ForeignKey(TreeSpecies, on_delete=models.CASCADE, verbose_name="Loài cây")
    code = models.CharField(max_length=20, unique=True, verbose_name="Mã cây")
    height = models.FloatField(verbose_name="Chiều cao (m)")
    status = models.CharField(max_length=50, verbose_name="Trạng thái", choices=[
        ('TOT', 'Tốt'),
        ('SAU_BENH', 'Sâu bệnh'),
        ('NGUY_HIEM', 'Nguy hiểm')
    ])
    
    # Dữ liệu GIS
    latitude = models.FloatField(verbose_name="Vĩ độ (Y)")
    longitude = models.FloatField(verbose_name="Kinh độ (X)")
    
    address = models.CharField(max_length=200, verbose_name="Địa chỉ", blank=True)
    
    # Hình ảnh cây - upload_to: Tự động tạo thư mục 'tree_images' để chứa ảnh upload lên
    image = models.ImageField(upload_to='tree_images/', verbose_name="Hình ảnh", blank=True, null=True)

    def __str__(self):
        return f"{self.code} - {self.species.name}"

# 3. Bảng Lịch sử chăm sóc
class MaintenanceLog(models.Model):
    # Liên kết với cây xanh (Một cây có nhiều lần chăm sóc)
    tree = models.ForeignKey(UrbanTree, on_delete=models.CASCADE, verbose_name="Cây xanh")
    date = models.DateField(verbose_name="Ngày thực hiện")
    action = models.CharField(max_length=200, verbose_name="Công việc", choices=[
        ('CAT_TIA', 'Cắt tỉa cành'),
        ('BON_PHAN', 'Bón phân'),
        ('PHUN_THUOC', 'Phun thuốc trừ sâu'),
        ('KIEM_TRA', 'Kiểm tra định kỳ'),
        ('TUOI_NUOC', 'Tưới nước'),
    ])
    performer = models.CharField(max_length=100, verbose_name="Người thực hiện")
    note = models.TextField(verbose_name="Ghi chú/Kết quả", blank=True)

    def __str__(self):
        return f"{self.tree.code} - {self.action} ({self.date})"


# 4. Bảng Vùng quản lý
class ManagementZone(models.Model):
    name = models.CharField(max_length=100, verbose_name="Tên vùng")
    color = models.CharField(max_length=7, default='#1abc9c', verbose_name="Màu hiển thị")
    polygon_json = models.TextField(verbose_name="Polygon GeoJSON")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


# 5. Bảng nhật ký hoạt động hệ thống
class ActivityLog(models.Model):
    ACTION_CHOICES = [
        ('ADD_TREE', 'Thêm cây'),
        ('EDIT_TREE', 'Sửa cây'),
        ('DELETE_TREE', 'Xóa cây'),
        ('ADD_SPECIES', 'Thêm loài'),
        ('EDIT_SPECIES', 'Sửa loài'),
        ('DELETE_SPECIES', 'Xóa loài'),
        ('ADD_MAINTENANCE', 'Thêm chăm sóc'),
        ('BULK_MAINTENANCE', 'Chăm sóc hàng loạt'),
        ('UPLOAD_IMAGE', 'Cập nhật ảnh'),
    ]

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='activity_logs',
        verbose_name='Người thao tác',
    )
    action_type = models.CharField(max_length=32, choices=ACTION_CHOICES, verbose_name='Hành động')
    entity_type = models.CharField(max_length=32, blank=True, verbose_name='Đối tượng')
    entity_code = models.CharField(max_length=120, blank=True, verbose_name='Mã/Tên đối tượng')
    detail = models.TextField(blank=True, verbose_name='Chi tiết')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='Thời gian')

    class Meta:
        ordering = ['-created_at']
        verbose_name = 'Nhật ký hoạt động'
        verbose_name_plural = 'Nhật ký hoạt động'

    def __str__(self):
        actor = self.user.username if self.user else 'unknown'
        return f'[{self.created_at:%d/%m/%Y %H:%M}] {actor}: {self.get_action_display()}'