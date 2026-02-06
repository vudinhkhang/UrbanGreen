from django.db import models

# 1. Bảng Loại Cây
class TreeSpecies(models.Model):
    name = models.CharField(max_length=100, verbose_name="Tên loài")
    characteristics = models.TextField(verbose_name="Đặc tính", blank=True)

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
        ('KIEM_TRA', 'Kiểm tra định kỳ')
    ])
    performer = models.CharField(max_length=100, verbose_name="Người thực hiện")
    note = models.TextField(verbose_name="Ghi chú/Kết quả", blank=True)

    def __str__(self):
        return f"{self.tree.code} - {self.action} ({self.date})"