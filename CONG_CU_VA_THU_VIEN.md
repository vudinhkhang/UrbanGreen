# 🛠️ CÁC CÔNG CỤ & THƯ VIỆN ĐƯỢC SỬ DỤNG TRONG URBANGRE EN

**Dự án:** UrbanGreen - Hệ Thống Quản Lý Cây Xanh Đô Thị  
**Ngôn ngữ:** Python 3.14.x + JavaScript (ES6+)  
**Framework Backend:** Django 6.0.2  
**Cơ Sở Dữ Liệu:** PostgreSQL  
**Ngày cập nhật:** 1 Tháng 4, 2026  

---

## 📑 Mục Lục

1. [Ngăn Xếp Frontend](#frontend-stack)
2. [Ngăn Xếp Backend](#backend-stack)
3. [Công Nghệ GIS & Không Gian](#gis--spatial-technologies)
4. [Gói Python](#python-packages)
5. [Cấu Trúc Dự Án](#project-structure)
6. [Điểm Cuối API](#api-endpoints)
7. [Công Cụ Phát Triển](#development-tools)
8. [Ngăn Xếp Triển Khai](#deployment--scaling)

---

# NGĂN XẾP FRONTEND

## Giao Diện & Kiểu Dáng

| 📦 Công Cụ | 📌 Phiên Bản | 🎯 Danh Mục | 📝 Mô Tả |
|---------|-----------|-----------|--------------|
| **Bootstrap** | 5.1.3 | Framework Frontend | Lưới responsive, thành phần, tiện ích CSS |
| **Open Sans** | Latest | Phông Chữ Web | Kiểu chữ chuyên nghiệp |
| **FontAwesome** | 6.0.0 | Thư Viện Biểu Tượng | 2000+ biểu tượng SVG (dashboard, biểu tượng bản đồ) |

**CDN:**
```html
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500;700&display=swap" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
```

---

## Thư Viện GIS & Bản Đồ

| 📦 Công Cụ | 📌 Phiên Bản | 🎯 Danh Mục | 📝 Mục Đích | 📌 CDN |
|---------|-----------|-----------|-----------|--------|
| **Leaflet.js** | 1.7.1 | Framework Bản Đồ | Thư viện bản đồ cốt lõi (điểm đánh dấu, ô, cửa sổ bật lên) | jsDelivr |
| **Leaflet.heat** | 0.2.0 | Lớp Bản Đồ Nhiệt | Hiển thị phân bố cường độ cây | jsDelivr |
| **Leaflet.markercluster** | 1.5.3 | Gom Cụm Điểm Đánh Dấu | Nhóm các điểm gần nhau khi phóng to bản đồ | jsDelivr |

**CDN:**
```html
<link href="https://cdn.jsdelivr.net/npm/leaflet@1.7.1/dist/leaflet.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/leaflet@1.7.1/dist/leaflet.js"></script>
<script src="https://cdn.jsdelivr.net/npm/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>
<script src="https://cdn.jsdelivr.net/npm/leaflet.markercluster@1.5.3/dist/leaflet.markercluster.js"></script>
```

---

## Trực Quan Hóa Dữ Liệu

| 📦 Công Cụ | 📌 Phiên Bản | 📝 Mục Đích |
|---------|-----------|-----------|
| **Chart.js** | Latest | Hiển thị biểu đồ tương tác (đường, cột, tròn) - Bảng Điều Khiển Admin |
| **Geolocation API** | Native | Lấy vị trí GPS của người dùng (để định tuyến tự động) |

---

## API Bên Ngoài

| 📦 Dịch Vụ | 📝 Mục Đích | 🔗 Điểm Cuối |
|---------|-----------|-----------|
| **Nominatim** | Định địa chỉ miễn phí (địa chỉ → vĩ độ/kinh độ) | https://nominatim.openstreetmap.org/ |
| **OSRM** | Động cơ định tuyến miễn phí (đường đi ngắn nhất) | https://router.project-osrm.org/ |

---

## Tiện Ích JavaScript

| 📦 Tiện Ích | 📝 Mục Đích |
|---------|-----------|
| **Fetch API** | Yêu cầu HTTP hiện đại (thay thế XMLHttpRequest) |
| **Công Thức Haversine** | Tính khoảng cách GPS giữa 2 điểm |
| **Trình Phân Tích GeoJSON** | Phân tích các tính năng địa lý (đa giác, điểm đánh dấu) |

---

# NGĂN XẾP BACKEND

## 🔵 Framework Cốt Lõi & Ngôn Ngữ

| 📦 Công Cụ | 📌 Phiên Bản | 🎯 Danh Mục | 📝 Mô Tả |
|---------|-----------|-----------|--------------|
| **Django** | 6.0.2 | Framework Web | Định tuyến URL, chế độ xem, mẫu, xác thực |
| **Python** | 3.14.x | Ngôn Ngữ | Logic backend, xử lý dữ liệu |

### Cơ Sở Dữ Liệu

| 📦 Công Cụ | 📌 Phiên Bản | 📝 Mục Đích |
|---------|-----------|-----------|
| **PostgreSQL** | Latest | DB Quan Hệ, truy vấn không gian, sản xuất |
| ~~SQLite3~~ | ~~N/A~~ | ~~KHÔNG ĐƯỢC SỬ DỤNG~~ |

### Trình Điều Khiển & ORM Cơ Sở Dữ Liệu

| 📦 Công Cụ | 📌 Phiên Bản | 📝 Mục Đích |
|---------|-----------|-----------|
| **psycopg2** | Latest | Bộ Chuyển Đổi PostgreSQL cho Python |
| **Django ORM** | Built-in | Lập Bản Đồ Đối Tượng-Quan Hệ (tạo SQL tự động) |

### Xử Lý Tệp

| 📦 Công Cụ | 📌 Phiên Bản | 📝 Mục Đích |
|---------|-----------|-----------|
| **Pillow** | Latest | Xử lý ảnh, thay đổi kích thước, xác nhận |

### Xác Thực & Bảo Mật

| 📦 Mô-đun | 📝 Mục Đích |
|---------|-----------|
| **django.contrib.auth** | Xác thực người dùng, quyền, nhóm |
| **Bảo Vệ CSRF** | Phòng chống giả mạo yêu cầu xuyên trang web |
| **Phiên** | Theo dõi người dùng có trạng thái trên các yêu cầu |

### Tiện Ích Django

| 📦 Mô-đun | 📝 Mục Đích |
|---------|-----------|
| **django.db.models** | Định nghĩa mô hình cơ sở dữ liệu & truy vấn |
| **django.http** | Phản hồi HTTP, JsonResponse, FileResponse |
| **django.shortcuts** | render(), redirect(), get_object_or_404() |
| **django.urls** | Mẫu URL, path(), re_path(), reverse() |
| **django.views** | Các lớp View (TemplateView, ListView, v.v.) |
| **django.contrib.messages** | Tin nhắn phản hồi của người dùng (thành công, lỗi, thông tin) |
| **django.core.decorators** | @login_required, @csrf_exempt |
| **django.forms** | Xây dựng & xác nhận biểu mẫu |
| **django.middleware** | Bộ chặn yêu cầu/phản hồi |
| **django.template** | Động cơ kết xuất Mẫu |
| **json.dumps() / loads()** | Tuần tự hóa JSON |
| **datetime, timezone** | Xử lý ngày tháng & múi giờ |

---

# CÔN CÔNG NĐE GIS & KHÔNG GIAN

## 🌍 Hệ Tọa Độ & Định Dạng

| 📦 Tiêu Chuẩn | 📝 Mục Đích |
|---------|-----------|
| **WGS84 (EPSG:4326)** | Tiêu chuẩn GPS (vĩ độ, kinh độ theo số thập phân) |
| **GeoJSON** | Định dạng vectơ cho các tính năng địa lý (đa giác, điểm đánh dấu) |

## 📖 Thuật Toán & Tính Toán

| 📦 Thuật Toán | 📝 Trường Hợp Sử Dụng |
|---------|-----------|
| **Công Thức Haversine** | Tính khoảng cách đường tròn lớn giữa 2 điểm GPS |
| **Truy Vấn Hộp Giới Hạn** | Tìm cây trong bán kính sử dụng các giới hạn vĩ độ/kinh độ |

---

# GÓI PYTHON

```python
Django==6.0.2
psycopg2-binary          # Bộ chuyển đổi PostgreSQL
Pillow                   # Xử lý ảnh  
djangorestframework      # Tùy chọn: REST API
python-dateutil          # Tiện ích ngày tháng
pytz                     # Xử lý múi giờ
```

---

# CẤU TRÚC DỰ ÁN

## 🗂️ Bố Cục Dự Án Django

### Các Tệp Cấu Hình Cốt Lõi

| 📄 Tệp | 📝 Mục Đích |
|---------|-----------|
| **settings.py** | Kết nối cơ sở dữ liệu, đường dẫn phương tiện, ứng dụng được cài đặt, cải đặt bảo mật |
| **urls.py** | Định tuyến URL (ánh xạ URL đến chế độ xem) |
| **wsgi.py** | Ứng dụng WSGI (điểm vào máy chủ sản xuất) |
| **asgi.py** | Ứng dụng ASGI (hỗ trợ không đồng bộ) |

### Tệp Ứng Dụng

| 📄 Tệp | 📝 Mục Đích |
|---------|-----------|
| **models.py** | 5 bảng cơ sở dữ liệu (TreeSpecies, UrbanTree, MaintenanceLog, ManagementZone, ActivityLog) |
| **views.py** | 25+ hàm chế độ xem (CRUD, GIS, admin, điểm cuối API) |
| **admin.py** | Cấu hình giao diện quản trị Django |
| **middleware.py** | Xử lý yêu cầu/phản hồi tùy chỉnh |
| **apps.py** | Cấu hình ứng dụng |

### Tệp Mẫu

| 📂 Thư Mục | 📝 Nội Dung |
|---------|-----------|
| **templates/** | 17+ mẫu HTML/CSS với Ngôn Ngữ Mẫu Django (DTL) |
| - base.html | Mẫu chính (header, footer, token thiết kế) |
| - map.html | Bản đồ GIS tương tác với Leaflet.js |
| - admin_dashboard.html | Bảng điều khiển số liệu admin |
| - index.html | Trang chủ (trang đích nhận thức vai trò) |

### Tài Sản Tĩnh

| 📂 Thư Mục | 📝 Nội Dung |
|---------|-----------|
| **static/css/** | admin_dashboard.css, admin_shell.css, user_profile.css |
| **media/tree_images/** | Hình ảnh cây được người dùng tải lên |

---

# ĐIỂM CUỐI API

## 🔗 Tuyến Đường API RESTful

### Quản Lý Cây (CRUD)

```
📍 GET    /map/
   Mục Đích: Lấy dữ liệu cây GeoJSON với tìm kiếm/lọc
   Trả Về: Mảng cây (id, code, species, status, lat, lon, image)

📍 GET    /tree/<id>/
   Mục Đích: Xem chi tiết cây riêng lẻ + lịch sử bảo trì
   Trả Về: Đối tượng cây với nhật ký và đề xuất bảo trì

📍 POST   /tree/add/
   Mục Đích: Tạo mục nhập cây mới
   Trường: code, species, height, status, latitude, longitude, address, image

📍 PUT    /tree/<id>/edit/
   Mục Đích: Cập nhật thông tin cây
   
📍 DELETE /tree/<id>/delete/
   Mục Đích: Xóa cây khỏi hệ thống
```

### Hoạt Động Bảo Trì

```
📍 POST   /api/bulk-maintenance/
   Mục Đích: Xử lý bảo trì hàng loạt cho nhiều cây
   Nội Dung: {
     tree_ids: [1, 2, 3],
     performer: "Nguyen Van A",
     action: "CAT_TIA|BON_PHAN|PHUN_THUOC|KIEM_TRA|TUOI_NUOC",
     date: "2024-01-15",
     note: "Ghi chú tùy chọn"
   }
   Phản Hồi: {status: "ok", count: 3}
```

### Bảng Điều Khiển & Báo Cáo

```
📍 GET    /maintenance-list/
   Mục Đích: Đề xuất bảo trì được hỗ trợ bởi AI
   Trả Về: Đề xuất được nhóm thông minh theo cây

📍 GET    /admin-dashboard/
   Mục Đích: Số liệu hệ thống và tổng quan quản trị
   Trả Về: Số lượng người dùng, thống kê cây, dữ liệu biểu đồ

📍 GET    /user-profile/
   Mục Đích: Bảng điều khiển người dùng cá nhân
   Trả Về: Thống kê hoạt động, thông tin hồ sơ

📍 GET    /export-trees/
   Mục Đích: Xuất dữ liệu cây dưới dạng CSV
   Trả Về: Tải xuống tệp CSV
```

---

# CÔNG CỤ PHÁT TRIỂN

## 🛠️ Phát Triển & Gỡ Lỗi

| 🛠️ Công Cụ | 📝 Mục Đích |
|---------|-----------|
| **Git** | Kiểm soát phiên bản (nhánh: dev, commit: f3ef8f7) |
| **GitHub** | Lưu trữ kho lưu trữ từ xa |
| **VS Code** | Trình biên tập mã với tích hợp Copilot |
| **Python venv** | Môi trường ảo (.venv/) |
| **Django Management CLI** | `python manage.py` (runserver, migrate, check) |
| **Browser DevTools** | Mạng, bảng điều khiển, kiểm tra phần tử |

---

## ✅ Thử Nghiệm & Xác Nhận

| 📊 Công Cụ | 📝 Mục Đích |
|---------|-----------|
| **Django test suite** | Kiểm tra đơn vị cho chế độ xem, mô hình, API |
| **django check** | Xác nhận hệ thống (0 vấn đề được phát hiện) |
| **Geolocation API** | Truy xuất vị trí GPS trình duyệt |

---

# TRIỂN KHAI & MỞ RỘNG QUY MÔ

## 📱 Thiết Kế Responsive

| 💻 Điểm Ngắt | 📏 Kích Thước Màn Hình | 🎯 Thiết Bị |
|---------|-----------|-----------|
| **Desktop** | 1280px+ | Máy tính xách tay, màn hình lớn |
| **Tablet** | 768px - 1279px | iPad, máy tính bảng |
| **Mobile** | 375px - 767px | Điện thoại thông minh |

---

## 🚀 Ngăn Xếp Sản Xuất

| 📦 Lớp | 🔧 Công Nghệ |
|---------|-----------|
| **Web Server** | Gunicorn / WSGI Server |
| **Reverse Proxy** | Nginx (tùy chọn) |
| **Database** | PostgreSQL 12+ |
| **Cache Layer** | Redis (tùy chọn) |
| **Static Hosting** | CDN (CloudFlare, Skypack, jsDelivr) |
| **Repository** | GitHub (https://github.com/vudinhkhang/UrbanGreen) |
| **Version Control** | Git (nhánh: dev, main) |

---

# TÓM TẮT

## 📊 Kho Hàng Công Nghệ

| 📋 Danh Mục | 🔢 Số Lượng | 💡 Ví Dụ |
|----------|--------|-----------|
| **Thư Viện Frontend** | 8+ | Bootstrap, Leaflet, Chart.js, FontAwesome |
| **API Bên Ngoài** | 2 | Nominatim (địa chỉ), OSRM (định tuyến) |
| **Framework Backend** | 1 | Django 6.0.2 |
| **Ngôn Ngữ Lập Trình** | 2 | Python, JavaScript |
| **Cơ Sở Dữ Liệu** | 2 | PostgreSQL (sản xuất), SQLite3 (dev) |
| **Mô-đun Django** | 12+ | auth, ORM, messages, decorators |
| **Mẫu HTML** | 17+ | DTL với kế thừa cơ sở |
| **Điểm Cuối API** | 15+ | CRUD, GIS, admin, xuất |
| **Công Nghệ GIS** | 5 | WGS84, GeoJSON, Haversine, MarkerCluster, Heatmap |

---

## ✨ Những Điểm Nổi Bật Chính

✅ **Tích Hợp GIS Hoàn Toàn** - Leaflet.js với bản đồ nhiệt, tìm kiếm bán kính, địa chỉ, định tuyến  
✅ **Cơ Sở Dữ Liệu Sản Xuất** - PostgreSQL hỗ trợ truy vấn không gian  
✅ **API RESTful** - Hoạt động hàng loạt, đề xuất AI, xuất dữ liệu  
✅ **Thiết Kế Responsive** - Điều hướng di động trước, hoạt động trên tất cả thiết bị  
✅ **Bảo Mật** - Bảo vệ CSRF, quản lý phiên, quyền truy cập dựa trên vai trò  
✅ **Ghi Nhật Ký Hoạt Động** - Đường dẫn kiểm toán hoàn chỉnh của tất cả hoạt động  
✅ **Tải Lên Tệp** - Xử lý ảnh với Pillow (tree_images/)  

---

<div align="center">

### 🌟 Sẵn Sàng Triển Khai Sản Xuất 🌟

**Tất cả công cụ được tải từ CDN hoặc cài đặt cục bộ**  
**Xác nhận Django: ✅ 0 vấn đề**  
**Cơ Sở Dữ Liệu: PostgreSQL (127.0.0.1:5432)**  
**Kho Lưu Trữ: GitHub (nhánh: dev)**

</div>
