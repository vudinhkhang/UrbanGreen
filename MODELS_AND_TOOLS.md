# UrbanGreen - Tài Liệu Model và Tool

**Dự án**: Hệ thống Quản lý Cây Xanh Đô Thị (Smart Urban Forestry Solutions)  
**Ngôn ngữ**: Python (Django Framework)  
**Cơ sở dữ liệu**: PostgreSQL  
**Ngày tạo**: 2026

---

## Mục Lục
1. [Các Model (Models) Python](#các-model-python)
2. [Các Tool và Thư Viện Sử Dụng](#các-tool-và-thư-viện-sử-dụng)
3. [Cấu Trúc Cơ Sở Dữ Liệu](#cấu-trúc-cơ-sở-dữ-liệu)
4. [Cấu Hình và Thiết Lập](#cấu-hình-và-thiết-lập)

---

## Các Model (Models) Python

Toàn bộ các model trong ứng dụng được định nghĩa trong file `public_map/models.py`. Dưới đây là chi tiết từng model:

### 1. **TreeSpecies** - Loại Cây Xanh

**Mục đích**: Lưu trữ thông tin về các loại/giống cây khác nhau

**Các trường dữ liệu**:

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| `name` | CharField (100) | Tên loài cây |
| `characteristics` | TextField | Đặc tính, tính chất của loài |
| `is_pest_prone` | BooleanField | Đánh dấu nếu loài dễ sâu bệnh |
| `is_fall_prone` | BooleanField | Đánh dấu nếu loài dễ đổ/gãy |
| `is_fast_growing` | BooleanField | Đánh dấu nếu mọc nhanh (cần cắt tỉa) |
| `is_drought_sensitive` | BooleanField | Đánh dấu nếu nhạy cảm với hạn hán |
| `is_invasive_roots` | BooleanField | Đánh dấu nếu rễ có khả năng xâm lấn |
| `watering_frequency_days` | PositiveIntegerField | Chu kỳ tưới nước (tính bằng ngày) |
| `inspection_frequency_days` | PositiveIntegerField | Chu kỳ kiểm tra (tính bằng ngày) |

**Ví dụ sử dụng**:
```python
species = TreeSpecies.objects.create(
    name="Sao Đen",
    characteristics="Cây lâu năm, chịu hạn tốt",
    is_pest_prone=False,
    is_fast_growing=True,
    watering_frequency_days=7,
    inspection_frequency_days=90
)
```

---

### 2. **UrbanTree** - Cây Xanh Đô Thị

**Mục đích**: Lưu trữ thông tin chi tiết về từng cây xanh riêng lẻ trên thành phố

**Các trường dữ liệu**:

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| `species` | ForeignKey | Liên kết tới TreeSpecies (loài cây) |
| `code` | CharField (20, unique) | Mã định danh duy nhất cho cây |
| `height` | FloatField | Chiều cao cây (tính bằng mét) |
| `status` | CharField | Trạng thái cây: `TOT` (Tốt), `SAU_BENH` (Sâu bệnh), `NGUY_HIEM` (Nguy hiểm) |
| `latitude` | FloatField | Vĩ độ (Y) - tọa độ GPS |
| `longitude` | FloatField | Kinh độ (X) - tọa độ GPS |
| `address` | CharField (200) | Địa chỉ cây (tùy chọn) |
| `image` | ImageField | Hình ảnh đại diện của cây (tùy chọn) |

**Quan hệ (Relations)**:
- **Một-nhiều** với `MaintenanceLog`: Một cây có nhiều lần chăm sóc
- **Một-nhiều** với `TreeImage`: Một cây có thể có nhiều ảnh

**Ví dụ sử dụng**:
```python
tree = UrbanTree.objects.create(
    species=species,  # Loài cây
    code="T001",
    height=8.5,
    status="TOT",
    latitude=10.7769,
    longitude=106.7009,
    address="Quận Bình Thạnh, TP.HCM"
)
```

---

### 3. **TreeImage** - Hình Ảnh Cây

**Mục đích**: Lưu trữ nhiều hình ảnh cho mỗi cây (hỗ trợ thư viện ảnh)

**Các trường dữ liệu**:

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| `tree` | ForeignKey | Liên kết tới UrbanTree (cây chứa ảnh này) |
| `image` | ImageField | File ảnh (được lưu trong thư mục `tree_images/`) |
| `caption` | CharField (200) | Mô tả/chú thích cho ảnh (tùy chọn) |
| `uploaded_at` | DateTimeField | Ngày giờ tải ảnh lên (auto) |

**Các phương thức**:

| Phương thức | Mô tả |
|-------------|-------|
| `get_image_url()` | Lấy URL của ảnh (an toàn nếu không tồn tại ảnh) |
| `image_exists()` | Kiểm tra xem file ảnh có tồn tại thực sự không |

**Ví dụ sử dụng**:
```python
# Tải ảnh cho cây
image = TreeImage.objects.create(
    tree=tree,
    image=uploaded_file,
    caption="Ảnh cây vào tháng 1"
)

# Kiểm tra ảnh có tồn tại không
if image.image_exists():
    print(image.get_image_url())
```

---

### 4. **MaintenanceLog** - Lịch Sử Chăm Sóc

**Mục đích**: Ghi lại tất cả các hoạt động chăm sóc, bảo dưỡng cây

**Các trường dữ liệu**:

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| `tree` | ForeignKey | Liên kết tới UrbanTree (cây được chăm sóc) |
| `date` | DateField | Ngày thực hiện chăm sóc |
| `action` | CharField | Loại công việc: `CAT_TIA` (Cắt tỉa), `BON_PHAN` (Bón phân), `PHUN_THUOC` (Phun thuốc), `KIEM_TRA` (Kiểm tra), `TUOI_NUOC` (Tưới nước) |
| `performer` | CharField (100) | Tên người thực hiện công việc |
| `note` | TextField | Ghi chú/Kết quả công việc (tùy chọn) |

**Ví dụ sử dụng**:
```python
maintenance = MaintenanceLog.objects.create(
    tree=tree,
    date=date.today(),
    action="CAT_TIA",
    performer="Nguyễn Văn A",
    note="Cắt tỉa cành thấp, cây khỏe đẹp"
)
```

---

### 5. **ManagementZone** - Vùng Quản Lý

**Mục đích**: Định nghĩa các khu vực/vùng quản lý khác nhau trên bản đồ (GIS)

**Các trường dữ liệu**:

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| `name` | CharField (100) | Tên vùng quản lý |
| `color` | CharField (7) | Mã màu hex để hiển thị (mặc định: `#1abc9c`) |
| `polygon_json` | TextField | Dữ liệu GeoJSON định nghĩa ranh giới vùng |
| `created_at` | DateTimeField | Thời gian tạo vùng (auto) |

**Ví dụ sử dụng**:
```python
zone = ManagementZone.objects.create(
    name="Vùng Quận 1",
    color="#FF5733",
    polygon_json='{"type":"Polygon","coordinates":[[[...],[...],...]]}'
)
```

---

### 6. **ActivityLog** - Nhật Ký Hoạt Động Hệ Thống

**Mục đích**: Ghi lại tất cả hoạt động của người dùng (audit log) để theo dõi và kiểm soát

**Các trường dữ liệu**:

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| `user` | ForeignKey | Liên kết tới User (người thực hiện) |
| `action_type` | CharField | Loại hành động: `ADD_TREE`, `EDIT_TREE`, `DELETE_TREE`, `ADD_SPECIES`, `EDIT_SPECIES`, `DELETE_SPECIES`, `ADD_MAINTENANCE`, `BULK_MAINTENANCE`, `UPLOAD_IMAGE`, `DELETE_IMAGE` |
| `entity_type` | CharField | Kiểu đối tượng bị ảnh hưởng (ví dụ: "TREE", "SPECIES") |
| `entity_code` | CharField (120) | Mã hoặc tên của đối tượng |
| `detail` | TextField | Chi tiết chuyên sâu về hành động |
| `created_at` | DateTimeField | Thời gian thực hiện hành động (auto) |

**Các tùy chọn hành động** (`ACTION_CHOICES`):
- `ADD_TREE` - Thêm cây
- `EDIT_TREE` - Sửa cây
- `DELETE_TREE` - Xóa cây
- `ADD_SPECIES` - Thêm loài
- `EDIT_SPECIES` - Sửa loài
- `DELETE_SPECIES` - Xóa loài
- `ADD_MAINTENANCE` - Thêm chăm sóc
- `BULK_MAINTENANCE` - Chăm sóc hàng loạt
- `UPLOAD_IMAGE` - Cập nhật ảnh
- `DELETE_IMAGE` - Xóa ảnh

**Ví dụ sử dụng**:
```python
log = ActivityLog.objects.create(
    user=request.user,
    action_type="EDIT_TREE",
    entity_type="TREE",
    entity_code="T001",
    detail="Cập nhật trạng thái cây từ TOT sang SAU_BENH"
)
```

---

## Các Tool và Thư Viện Sử Dụng

### Backend Framework

#### **1. Django 6.0.2**
- **Mục đích**: Web framework chính
- **Các tính năng sử dụng**:
  - **ORM (Object-Relational Mapping)**: Tương tác với cơ sở dữ liệu
  - **Admin Interface**: Giao diện quản lý tự động
  - **Authentication & Authorization**: Xác thực và phân quyền người dùng
  - **Template System**: Rendering HTML templates
  - **Form Handling**: Xử lý form dữ liệu
  - **URL Routing**: Định tuyến URL
  - **Middleware**: Xử lý request/response
  - **Signals**: Kích hoạt hành động tự động
  - **Management Commands**: Lệnh CLI tùy chỉnh

**File liên quan**: 
- `UrbanGreen/settings.py` - Cấu hình chính
- `UrbanGreen/urls.py` - Định tuyến URL
- `public_map/views.py` - View logic
- `public_map/models.py` - Định nghĩa model

---

#### **2. PostgreSQL**
- **Mục đích**: Cơ sở dữ liệu chính (relational database)
- **Cấu hình**: 
  - Host: `127.0.0.1` (hoặc từ biến môi trường)
  - Port: `5432`
  - Database: `urbangreen_db`
  - User: `urbangreen_user`
- **Lợi thế**: 
  - Hỗ trợ JSON/GeoJSON tốt (cho dữ liệu GIS)
  - PostGIS extension cho xử lý địa lý
  - Full-text search
  - ACID compliance

**Cấu hình trong**: `UrbanGreen/settings.py` (dòng DATABASES)

---

### Image Handling

#### **3. Pillow**
- **Mục đích**: Xử lý và quản lý hình ảnh
- **Tính năng sử dụng**:
  - `ImageField` trong Django models
  - Tối ưu hóa kích thước ảnh
  - Xử lý định dạng ảnh khác nhau (JPG, PNG, etc.)
- **Thư mục lưu ảnh**: `media/tree_images/`
- **Truy cập ảnh**: `/media/tree_images/[filename]`

**Sử dụng trong**:
- Model `UrbanTree.image`
- Model `TreeImage.image`
- Command: `public_map/management/commands/verify_tree_images.py` (kiểm tra ảnh)

---

#### **4. Django Storage (default_storage)**
- **Mục đích**: Quản lý lưu trữ file (local hoặc cloud)
- **Các phương thức chính**:
  - `exists(filename)` - Kiểm tra file có tồn tại
  - `delete(filename)` - Xóa file
  - `save(name, content)` - Lưu file

**Sử dụng trong**:
- `TreeImage.image_exists()` - Kiểm tra ảnh có tồn tại
- `verify_tree_images.py` - Xác thực file ảnh
- `tree_detail_view()` - Xóa ảnh

---

### Database Operations

#### **5. Django ORM (Object-Relational Mapping)**
- **Mục đích**: Quản lý tương tác với cơ sở dữ liệu
- **Các phương pháp chính**:
  - `QuerySet.filter()` - Lọc dữ liệu
  - `QuerySet.select_related()` - Tối ưu JOIN (1 cấp)
  - `QuerySet.prefetch_related()` - Tối ưu multiple queries
  - `QuerySet.order_by()` - Sắp xếp
  - `QuerySet.count()` - Đếm
  - `Paginator` - Phân trang
  - `Q objects` - Truy vấn phức tạp (AND/OR)

**Ví dụ sử dụng**:
```python
from django.db.models import Q

# Tìm cây theo tên loài hoặc mã
trees = UrbanTree.objects.filter(
    Q(species__name__icontains='Sao') | Q(code__icontains='T0')
).select_related('species')

# Lấy cây cùng với toàn bộ ảnh
tree = UrbanTree.objects.prefetch_related('images').get(id=1)
```

---

### Authentication & Authorization

#### **6. Django Authentication System**
- **Mục đích**: Xác thực và phân quyền người dùng
- **Các decorator sử dụng**:
  - `@login_required` - Yêu cầu đăng nhập
  - `@admin_required` - Yêu cầu quyền staff/admin
  - `@csrf_protect` - Bảo vệ CSRF attack
  - `@require_POST` - Chỉ chấp nhận POST request

**Ví dụ**:
```python
from django.contrib.auth.decorators import login_required

@login_required
def tree_detail_view(request, tree_id):
    # Chỉ user đã đăng nhập mới có thể truy cập
    pass
```

**Custom decorator**:
```python
def admin_required(view_func):
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        if not request.user.is_staff:
            return JsonResponse({'status': 'error'}, status=403)
        return view_func(request, *args, **kwargs)
    return _wrapped_view
```

---

#### **7. CSRF Protection (Cross-Site Request Forgery)**
- **Mục đích**: Bảo vệ chống tấn công CSRF
- **Decorator sử dụng**:
  - `@ensure_csrf_cookie` - Đảm bảo CSRF token được gửi
  - `@csrf_protect` - Bảo vệ view
  - `@csrf_exempt` - Bỏ qua bảo vệ (nếu cần)
- **Middleware**: `RelaxNullOriginInDebugMiddleware` - Cho phép Origin: null trong DEBUG mode

**Middleware tùy chỉnh** (`public_map/middleware.py`):
```python
class RelaxNullOriginInDebugMiddleware:
    """Cho phép webview gửi Origin: null trong DEBUG mode"""
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if settings.DEBUG and request.META.get("HTTP_ORIGIN") == "null":
            request.META.pop("HTTP_ORIGIN", None)
        return self.get_response(request)
```

---

### Data Handling

#### **8. JSON (json module)**
- **Mục đích**: Xử lý dữ liệu JSON (trao đổi dữ liệu với frontend)
- **Sử dụng chính**:
  ```python
  import json
  
  # Chuyển dữ liệu Python thành JSON
  tree_json = json.dumps(tree_list)
  
  # Parse dữ liệu JSON
  locations = json.loads(request.POST.get('locations', '[]'))
  ```
- **Trường hợp sử dụng**:
  - GeoJSON cho bản đồ (tọa độ cây)
  - Polygon cho vùng quản lý
  - API responses

---

#### **9. CSV Export**
- **Mục đích**: Xuất dữ liệu ra file CSV
- **Module**: `csv` module của Python
- **Views liên quan**:
  - `export_trees_csv()` - Xuất danh sách cây
  - `export_maintenance_csv()` - Xuất lịch sử chăm sóc

**Ví dụ**:
```python
import csv
from django.http import HttpResponse

def export_trees_csv(request):
    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="trees.csv"'
    
    writer = csv.writer(response)
    writer.writerow(['Mã cây', 'Loài', 'Trạng thái', 'Chiều cao'])
    
    for tree in UrbanTree.objects.all():
        writer.writerow([tree.code, tree.species.name, tree.status, tree.height])
    
    return response
```

---

### Utilities

#### **10. Paginator (Phân trang)**
- **Mục đích**: Chia dữ liệu thành nhiều trang
- **Sử dụng**:
  ```python
  from django.core.paginator import Paginator
  
  paginator = Paginator(trees, 15)  # 15 cây/trang
  page_number = request.GET.get('page')
  page_obj = paginator.get_page(page_number)
  ```
- **Nơi sử dụng**: `tree_list_view()`, `species_list_view()`

---

#### **11. datetime & date (Xử lý thời gian)**
- **Mục đích**: Quản lý ngày tháng, thời gian
- **Sử dụng**:
  ```python
  from datetime import datetime, date, timedelta
  from django.utils import timezone
  
  today = date.today()
  now = timezone.now()
  ```
- **Nơi sử dụng**: Form mặc định ngày, tính chu kỳ chăm sóc

---

#### **12. Validators (Xác thực dữ liệu)**
- **Mục đích**: Kiểm tra tính hợp lệ của dữ liệu
- **Sử dụng**:
  ```python
  from django.contrib.auth.password_validation import validate_password
  from django.core.validators import validate_email
  from django.core.exceptions import ValidationError
  
  try:
      validate_email(email)
      validate_password(password)
  except ValidationError as e:
      # Xử lý lỗi
      pass
  ```

---

### API & Frontend

#### **13. JsonResponse**
- **Mục đích**: Trả về response JSON từ views
- **Sử dụng**:
  ```python
  from django.http import JsonResponse
  
  return JsonResponse({
      'status': 'success',
      'message': 'Cập nhật thành công',
      'data': tree_data
  })
  ```
- **Nơi sử dụng**: API endpoints, AJAX handlers

---

#### **14. Django Templates (Template System)**
- **Mục đích**: Render HTML pages
- **Template engine**: Django Template Language (DTL)
- **Template tags tùy chỉnh** (`public_map/templatetags/image_tags.py`):
  - `@register.filter` - Custom filter
  - `@register.simple_tag` - Custom tag
  
**Ví dụ**:
```python
@register.filter
def debug_image_path(image_field):
    if not image_field:
        return "❌ No image"
    return f"✅ {image_field.name}"

@register.simple_tag
def get_media_root():
    return settings.MEDIA_ROOT
```

---

### Management Commands

#### **15. Django Management Commands**
- **Mục đích**: Tạo lệnh CLI tùy chỉnh
- **Command**: `verify_tree_images.py`
  - **Chức năng**: Kiểm tra toàn bộ ảnh cây có tồn tại không
  - **Sử dụng**: `python manage.py verify_tree_images [--fix]`
  - **Tùy chọn**: `--fix` để xóa bỏ các bản ghi ảnh bị hỏng

---

### Form Handling

#### **16. Django Forms & Validation**
- **Mục đích**: Xài xử lý và xác thực form dữ liệu
- **Các phương pháp**:
  - `request.POST.get()` - Lấy dữ liệu POST
  - `request.FILES.getlist()` - Lấy nhiều file upload
  - `request.POST.getlist()` - Lấy nhiều giá trị checkbox
  
**Ví dụ**:
```python
# Lấy form data
species_id = request.POST.get('species')
code = request.POST.get('code', '').strip()
tree_images = request.FILES.getlist('image')
statuses = request.POST.getlist('statuses')

# Validate dữ liệu
if not all([species_id, code]):
    messages.error(request, 'Vui lòng điền đầy đủ thông tin')
```

---

#### **17. Django Messages Framework**
- **Mục đích**: Hiển thị thông báo cho người dùng
- **Cấp độ**: `success`, `error`, `warning`, `info`
- **Sử dụng**:
  ```python
  from django.contrib import messages
  
  messages.success(request, '✅ Cập nhật thành công!')
  messages.error(request, '❌ Có lỗi xảy ra!')
  ```

---

## Cấu Trúc Cơ Sở Dữ Liệu

### Sơ đồ Quan Hệ (ER Diagram)

```
TreeSpecies (1)
    ↓
    ↓ (1:N)
    ↓
UrbanTree (N)
    ↓
    ├── (1:N) → MaintenanceLog
    ├── (1:N) → TreeImage
    │
    └── (ForeignKey to User.auth)


ActivityLog ← (ForeignKey to User.auth)

ManagementZone (Độc lập - Vùng đơn)
```

### Mối Quan Hệ Chi Tiết

| Bảng | Quan Hệ | Bảng Khác | Mô Tả |
|------|---------|-----------|-------|
| UrbanTree | 1:N | MaintenanceLog | Một cây có nhiều lần chăm sóc |
| UrbanTree | 1:N | TreeImage | Một cây có nhiều ảnh |
| UrbanTree | N:1 | TreeSpecies | Nhiều cây cùng một loài |
| ActivityLog | N:1 | User (auth) | Nhiều hành động cùng một user |
| MaintenanceLog | N:1 | UrbanTree | Mỗi chăm sóc liên kết một cây |
| TreeImage | N:1 | UrbanTree | Mỗi ảnh liên kết một cây |

---

## Cấu Hình và Thiết Lập

### 1. **Environment Variables (.env file)**

```ini
# Database
POSTGRES_DB=urbangreen_db
POSTGRES_USER=urbangreen_user
POSTGRES_PASSWORD=your_secure_password
POSTGRES_HOST=127.0.0.1
POSTGRES_PORT=5432
POSTGRES_CONN_MAX_AGE=60

# Django
SECRET_KEY=your_django_secret_key_here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1,yourdomain.com
```

---

### 2. **Django Settings (UrbanGreen/settings.py)**

**Các cấu hình quan trọng**:

```python
# Cơ sở dữ liệu
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'urbangreen_db',
        'USER': 'urbangreen_user',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}

# Ứng dụng đã cài đặt
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'public_map',  # Ứng dụng chính
]

# Middleware
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'public_map.middleware.RelaxNullOriginInDebugMiddleware',  # Tùy chỉnh
    'django.middleware.csrf.CsrfViewMiddleware',
    # ... các middleware khác
]

# Media Files (Ảnh upload)
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# Múi giờ
TIME_ZONE = "Asia/Ho_Chi_Minh"
```

---

### 3. **URL Configuration (UrbanGreen/urls.py)**

**Routes chính**:

| URL | View | Chức Năng |
|-----|------|----------|
| `/` | `home_view` | Trang chủ/Dashboard |
| `/about/` | `about_view` | Giới thiệu (công khai) |
| `/login/` | Django LoginView | Đăng nhập |
| `/logout/` | `custom_logout_view` | Đăng xuất |
| `/map/` | `map_view` | Bản đồ cây |
| `/tree/<id>/` | `tree_detail_view` | Chi tiết cây |
| `/trees/` | `tree_list_view` | Danh sách cây |
| `/tree/add/` | `tree_add_view` | Thêm cây mới |
| `/tree/<id>/delete/` | `tree_delete_view` | Xóa cây |
| `/species/` | `species_list_view` | Danh sách loài |
| `/species/add/` | `species_add_view` | Thêm loài |
| `/dashboard/` | `dashboard_view` | Dashboard chi tiết |
| `/admin-panel/` | `admin_dashboard_view` | Bảng điều khiển admin |
| `/admin-users/` | `admin_users_view` | Quản lý người dùng |
| `/admin-activities/` | `admin_activity_view` | Nhật ký hoạt động |
| `/export/trees/` | `export_trees_csv` | Xuất CSV cây |
| `/export/maintenance/` | `export_maintenance_csv` | Xuất CSV chăm sóc |

---

### 4. **Migrations (Schema Management)**

**Các migration có sẵn**:

```
0001_initial.py              → TreeSpecies, UrbanTree
0002_urbantree_image.py      → Thêm trường image vào UrbanTree
0003_maintenancelog.py       → MaintenanceLog model
0004_treespecies_...         → Thêm các trường AI-related
0005_treespecies_is_...      → Thêm trường drought_sensitive
0006_managementzone.py       → ManagementZone model
0007_activitylog.py          → ActivityLog model
0008_treeimage.py            → TreeImage model (hỗ trợ nhiều ảnh)
```

**Chạy migrations**:
```bash
python manage.py migrate
```

---

## Tóm Tắt Công Nghệ Stack

### Backend
- **Framework**: Django 6.0.2 (Python)
- **Database**: PostgreSQL
- **API Format**: JSON/REST API
- **Authentication**: Django Built-in + Custom Decorators

### Frontend
- **Template Engine**: Django Templates (DTL)
- **JavaScript**: Vanilla JS, Leaflet.js (bản đồ)
- **CSS**: Custom CSS + Admin styles

### DevOps/Tools
- **Image Processing**: Pillow
- **Environment Management**: Python dotenv (.env)
- **Version Control**: Git

### Security
- **CSRF Protection**: Django CSRF middleware
- **SQL Injection**: Django ORM (parameterized queries)
- **Authentication**: Django User model
- **Permission**: Django Groups & Permissions + Custom @admin_required

---

## Các Views Chính và Chức Năng

### Trang Công Khai
1. **`/about/`** - Giới thiệu ứng dụng (không cần login)

### Trang Yêu Cầu Đăng Nhập
2. **`/`** - Trang chủ, thống kê tổng quan
3. **`/map/`** - Bản đồ tương tác cây
4. **`/trees/`** - Danh sách cây (có phân trang)
5. **`/tree/<id>/`** - Chi tiết cây + chăm sóc + ảnh
6. **`/tree/add/`** - Thêm cây (hỗ trợ multiple locations + images)
7. **`/species/`** - Danh sách loài cây

### Trang Admin
8. **`/admin-panel/`** - Dashboard quản lý (yêu cầu is_staff)
9. **`/admin-users/`** - Quản lý người dùng
10. **`/admin-activities/`** - Xem nhật ký hoạt động

---

## Một Số Đặc Điểm Nổi Bật

✅ **Hỗ trợ nhiều ảnh cho mỗi cây** - Model TreeImage tách biệt  
✅ **GIS Integration** - Lưu tọa độ (latitude/longitude) và GeoJSON polygon  
✅ **Audit Logging** - ActivityLog ghi lại mọi thay đổi  
✅ **Export Data** - Xuất CSV cho báo cáo  
✅ **Bulk Operations** - Thêm nhiều cây cùng lúc từ bản đồ  
✅ **Image Verification** - Management command kiểm tra ảnh  
✅ **Responsive Design** - Admin dashboard mobile-friendly  
✅ **Role-based Access** - Phân quyền admin vs user thường

---

**Tài liệu này được cập nhật lần cuối: 2026-04-08**
