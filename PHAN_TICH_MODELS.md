# 📊 Phân Tích Chi Tiết Các Model Django - UrbanGreen

**Tài liệu:** Phân tích models.py và views.py  
**Ngôn ngữ:** Python + Django ORM  
**Cơ Sở Dữ Liệu:** PostgreSQL  
**Ngày:** 1 Tháng 4, 2026

---

## 📑 Mục Lục

1. [5 Model Chính](#5-model-chính)
2. [Sơ Đồ Mối Quan Hệ](#sơ-đồ-mối-quan-hệ)
3. [Code Demo Chi Tiết](#code-demo-chi-tiết)
4. [Các View Sử Dụng Model](#các-view-sử-dụng-model)
5. [Truy Vấn Thông Minh (AI Đề Xuất)](#truy-vấn-thông-minh)

---

# 5 MODEL CHÍNH

## 1️⃣ **TreeSpecies** - Loài Cây

### Cấu Trúc

```python
class TreeSpecies(models.Model):
    # Thông tin cơ bản
    name = models.CharField(max_length=100, verbose_name="Tên loài")
    characteristics = models.TextField(verbose_name="Đặc tính", blank=True)

    # Đặc tính cho AI đề xuất bảo trì
    is_pest_prone = models.BooleanField(default=False, verbose_name="Dễ sâu bệnh")
    is_fall_prone = models.BooleanField(default=False, verbose_name="Dễ đổ/gãy")
    is_fast_growing = models.BooleanField(default=False, verbose_name="Mọc nhanh (cần cắt tỉa)")
    is_drought_sensitive = models.BooleanField(default=False, verbose_name="Nhạy cảm hạn hán")
    is_invasive_roots = models.BooleanField(default=False, verbose_name="Rễ xâm lấn")

    # Chu kỳ bảo trì
    watering_frequency_days = models.PositiveIntegerField(default=7, verbose_name="Chu kỳ tưới nước (ngày)")
    inspection_frequency_days = models.PositiveIntegerField(default=90, verbose_name="Chu kỳ kiểm tra (ngày)")

    def __str__(self):
        return self.name
```

### Ý Nghĩa Từng Trường

| Trường | Kiểu | Mục Đích |
|--------|------|---------|
| **name** | CharField | Tên loài (vd: "Xoan Tía", "Sao Đen") |
| **characteristics** | TextField | Mô tả đặc tính (không bắt buộc) |
| **is_pest_prone** | Boolean | Dễ sâu bệnh? → Đề xuất kiểm tra sâu |
| **is_fall_prone** | Boolean | Dễ đổ/gãy? → Cần cắt tỉa định kỳ |
| **is_fast_growing** | Boolean | Mọc nhanh? → Cần cắt tỉa thường xuyên |
| **is_drought_sensitive** | Boolean | Nhạy hạn? → Tưới nước thường xuyên |
| **is_invasive_roots** | Boolean | Rễ xâm lấn? → Cảnh báo vị trí |
| **watering_frequency_days** | PositiveInt | Khoảng cách tưới nước (mặc định: 7 ngày) |
| **inspection_frequency_days** | PositiveInt | Khoảng cách kiểm tra (mặc định: 90 ngày) |

### Code Demo

```python
# ===== THÊM LOÀI CÂY MỚI =====
from public_map.models import TreeSpecies

# Tạo loài "Xoan Tía" - dễ sâu bệnh, cần tưới 7 ngày
xoan_tia = TreeSpecies.objects.create(
    name="Xoan Tía",
    characteristics="Cây lớn, thích ánh sáng, bóng rổ",
    is_pest_prone=True,        # ⚠️ Dễ sâu bệnh
    is_fall_prone=False,
    is_fast_growing=True,       # 📈 Mọc nhanh → cần cắt tỉa
    is_drought_sensitive=False,
    is_invasive_roots=False,
    watering_frequency_days=7,
    inspection_frequency_days=90
)
print(f"✓ Thêm loài: {xoan_tia.name}")

# ===== TÌM LOÀI CÓ CỰC ĐẶC TÍNH =====

# Loài dễ sâu bệnh
pest_species = TreeSpecies.objects.filter(is_pest_prone=True)
print(f"🐛 Các loài dễ sâu bệnh: {[s.name for s in pest_species]}")

# Loài mọc nhanh (cần cắt tỉa)
fast_species = TreeSpecies.objects.filter(is_fast_growing=True)
print(f"🌳 Các loài mọc nhanh: {[s.name for s in fast_species]}")

# ===== CẬP NHẬT LOÀI =====
sao_den = TreeSpecies.objects.get(name="Sao Đen")
sao_den.watering_frequency_days = 5  # Thay đổi chu kỳ tưới
sao_den.save()
print(f"✓ Cập nhật chu kỳ tưới sao đen thành 5 ngày")
```

---

## 2️⃣ **UrbanTree** - Cây Xanh (Quan Trọng Nhất)

### Cấu Trúc

```python
class UrbanTree(models.Model):
    # Liên kết loài cây
    species = models.ForeignKey(TreeSpecies, on_delete=models.CASCADE, verbose_name="Loài cây")
    
    # Thông tin cơ bản
    code = models.CharField(max_length=20, unique=True, verbose_name="Mã cây")
    height = models.FloatField(verbose_name="Chiều cao (m)")
    
    # Trạng thái sức khoẻ
    status = models.CharField(max_length=50, verbose_name="Trạng thái", choices=[
        ('TOT', 'Tốt'),
        ('SAU_BENH', 'Sâu bệnh'),
        ('NGUY_HIEM', 'Nguy hiểm')
    ])
    
    # Dữ liệu GIS (tọa độ GPS)
    latitude = models.FloatField(verbose_name="Vĩ độ (Y)")
    longitude = models.FloatField(verbose_name="Kinh độ (X)")
    
    # Thông tin bổ sung
    address = models.CharField(max_length=200, verbose_name="Địa chỉ", blank=True)
    image = models.ImageField(upload_to='tree_images/', verbose_name="Hình ảnh", blank=True, null=True)

    def __str__(self):
        return f"{self.code} - {self.species.name}"
```

### Ý Nghĩa Từng Trường

| Trường | Kiểu | Ví Dụ | Mục Đích |
|--------|------|-------|---------|
| **species** | FK | TreeSpecies(id=1) | Liên kết với loài cây |
| **code** | CharField | "T001", "T002" | Mã định danh duy nhất |
| **height** | Float | 5.5 | Chiều cao cây (m) |
| **status** | Choice | "TOT" / "SAU_BENH" / "NGUY_HIEM" | 🟢🟡🔴 Trạng thái sức khoẻ |
| **latitude** | Float | 21.0285 | Vĩ độ GPS (Y) |
| **longitude** | Float | 105.8542 | Kinh độ GPS (X) |
| **address** | CharField | "123 Nguyễn Huệ" | Địa chỉ con đường |
| **image** | ImageField | tree_images/T001.jpg | Hình ảnh cây |

### Code Demo

```python
from public_map.models import TreeSpecies, UrbanTree

# ===== THÊM CÂY XANH MỚI =====

# Bước 1: Lấy loài (đã tạo ở trên)
xoan_tia = TreeSpecies.objects.get(name="Xoan Tía")

# Bước 2: Tạo cây mới
tree1 = UrbanTree.objects.create(
    species=xoan_tia,
    code="T001",
    height=5.5,
    status="TOT",              # 🟢 Cây tốt
    latitude=21.0285,
    longitude=105.8542,
    address="123 Nguyễn Huệ, Hà Nội"
)
print(f"✓ Thêm cây: {tree1.code} - {tree1.species.name}")

# ===== LẤY CÂY THEO ĐIỀU KIỆN =====

# Lấy tất cả cây sâu bệnh
sick_trees = UrbanTree.objects.filter(status='SAU_BENH')
print(f"⚠️ Các cây sâu bệnh: {[t.code for t in sick_trees]}")

# Lấy cây xoan tía với status tốt
healthy_xoan = UrbanTree.objects.filter(
    species__name="Xoan Tía",
    status="TOT"
)
print(f"🟢 Xoan tía tốt: {healthy_xoan.count()} cây")

# ===== TÌM CÂY TRONG BÁN KÍNH (Haversine) =====
from django.db.models import F, FloatField
from math import radians, sin, cos, sqrt, atan2

def find_trees_near(lat, lon, radius_km=1):
    """Tìm cây trong bán kính X km từ vị trí cho trước"""
    earth_radius_km = 6371
    lat_rad, lon_rad = radians(lat), radians(lon)
    
    trees = UrbanTree.objects.all()
    result = []
    
    for tree in trees:
        tree_lat = radians(tree.latitude)
        tree_lon = radians(tree.longitude)
        
        dlat = tree_lat - lat_rad
        dlon = tree_lon - lon_rad
        
        a = sin(dlat/2)**2 + cos(lat_rad) * cos(tree_lat) * sin(dlon/2)**2
        c = 2 * atan2(sqrt(a), sqrt(1-a))
        distance = earth_radius_km * c
        
        if distance <= radius_km:
            result.append({
                'tree': tree,
                'distance_km': round(distance, 2)
            })
    
    return sorted(result, key=lambda x: x['distance_km'])

# Sử dụng
nearby = find_trees_near(lat=21.0285, lon=105.8542, radius_km=0.5)
for item in nearby:
    print(f"🌳 {item['tree'].code}: {item['distance_km']} km")

# ===== THAY ĐỔI TRẠNG THÁI CÂY =====
tree = UrbanTree.objects.get(code="T001")

# Cây bị sâu bệnh
tree.status = 'SAU_BENH'
tree.save()
print(f"⚠️ {tree.code} bị sâu bệnh")

# Cây nguy hiểm
tree.status = 'NGUY_HIEM'
tree.save()
print(f"🔴 {tree.code} nguy hiểm - cần xử lý ngay")

# ===== CẬP NHẬT HÌNH ẢNH CÂY =====
from django.core.files.base import ContentFile
from PIL import Image
import io

tree = UrbanTree.objects.get(code="T001")

# Nếu có file upload từ form
if request.FILES.get('image'):
    # Kiểm tra kích thước file
    file = request.FILES['image']
    if file.size > 5 * 1024 * 1024:  # > 5MB
        print("❌ File quá lớn (max 5MB)")
    else:
        tree.image = file
        tree.save()
        print(f"✓ Cập nhật ảnh cho {tree.code}")
```

---

## 3️⃣ **MaintenanceLog** - Lịch Sử Chăm Sóc

### Cấu Trúc

```python
class MaintenanceLog(models.Model):
    # Liên kết cây
    tree = models.ForeignKey(UrbanTree, on_delete=models.CASCADE, verbose_name="Cây xanh")
    
    # Thông tin chăm sóc
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
```

### Code Demo

```python
from public_map.models import UrbanTree, MaintenanceLog
from datetime import date

# ===== GHI NHẬN CHĂM SÓC =====

tree = UrbanTree.objects.get(code="T001")

# Ghi nhận tưới nước hôm nay
MaintenanceLog.objects.create(
    tree=tree,
    date=date.today(),
    action='TUOI_NUOC',
    performer="Nguyễn Văn A",
    note="Tưới nước đủ, đất ẩm tốt"
)
print("✓ Ghi nhận: Tưới nước")

# Ghi nhận phun thuốc trừ sâu
MaintenanceLog.objects.create(
    tree=tree,
    date=date.today(),
    action='PHUN_THUOC',
    performer="Trần Thị B",
    note="Phun thuốc diệt sâu xanh, sâu hổ phách có hiệu quả"
)
print("✓ Ghi nhận: Phun thuốc")

# ===== XEM LỊCH SỬ CHĂM SÓC =====

# Tất cả bản ghi cho cây T001
history = MaintenanceLog.objects.filter(tree=tree).order_by('-date')
for log in history:
    print(f"[{log.date}] {log.action}: {log.performer} - {log.note}")

# ===== TÌM LẦN CHĂM SÓC CUỐI CÙNG =====

# Lần tưới nước cuối cùng
last_watering = MaintenanceLog.objects.filter(
    tree=tree,
    action='TUOI_NUOC'
).order_by('-date').first()

if last_watering:
    print(f"💧 Tưới nước lần cuối: {last_watering.date}")
else:
    print(f"❌ {tree.code} chưa từng tưới nước")

# Lần kiểm tra cuối cùng
last_inspection = MaintenanceLog.objects.filter(
    tree=tree,
    action='KIEM_TRA'
).order_by('-date').first()

if last_inspection:
    print(f"🔍 Kiểm tra lần cuối: {last_inspection.date}")
else:
    print(f"⚠️ {tree.code} chưa kiểm tra")

# ===== ĐẾM SỐ LẦN CHĂM SÓC THEO LOẠI =====
from django.db.models import Count

actions_count = MaintenanceLog.objects.filter(tree=tree).values('action').annotate(
    count=Count('id')
)

print("\n📊 Thống kê chăm sóc cây T001:")
for item in actions_count:
    print(f"  - {item['action']}: {item['count']} lần")

# ===== CHĂM SÓC HÀNG LOẠT (API) =====

# Thêm chăm sóc cho nhiều cây cùng lúc
tree_ids = [1, 2, 3, 4, 5]
performer = "Đội sư"
action = 'PHUN_THUOC'
note = "Phun thuốc định kỳ hàng tháng"

logs_to_create = []
for tree_id in tree_ids:
    logs_to_create.append(
        MaintenanceLog(
            tree_id=tree_id,
            date=date.today(),
            action=action,
            performer=performer,
            note=note
        )
    )

MaintenanceLog.objects.bulk_create(logs_to_create)
print(f"✓ Thêm chăm sóc cho {len(tree_ids)} cây")
```

---

## 4️⃣ **ManagementZone** - Vùng Quản Lý

### Cấu Trúc

```python
class ManagementZone(models.Model):
    name = models.CharField(max_length=100, verbose_name="Tên vùng")
    color = models.CharField(max_length=7, default='#1abc9c', verbose_name="Màu hiển thị")
    polygon_json = models.TextField(verbose_name="Polygon GeoJSON")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name
```

### Code Demo

```python
from public_map.models import ManagementZone
import json

# ===== TẠO VÙNG QUẢN LÝ =====

# Polygon GeoJSON cho khu Tây Hà Nội
polygon_khu_tay = {
    "type": "Polygon",
    "coordinates": [[
        [105.8, 21.0],
        [105.9, 21.0],
        [105.9, 21.1],
        [105.8, 21.1],
        [105.8, 21.0]
    ]]
}

zone = ManagementZone.objects.create(
    name="Khu Tây",
    color="#FF6B6B",  # Đỏ
    polygon_json=json.dumps(polygon_khu_tay)
)
print(f"✓ Tạo vùng: {zone.name}")

# ===== LẤY TẤT CẢ VÙNG =====

zones = ManagementZone.objects.all()
for zone in zones:
    print(f"🗺️ Vùng: {zone.name} (Màu: {zone.color})")

# ===== CẬP NHẬT VÙNG =====

zone = ManagementZone.objects.get(name="Khu Tây")
zone.color = "#4ECDC4"  # Thay đổi màu
zone.save()
print(f"✓ Cập nhật màu khu Tây thành {zone.color}")

# ===== KIỂM TRA CÂY TRONG VÙNG (Sử dụng GeoJSON) =====

def get_trees_in_zone(zone_name):
    """Lấy tất cả cây trong một vùng"""
    from public_map.models import UrbanTree
    
    zone = ManagementZone.objects.get(name=zone_name)
    polygon = json.loads(zone.polygon_json)
    
    # Lấy tọa độ ranh giới
    coords = polygon['coordinates'][0]
    lats = [c[1] for c in coords]
    lons = [c[0] for c in coords]
    
    min_lat, max_lat = min(lats), max(lats)
    min_lon, max_lon = min(lons), max(lons)
    
    # Tìm cây trong hộp giới hạn
    trees = UrbanTree.objects.filter(
        latitude__gte=min_lat,
        latitude__lte=max_lat,
        longitude__gte=min_lon,
        longitude__lte=max_lon
    )
    
    return trees

trees_in_zone = get_trees_in_zone("Khu Tây")
print(f"🌳 Cây trong khu Tây: {trees_in_zone.count()}")
```

---

## 5️⃣ **ActivityLog** - Nhật Ký Hoạt Động (Audit Trail)

### Cấu Trúc

```python
class ActivityLog(models.Model):
    ACTION_CHOICES = [
        ('ADD_TREE', 'Thêm cây'),
        ('EDIT_TREE', 'Sửa cây'),
        ('DELETE_TREE', 'Xóa cây'),
        ('ADD_SPECIES', 'Thêm loài'),
        ('BULK_MAINTENANCE', 'Chăm sóc hàng loạt'),
        ('UPLOAD_IMAGE', 'Cập nhật ảnh'),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True)
    action_type = models.CharField(max_length=32, choices=ACTION_CHOICES)
    entity_type = models.CharField(max_length=32, blank=True)
    entity_code = models.CharField(max_length=120, blank=True)
    detail = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        actor = self.user.username if self.user else 'unknown'
        return f'[{self.created_at:%d/%m/%Y %H:%M}] {actor}: {self.get_action_display()}'
```

### Code Demo

```python
from public_map.models import ActivityLog

# ===== GHI NHẬT KÝ HOẠT ĐỘNG =====

def log_activity(request, action_type, entity_type, entity_code='', detail=''):
    """Ghi nhập một hoạt động"""
    user = request.user if request.user.is_authenticated else None
    ActivityLog.objects.create(
        user=user,
        action_type=action_type,
        entity_type=entity_type,
        entity_code=entity_code or '',
        detail=detail or '',
    )

# Ví dụ trong view
def tree_add_view(request):
    if request.method == 'POST':
        # ... xử lý thêm cây ...
        tree_code = "T123"
        
        # Ghi nhật ký
        log_activity(
            request,
            action_type='ADD_TREE',
            entity_type='TREE',
            entity_code=tree_code,
            detail=f'Thêm cây mới {tree_code} - Xoan Tía'
        )
        print(f"✓ Ghi nhật ký: Thêm cây {tree_code}")

# ===== XEM NHẬT KÝ HỆ THỐNG =====

# Tất cả hoạt động (mới nhất trước)
all_logs = ActivityLog.objects.all()[:20]
for log in all_logs:
    print(f"[{log.created_at:%d/%m/%Y %H:%M}] {log.user.username}: {log.get_action_display()}")

# ===== TÌM HOẠT ĐỘNG CỦA MỘT NGƯỜI DÙNG =====

user_activities = ActivityLog.objects.filter(user__username='admin').order_by('-created_at')
print(f"📝 Hoạt động của admin: {user_activities.count()}")

# ===== THỐNG KÊ HOẠT ĐỘNG THEO LOẠI =====
from django.db.models import Count

action_stats = ActivityLog.objects.values('action_type').annotate(count=Count('id'))
print("\n📊 Thống kê hoạt động:")
for stat in action_stats:
    print(f"  - {stat['action_type']}: {stat['count']} lần")

# ===== TÌM CÁC HOẠT ĐỘNG LIÊN QUAN ĐẾN CÂY X =====

tree_logs = ActivityLog.objects.filter(entity_code='T001')
print(f"\n🌳 Các hoạt động liên quan cây T001:")
for log in tree_logs:
    print(f"  [{log.created_at}] {log.get_action_display()}: {log.detail}")
```

---

# SƠ ĐỒ MỐI QUAN HỆ

```
┌─────────────────────┐
│   TreeSpecies       │  (Loài cây)
│  ─────────────────  │
│  • name             │
│  • is_pest_prone    │
│  • watering_freq... │
└──────────┬──────────┘
           │
           │ 1:N (1 loài - nhiều cây)
           │
           ▼
┌─────────────────────┐         ┌──────────────────┐
│    UrbanTree        │◄───────►│  MaintenanceLog  │
│  ─────────────────  │  1:N    │  ──────────────  │
│  • code (PK)        │         │  • date          │
│  • latitude         │         │  • action        │
│  • longitude        │         │  • performer     │
│  • status           │         │  • note          │
│  • image            │         │  • (FK)tree_id   │
└–────────────────────┘         └──────────────────┘
           │
           │
           ├──────────────────┐
           │                  │
           ▼                  ▼
┌──────────────────┐  ┌────────────────┐
│ ManagementZone   │  │  ActivityLog   │
│ ────────────────  │  │  ────────────  │
│ • name           │  │  • user (FK)   │
│ • polygon_json   │  │  • action_type │
│ • color          │  │  • entity_code │
│ • created_at     │  │  • created_at  │
└──────────────────┘  └────────────────┘
```

---

# CÁC VIEW SỬ DỤNG MODEL

## 🏠 Trang Chủ (home_view)

```python
def home_view(request):
    """Hiển thị tổng quan hệ thống"""
    total_trees = UrbanTree.objects.count()
    total_species = TreeSpecies.objects.count()
    sick_trees = UrbanTree.objects.filter(status='SAU_BENH').count()
    danger_trees = UrbanTree.objects.filter(status='NGUY_HIEM').count()
    healthy_trees = UrbanTree.objects.filter(status='TOT').count()
    
    return render(request, 'index.html', {
        'total_trees': total_trees,
        'total_species': total_species,
        'sick_trees': sick_trees,
        'danger_trees': danger_trees,
        'healthy_trees': healthy_trees,
    })
```

**Dữ liệu trả về:**
- Tổng số cây: 150
- Tổng loài: 25
- Cây sâu bệnh: 12
- Cây nguy hiểm: 3
- Cây tốt: 135

---

## 🗺️ Bản Đồ Interactive (map_view)

```python
def map_view(request):
    """Hiển thị bản đồ GIS với các cây"""
    query = request.GET.get('q', '')
    status_filter = request.GET.get('status', '')

    trees = UrbanTree.objects.all()

    if query:
        trees = trees.filter(
            Q(species__name__icontains=query) | 
            Q(code__icontains=query)
        )
    
    if status_filter:
        trees = trees.filter(status=status_filter)

    # Chuyển đổi thành JSON để Leaflet render
    tree_list = []
    for tree in trees:
        tree_list.append({
            'id': tree.id,
            'code': tree.code,
            'name': tree.species.name,
            'status': tree.status,
            'lat': tree.latitude,
            'long': tree.longitude,
            'height': tree.height,
            'image': tree.image.url if tree.image else '',
            'address': tree.address or ''
        })
    
    tree_json = json.dumps(tree_list)
    
    return render(request, 'map.html', {
        'tree_json': tree_json,
    })
```

**Dữ liệu JSON:**
```json
[
  {
    "id": 1,
    "code": "T001",
    "name": "Xoan Tía",
    "status": "TOT",
    "lat": 21.0285,
    "long": 105.8542,
    "height": 5.5,
    "address": "123 Nguyễn Huệ"
  },
  {
    "id": 2,
    "code": "T002",
    "name": "Sao Đen",
    "status": "SAU_BENH",
    "lat": 21.0290,
    "long": 105.8550,
    "height": 4.2,
    "address": "45 Lý Thái Tổ"
  }
]
```

---

## 📋 Chi Tiết Cây (tree_detail_view)

```python
def tree_detail_view(request, tree_id):
    """Xem chi tiết cây + lịch sử chăm sóc"""
    tree = get_object_or_404(UrbanTree, id=tree_id)
    
    # Lấy lịch sử
    logs = MaintenanceLog.objects.filter(tree=tree).order_by('-date')
    
    return render(request, 'tree_detail.html', {
        'tree': tree,
        'logs': logs,
    })
```

**Hiển thị:**
```
🌳 Chi tiết cây T001
━━━━━━━━━━━━━━━━━━━━
Mã: T001
Loài: Xoan Tía
Chiều cao: 5.5m
Trạng thái: 🟢 Tốt
Vị trí: 21.0285°N, 105.8542°E
Địa chỉ: 123 Nguyễn Huệ

📝 Lịch sử chăm sóc:
  2024-01-15 | Tưới nước | Nguyễn Văn A
  2024-01-10 | Kiểm tra | Trần Thị B
  2024-01-05 | Cắt tỉa | Hoàng Văn C
```

---

## 🔨 CRUD Cây

### ✏️ Thêm Cây (tree_add_view)

```python
def tree_add_view(request):
    if request.method == 'POST':
        code = request.POST.get('code')
        species_id = request.POST.get('species')
        height = request.POST.get('height')
        lat = request.POST.get('latitude')
        lon = request.POST.get('longitude')
        address = request.POST.get('address')
        
        tree = UrbanTree.objects.create(
            code=code,
            species_id=species_id,
            height=float(height),
            latitude=float(lat),
            longitude=float(lon),
            address=address,
            status='TOT'
        )
        
        # Ghi nhật ký
        log_activity(request, 'ADD_TREE', 'TREE', code)
        
        return redirect('tree_list')
```

### 🔄 Sửa Cây (tree_edit_view) - Admin Only

```python
@admin_required
def tree_edit_view(request, tree_id):
    tree = get_object_or_404(UrbanTree, id=tree_id)
    
    if request.method == 'POST':
        tree.code = request.POST.get('code', tree.code)
        tree.height = float(request.POST.get('height', tree.height))
        tree.status = request.POST.get('status', tree.status)
        tree.save()
        
        log_activity(request, 'EDIT_TREE', 'TREE', tree.code)
        
        return redirect('tree_detail', tree_id=tree.id)
```

### 🗑️ Xóa Cây (tree_delete_view) - Admin Only

```python
@admin_required
def tree_delete_view(request, tree_id):
    tree = get_object_or_404(UrbanTree, id=tree_id)
    
    if request.method == 'POST':
        code = tree.code
        log_activity(request, 'DELETE_TREE', 'TREE', code)
        tree.delete()
        return redirect('tree_list')
```

---

# TRUY VẤN THÔNG MINH

## 🤖 AI Đề Xuất Bảo Trì (maintenance_list_view)

```python
def maintenance_list_view(request):
    """AI đề xuất chăm sóc dựa trên loài cây và lịch sử"""
    from datetime import timedelta
    from django.utils import timezone
    
    today = date.today()
    recommendations = []
    
    for tree in UrbanTree.objects.select_related('species'):
        species = tree.species
        
        # ===== 1. KIỂM TRA ĐỊNH KỲ QUAHẠN =====
        last_inspection = MaintenanceLog.objects.filter(
            tree=tree, 
            action='KIEM_TRA'
        ).order_by('-date').first()
        
        inspection_freq = species.inspection_frequency_days
        
        if last_inspection:
            days_since = (today - last_inspection.date).days
        else:
            days_since = 999  # Chưa kiểm tra bao giờ
        
        if days_since > inspection_freq:
            days_overdue = days_since - inspection_freq
            recommendations.append({
                'tree': tree,
                'action': 'KIEM_TRA',
                'reason': f'Quá hạn kiểm tra ({days_overdue} ngày)',
                'urgency': 'critical' if days_overdue > 30 else 'high'
            })
        
        # ===== 2. TƯỚI NƯỚC QUAHẠN =====
        if species.is_drought_sensitive:
            last_watering = MaintenanceLog.objects.filter(
                tree=tree,
                action='TUOI_NUOC'
            ).order_by('-date').first()
            
            watering_freq = species.watering_frequency_days
            
            if last_watering:
                days_since_watering = (today - last_watering.date).days
            else:
                days_since_watering = 999
            
            if days_since_watering > watering_freq:
                recommendations.append({
                    'tree': tree,
                    'action': 'TUOI_NUOC',
                    'reason': 'Cây nhạy hạn - cần tưới nước',
                    'urgency': 'critical'
                })
        
        # ===== 3. CẮT TỈA - CÂY MỌC NHANH =====
        if species.is_fast_growing:
            status = tree.status
            if status == 'TOT' and tree.height > 6:
                recommendations.append({
                    'tree': tree,
                    'action': 'CAT_TIA',
                    'reason': f'Cây mọc nhanh, cao {tree.height}m',
                    'urgency': 'medium'
                })
        
        # ===== 4. CÂY SÂUBỆNH/NGUY HIỂM =====
        if tree.status == 'SAU_BENH' and species.is_pest_prone:
            recommendations.append({
                'tree': tree,
                'action': 'PHUN_THUOC',
                'reason': 'Cây sâu bệnh - cần phun thuốc',
                'urgency': 'critical'
            })
        
        if tree.status == 'NGUY_HIEM':
            recommendations.append({
                'tree': tree,
                'action': 'KIEM_TRA',
                'reason': '⚠️ CÂY NGUY HIỂM - ưu tiên xử lý',
                'urgency': 'critical'
            })
    
    # Sắp xếp: critical → high → medium
    urgency_order = {'critical': 0, 'high': 1, 'medium': 2}
    recommendations.sort(key=lambda r: urgency_order.get(r['urgency'], 3))
    
    return render(request, 'maintenance_list.html', {
        'recommendations': recommendations,
    })
```

**Kết quả:**
```
🤖 AI ĐỀ XUẤT CHĂM SÓC
━━━━━━━━━━━━━━━━━━━━━━━━

🔴 [CRITICAL] (15 đề xuất)
  • T001 (Xoan Tía): Quá hạn kiểm tra 45 ngày
  • T005 (Sao Đen): NGUY HIỂM - ưu tiên xử lý
  • T012 (Phi Lao): Nhạy hạn - cần tưới nước

🟠 [HIGH] (8 đề xuất)
  • T003 (Vàng Anh): Kiểm tra định kỳ quá hạn
  • T008 (Acacia): Cần cắt tỉa

🟡 [MEDIUM] (3 đề xuất)
  • T002 (Mun): Cao 6.5m - nên cắt tỉa
```

---

## 📊 Thống Kê Dashboard (dashboard_view)

```python
def dashboard_view(request):
    """Biểu đồ thống kê hệ thống"""
    
    # === Biểu đồ tròn: Cây theo loài ===
    species_data = list(
        UrbanTree.objects.values('species__name')
        .annotate(count=Count('id'))
        .order_by('-count')
    )
    
    # === Biểu đồ cột: Trạng thái ===
    status_data = list(
        UrbanTree.objects.values('status')
        .annotate(count=Count('id'))
    )
    
    # === Biểu đồ đường: Chăm sóc theo tháng ===
    monthly_data = list(
        MaintenanceLog.objects
        .annotate(month=TruncMonth('date'))
        .values('month')
        .annotate(count=Count('id'))
        .order_by('month')
    )
    
    # === Biểu đồ cột: Công việc chăm sóc ===
    action_data = list(
        MaintenanceLog.objects.values('action')
        .annotate(count=Count('id'))
        .order_by('-count')
    )
    
    return render(request, 'dashboard.html', {
        'species_labels': json.dumps([d['species__name'] for d in species_data]),
        'species_counts': json.dumps([d['count'] for d in species_data]),
        'status_labels': json.dumps([d['status'] for d in status_data]),
        'status_counts': json.dumps([d['count'] for d in status_data]),
        'month_labels': json.dumps([d['month'].strftime('%m/%Y') for d in monthly_data]),
        'month_counts': json.dumps([d['count'] for d in monthly_data]),
    })
```

---

## 💾 Export CSV

```python
def export_trees_csv(request):
    """Xuất danh sách cây thành CSV"""
    response = HttpResponse(content_type='text/csv; charset=utf-8-sig')
    response['Content-Disposition'] = 'attachment; filename="danh_sach_cay.csv"'
    
    writer = csv.writer(response)
    writer.writerow(['Mã', 'Loài', 'Chiều cao', 'Trạng thái', 'Vĩ độ', 'Kinh độ', 'Địa chỉ'])
    
    for tree in UrbanTree.objects.select_related('species').order_by('code'):
        writer.writerow([
            tree.code,
            tree.species.name,
            tree.height,
            tree.get_status_display(),
            tree.latitude,
            tree.longitude,
            tree.address
        ])
    
    return response
```

**File output:**
```csv
Mã,Loài,Chiều cao,Trạng thái,Vĩ độ,Kinh độ,Địa chỉ
T001,Xoan Tía,5.5,Tốt,21.0285,105.8542,123 Nguyễn Huệ
T002,Sao Đen,4.2,Sâu bệnh,21.0290,105.8550,45 Lý Thái Tổ
T003,Phi Lao,6.0,Tốt,21.0295,105.8560,67 Phan Bội Châu
```

---

## ⚙️ API Bulk Maintenance

```python
@login_required
@require_POST
def bulk_maintenance_view(request):
    """API: Chăm sóc hàng loạt cho nhiều cây"""
    try:
        data = json.loads(request.body)
        tree_ids = data.get('tree_ids', [])
        performer = data.get('performer')
        action = data.get('action')
        maintenance_date = data.get('date')
        note = data.get('note', '')
        
        if not tree_ids or not performer or not action:
            return JsonResponse({'error': 'Missing required fields'}, status=400)
        
        logs = []
        for tree_id in tree_ids:
            tree = UrbanTree.objects.get(id=tree_id)
            
            log = MaintenanceLog.objects.create(
                tree=tree,
                date=maintenance_date,
                action=action,
                performer=performer,
                note=note
            )
            
            # Cập nhật status nếu cần
            if action == 'PHUN_THUOC':
                tree.status = 'TOT'
            elif action == 'KIEM_TRA':
                tree.status = 'TOT'
            tree.save()
            
            logs.append(log)
        
        # Ghi nhật ký
        log_activity(
            request,
            'BULK_MAINTENANCE',
            'TREE',
            entity_code=f'{len(tree_ids)} cây',
            detail=f'Chăm sóc hàng loạt: {action}'
        )
        
        return JsonResponse({
            'status': 'ok',
            'count': len(logs),
            'message': f'✓ Thêm chăm sóc cho {len(logs)} cây'
        })
    
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON'}, status=400)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
```

**Yêu cầu POST:**
```json
{
  "tree_ids": [1, 2, 3, 4, 5],
  "performer": "Đội Thủy Lợi",
  "action": "PHUN_THUOC",
  "date": "2024-01-15",
  "note": "Phun thuốc diệt sâu bảo vệ định kỳ hàng tháng"
}
```

**Phản hồi:**
```json
{
  "status": "ok",
  "count": 5,
  "message": "✓ Thêm chăm sóc cho 5 cây"
}
```

---

## 👥 Quản Lý Người Dùng & Admin

```python
@admin_required
def admin_users_view(request):
    """Quản lý tài khoản người dùng"""
    from django.contrib.auth.models import User
    
    # Xử lý tạo user mới
    if request.method == 'POST' and 'create_user' in request.POST:
        username = request.POST.get('username')
        email = request.POST.get('email')
        is_admin = 'is_admin' in request.POST
        
        try:
            user = User.objects.create_user(
                username=username,
                email=email,
                is_staff=is_admin
            )
            log_activity(
                request,
                'ADD_USER',
                'USER',
                entity_code=username,
                detail=f'Thêm user {username} ({"Admin" if is_admin else "User"})'
            )
            return redirect('admin_users')
        except Exception as e:
            print(f'❌ Lỗi: {e}')
    
    # Xử lý xóa user
    if request.method == 'POST' and 'delete_user' in request.POST:
        user_id = request.POST.get('user_id')
        user = User.objects.get(id=user_id)
        username = user.username
        
        log_activity(
            request,
            'DELETE_USER',
            'USER',
            entity_code=username,
            detail=f'Xóa user {username}'
        )
        user.delete()
    
    # Hiển thị danh sách
    users = User.objects.all().order_by('-date_joined')
    
    context = {
        'users': users,
        'total_users': User.objects.count(),
        'admin_users': User.objects.filter(is_staff=True).count(),
        'regular_users': User.objects.filter(is_staff=False).count(),
    }
    
    return render(request, 'admin_users.html', context)
```

---

## 📝 Xem Nhật Ký Hoạt Động

```python
@admin_required
def admin_activity_view(request):
    """Xem toàn bộ hoạt động hệ thống"""
    q = request.GET.get('q', '').strip()
    action_filter = request.GET.get('action', '').strip()

    logs = ActivityLog.objects.select_related('user').order_by('-created_at')

    if q:
        logs = logs.filter(
            Q(entity_code__icontains=q) |
            Q(user__username__icontains=q)
        )

    if action_filter:
        logs = logs.filter(action_type=action_filter)

    paginator = Paginator(logs, 20)
    page_obj = paginator.get_page(request.GET.get('page'))

    return render(request, 'admin_activity.html', {
        'page_obj': page_obj,
        'action_choices': ActivityLog.ACTION_CHOICES,
    })
```

---

# 🎯 TÓM TẮT

| Model | Tác Dụng | Ví Dụ |
|-------|---------|-------|
| **TreeSpecies** | Loài cây + đặc tính AI | "Xoan Tía" - dễ sâu bệnh, tưới 7 ngày |
| **UrbanTree** | Mỗi cây trồng thực tế | T001 - Xoan Tía tại 21.0285°N |
| **MaintenanceLog** | Lịch sử chăm sóc | T001 tưới nước ngày 2024-01-15 |
| **ManagementZone** | Phân vùng quản lý | "Khu Tây" - GeoJSON polygon |
| **ActivityLog** | Audit trail hệ thống | Admin thêm cây T001 lúc 10:30 |

**Đặc điểm:**
- ✅ GIS-enabled (latitude/longitude)
- ✅ AI đề xuất bảo trì tự động
- ✅ Bulk operations (hàng loạt)
- ✅ CSV export
- ✅ Audit trail đầy đủ
- ✅ Quản lý multi-user

