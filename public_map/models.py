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

    def __str__(self):
        return f"{self.code} - {self.species.name}"