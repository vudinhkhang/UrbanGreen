# 🛠️ Công Cụ & Thư Viện UrbanGreen

**Backend:** Django 6.0.2 + Python 3.14  
**Frontend:** JavaScript ES6+  
**Database:** PostgreSQL  
**Bản đồ:** Leaflet.js 1.7.1  

---

# 📱 FRONTEND

## Bootstrap 5.1.3 - Khung Giao Diện Responsive

**Tác dụng:** Tạo giao diện web responsive (mobile-first), các thành phần UI sẵn sàng

**Cài đặt:**
```html
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
```

**Code Demo:**
```html
<!-- Layout responsive -->
<div class="container-fluid">
  <div class="row">
    <div class="col-md-8">
      <div class="card">
        <div class="card-header">
          <h5>Danh Sách Cây Xanh</h5>
        </div>
        <div class="card-body">
          <table class="table table-striped">
            <thead>
              <tr>
                <th>Mã Cây</th>
                <th>Loài</th>
                <th>Trạng Thái</th>
              </tr>
            </thead>
            <tbody id="treeTable"></tbody>
          </table>
        </div>
      </div>
    </div>
    <div class="col-md-4">
      <div class="alert alert-info">Tổng: <strong>150</strong> cây</div>
      <div class="alert alert-danger">Nguy hiểm: <strong>3</strong> cây</div>
    </div>
  </div>
</div>
```

---

## Leaflet.js 1.7.1 - Thư Viện Bản Đồ

**Tác dụng:** Hiển thị bản đồ tương tác, điểm đánh dấu cây, vùng quản lý

**Cài đặt:**
```html
<link href="https://cdn.jsdelivr.net/npm/leaflet@1.7.1/dist/leaflet.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/leaflet@1.7.1/dist/leaflet.js"></script>
```

**Code Demo:**
```javascript
// Khởi tạo bản đồ
const map = L.map('map').setView([21.0285, 105.8542], 13);

// Thêm lớp bản đồ OpenStreetMap
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
  attribution: '© OpenStreetMap',
  maxZoom: 19
}).addTo(map);

// Lấy dữ liệu cây từ server
fetch('/map/')
  .then(r => r.json())
  .then(trees => {
    trees.forEach(tree => {
      const statusColor = {
        'TOT': '#2ecc71',      // Xanh - tốt
        'SAU_BENH': '#f39c12', // Vàng - sâu bệnh
        'NGUY_HIEM': '#e74c3c' // Đỏ - nguy hiểm
      }[tree.status];

      // Thêm điểm đánh dấu
      L.circleMarker([tree.lat, tree.long], {
        radius: 8,
        fillColor: statusColor,
        fillOpacity: 0.8,
        weight: 2,
        opacity: 1,
        color: '#fff'
      })
      .bindPopup(`
        <b>${tree.code}</b><br>
        Loài: ${tree.name}<br>
        Cao: ${tree.height}m<br>
        <a href="/tree/${tree.id}/" class="btn btn-sm btn-primary">Chi tiết</a>
      `)
      .addTo(map);
    });
  });

// Sự kiện click bản đồ - lấy tọa độ
map.on('click', (e) => {
  console.log(`Vĩ độ: ${e.latlng.lat}, Kinh độ: ${e.latlng.lng}`);
});
```

---

## Leaflet.heat 0.2.0 - Bản Đồ Nhiệt

**Tác dụng:** Hiển thị mật độ cây (bản đồ nhiệt) - khu vực đông đúc cây hiển thị đỏ

**Code Demo:**
```javascript
// Bao gồm thư viện
// <script src="https://cdn.jsdelivr.net/npm/leaflet.heat@0.2.0/dist/leaflet-heat.js"></script>

// Dữ liệu điểm (vĩ độ, kinh độ, cường độ)
const heatData = [
  [21.0285, 105.8542, 0.8],
  [21.0290, 105.8550, 0.6],
  [21.0295, 105.8560, 0.9],
  [21.0300, 105.8570, 0.5]
];

// Tạo lớp bản đồ nhiệt
const heatLayer = L.heatLayer(heatData, {
  radius: 25,
  blur: 15,
  maxZoom: 17
}).addTo(map);

// Ẩn/hiện bản đồ nhiệt
document.getElementById('toggleHeat').addEventListener('click', () => {
  if (map.hasLayer(heatLayer)) {
    map.removeLayer(heatLayer);
  } else {
    map.addLayer(heatLayer);
  }
});
```

---

## Leaflet.markercluster 1.5.3 - Gom Cụm Điểm

**Tác dụng:** Khi bản đồ thu nhỏ, gom các điểm lại thành cụm - tránh rối mắt

**Code Demo:**
```javascript
// <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet.markercluster@1.5.3/dist/MarkerCluster.css">
// <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet.markercluster@1.5.3/dist/MarkerCluster.Default.css">
// <script src="https://cdn.jsdelivr.net/npm/leaflet.markercluster@1.5.3/dist/leaflet.markercluster.js"></script>

const markerGroup = L.markerClusterGroup();

// Thêm 100+ điểm
for (let i = 0; i < 100; i++) {
  const lat = 21.0285 + (Math.random() - 0.5) * 0.05;
  const lng = 105.8542 + (Math.random() - 0.5) * 0.05;
  
  L.marker([lat, lng])
    .bindPopup(`Cây T${String(i+1).padStart(3, '0')}`)
    .addTo(markerGroup);
}

map.addLayer(markerGroup);
```

---

## Chart.js - Biểu Đồ Thống Kê

**Tác dụng:** Vẽ biểu đồ (cột, dòng, tròn) cho bảng điều khiển admin

**Code Demo:**
```html
<canvas id="statusChart"></canvas>

<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>
<script>
const ctx = document.getElementById('statusChart').getContext('2d');

const chart = new Chart(ctx, {
  type: 'pie',
  data: {
    labels: ['Tốt', 'Sâu bệnh', 'Nguy hiểm'],
    datasets: [{
      label: 'Trạng thái cây',
      data: [135, 12, 3],
      backgroundColor: [
        '#2ecc71', // Xanh
        '#f39c12', // Vàng
        '#e74c3c'  // Đỏ
      ],
      borderWidth: 2
    }]
  },
  options: {
    responsive: true,
    plugins: {
      legend: { position: 'bottom' },
      title: { display: true, text: 'Phân bố trạng thái cây' }
    }
  }
});
</script>
```

---

## Nominatim API - Định Địa Chỉ

**Tác dụng:** Chuyển địa chỉ thành tọa độ GPS & ngược lại

**Code Demo:**
```javascript
// Địa chỉ → Tọa độ (Geocoding)
async function geocodeAddress(address) {
  const response = await fetch(
    `https://nominatim.openstreetmap.org/search?` +
    `q=${encodeURIComponent(address)}&format=json&limit=1`
  );
  const data = await response.json();
  
  if (data.length > 0) {
    const result = data[0];
    console.log(`${address}`);
    console.log(`→ Vĩ độ: ${result.lat}, Kinh độ: ${result.lon}`);
    return { lat: parseFloat(result.lat), lon: parseFloat(result.lon) };
  }
}

geocodeAddress('123 Nguyễn Huệ, Hà Nội');
// Output: → Vĩ độ: 21.0285, Kinh độ: 105.8542

// Tọa độ → Địa chỉ (Reverse Geocoding)
async function reverseGeocode(lat, lon) {
  const response = await fetch(
    `https://nominatim.openstreetmap.org/reverse?` +
    `lat=${lat}&lon=${lon}&format=json`
  );
  const data = await response.json();
  console.log(`${lat}, ${lon} → ${data.address.road}, ${data.address.city}`);
  return data.address;
}

reverseGeocode(21.0285, 105.8542);
// Output: 21.0285, 105.8542 → Nguyễn Huệ, Hà Nội
```

---

## OSRM API - Tính Toán Đường Đi

**Tác dụng:** Tìm đường đi ngắn nhất, tính thời gian + khoảng cách

**Code Demo:**
```javascript
// Tìm đường từ điểm A → B
async function findRoute(lat1, lon1, lat2, lon2) {
  const url = `https://router.project-osrm.org/route/v1/driving/` +
    `${lon1},${lat1};${lon2},${lat2}?overview=full&geometries=geojson`;
  
  const response = await fetch(url);
  const data = await response.json();
  
  if (data.routes.length > 0) {
    const route = data.routes[0];
    const distance = (route.distance / 1000).toFixed(2); // km
    const duration = Math.round(route.duration / 60); // phút
    
    console.log(`🚗 Khoảng cách: ${distance} km`);
    console.log(`⏱️ Thời gian: ${duration} phút`);
    
    // Vẽ đường lên bản đồ
    L.geoJSON(route.geometry, {
      style: { color: '#FF0000', weight: 5, opacity: 0.7 }
    }).addTo(map);
  }
}

// Từ Nguyễn Huệ → Lý Thái Tổ
findRoute(21.0285, 105.8542, 21.0290, 105.8550);
```

---

## Fetch API - Gọi HTTP

**Tác dụng:** Gọi server Django lấy/gửi dữ liệu (thay XMLHttpRequest)

**Code Demo:**
```javascript
// GET - Lấy danh sách cây
fetch('/map/')
  .then(response => response.json())
  .then(data => console.log(data));

// POST - Thêm cây mới
const newTree = {
  code: 'T123',
  species: 1,
  height: 5.5,
  status: 'TOT',
  latitude: 21.0285,
  longitude: 105.8542,
  address: '123 Nguyễn Huệ'
};

fetch('/tree/add/', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-CSRFToken': document.querySelector('[name=csrfmiddlewaretoken]').value
  },
  body: JSON.stringify(newTree)
})
.then(r => r.json())
.then(data => console.log('✓ Thêm cây thành công'));

// DELETE - Xóa cây
fetch('/tree/T123/delete/', {
  method: 'POST',
  headers: { 'X-CSRFToken': getCookie('csrftoken') }
})
.then(() => console.log('✓ Xóa thành công'));
```

---

# 🔧 BACKEND

## Django 6.0.2 - Framework Web

**Tác dụng:** Xử lý URL, database, templates, xác thực người dùng

**Cấu trúc dự án:**
```
UrbanGreen/
  ├── settings.py        # Cấu hình (DB, middleware, apps)
  ├── urls.py            # Định tuyến URL
  ├── wsgi.py            # Máy chủ WSGI (Gunicorn)
  
public_map/
  ├── models.py          # 5 bảng DB (TreeSpecies, UrbanTree, ...)
  ├── views.py           # 25+ hàm xử lý
  ├── urls.py            # Tuyến cục bộ
  ├── admin.py           # Giao diện quản trị
  ├── migrations/        # Lịch sử DB
  
templates/
  ├── map.html           # Bản đồ GIS Leaflet
  ├── admin_dashboard.html  # Thống kê biểu đồ
  ├── tree_list.html     # Danh sách
  ├── tree_detail.html   # Chi tiết cây
```

**Code Demo - View:**
```python
# public_map/views.py

from django.shortcuts import render, redirect
from .models import UrbanTree, TreeSpecies, MaintenanceLog
from django.db.models import Q, Count

# 1. Trang chủ - Tổng quan
def home_view(request):
    total_trees = UrbanTree.objects.count()
    healthy = UrbanTree.objects.filter(status='TOT').count()
    sick = UrbanTree.objects.filter(status='SAU_BENH').count()
    danger = UrbanTree.objects.filter(status='NGUY_HIEM').count()
    
    return render(request, 'index.html', {
        'total': total_trees,
        'healthy': healthy,
        'sick': sick,
        'danger': danger
    })

# 2. Bản đồ GIS
def map_view(request):
    query = request.GET.get('q', '')
    status = request.GET.get('status', '')
    
    trees = UrbanTree.objects.all()
    
    if query:
        trees = trees.filter(
            Q(code__icontains=query) | 
            Q(species__name__icontains=query)
        )
    
    if status:
        trees = trees.filter(status=status)
    
    tree_data = [{
        'id': t.id,
        'code': t.code,
        'name': t.species.name,
        'lat': t.latitude,
        'lon': t.longitude,
        'status': t.status,
        'height': t.height
    } for t in trees]
    
    return render(request, 'map.html', {
        'trees_json': json.dumps(tree_data)
    })

# 3. CRUD - Thêm cây
def tree_add_view(request):
    if request.method == 'POST':
        species = TreeSpecies.objects.get(id=request.POST['species'])
        tree = UrbanTree.objects.create(
            code=request.POST['code'],
            species=species,
            height=float(request.POST['height']),
            latitude=float(request.POST['lat']),
            longitude=float(request.POST['lon']),
            address=request.POST.get('address', '')
        )
        return redirect('tree_detail', tree.id)
    
    species_list = TreeSpecies.objects.all()
    return render(request, 'tree_add.html', {
        'species_list': species_list
    })

# 4. Chăm sóc hàng loạt (Bulk Maintenance)
from django.http import JsonResponse
from django.views.decorators.http import require_POST

@require_POST
def bulk_maintenance_view(request):
    data = json.loads(request.body)
    tree_ids = data.get('tree_ids', [])
    performer = data.get('performer')
    action = data.get('action')
    date_str = data.get('date')
    
    logs = []
    for tree_id in tree_ids:
        tree = UrbanTree.objects.get(id=tree_id)
        log = MaintenanceLog.objects.create(
            tree=tree,
            date=date_str,
            action=action,
            performer=performer
        )
        logs.append(log)
    
    return JsonResponse({
        'status': 'ok',
        'count': len(logs)
    })
```

---

## PostgreSQL - Cơ Sở Dữ Liệu

**Tác dụng:** Lưu trữ dữ liệu cây, loài, lịch sử chăm sóc, người dùng

**Cấu hình:**
```python
# settings.py
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'HOST': '127.0.0.1',
        'PORT': 5432,
        'NAME': 'urbangreen_db',
        'USER': 'urbangreen_user',
        'PASSWORD': '123456',
    }
}
```

**Các truy vấn thường dùng:**
```python
# Tìm tất cả cây sâu bệnh
sick_trees = UrbanTree.objects.filter(status='SAU_BENH')

# Đếm theo loài
from django.db.models import Count
species_stats = UrbanTree.objects.values('species__name').annotate(
    count=Count('id')
).order_by('-count')

# Lấy lịch sử chăm sóc cây T001 (mới nhất trước)
history = MaintenanceLog.objects.filter(
    tree__code='T001'
).order_by('-date')[:10]

# Tìm cây trong bán kính 1km (Haversine)
from math import radians, sin, cos, sqrt, atan2

def distance_between(lat1, lon1, lat2, lon2):
    R = 6371  # km
    dlat = radians(lat2 - lat1)
    dlon = radians(lon2 - lon1)
    a = sin(dlat/2)**2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(dlon/2)**2
    c = 2 * atan2(sqrt(a), sqrt(1-a))
    return R * c

nearby = []
for tree in UrbanTree.objects.all():
    d = distance_between(21.0285, 105.8542, tree.latitude, tree.longitude)
    if d <= 1:
        nearby.append((tree, d))
```

---

## Django ORM - Xử Lý Database

**Tác dụng:** Truy vấn DB mà không cần viết SQL

**Code Demo:**
```python
from public_map.models import UrbanTree, TreeSpecies, MaintenanceLog

# CREATE
tree = UrbanTree.objects.create(
    code='T001',
    species_id=1,
    height=5.5,
    status='TOT',
    latitude=21.0285,
    longitude=105.8542
)

# READ
tree = UrbanTree.objects.get(code='T001')
all_trees = UrbanTree.objects.all()
healthy = UrbanTree.objects.filter(status='TOT')

# UPDATE
tree.height = 6.0
tree.status = 'NGUY_HIEM'
tree.save()

# DELETE
tree.delete()

# Complex Query
result = UrbanTree.objects.filter(
    species__is_pest_prone=True,
    status='SAU_BENH'
).values('code', 'species__name').order_by('code')
```

---

## Pillow - Xử Lý Ảnh

**Tác dụng:** Xử lý ảnh cây được upload (kiểm tra, thay đổi kích thước)

**Code Demo:**
```python
from PIL import Image
from django.core.files.base import ContentFile
import io

# Kiểm tra & thay đổi kích thước ảnh
def process_tree_image(image_file):
    # Mở ảnh
    img = Image.open(image_file)
    
    # Chuyển sang RGB (nếu là RGBA)
    if img.mode == 'RGBA':
        img = img.convert('RGB')
    
    # Thay đổi kích thước (max 800x600)
    img.thumbnail((800, 600), Image.Resampling.LANCZOS)
    
    # Lưu vào buffer
    buffer = io.BytesIO()
    img.save(buffer, format='JPEG', quality=85)
    buffer.seek(0)
    
    return buffer

# Sử dụng trong view
if request.FILES.get('image'):
    image_file = request.FILES['image']
    processed = process_tree_image(image_file)
    
    tree.image.save(
        f'tree_{tree.code}.jpg',
        ContentFile(processed.getvalue())
    )
```

---

# 📊 GIS

## Haversine Formula - Tính Khoảng Cách GPS

**Tác dụng:** Tính khoảng cách thực tế giữa 2 tọa độ (sử dụng cong của Trái Đất)

**Code Demo:**
```python
from math import radians, sin, cos, sqrt, atan2

def haversine_distance(lat1, lon1, lat2, lon2):
    """Tính khoảng cách giữa 2 điểm GPS (km)"""
    R = 6371  # bán kính Trái Đất (km)
    
    # Chuyển độ → radian
    lat1, lon1, lat2, lon2 = map(radians, [lat1, lon1, lat2, lon2])
    
    # Công thức Haversine
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * atan2(sqrt(a), sqrt(1-a))
    
    return R * c

# Sử dụng
distance = haversine_distance(
    21.0285, 105.8542,  # Nguyễn Huệ
    21.0290, 105.8550   # Lý Thái Tổ
)
print(f'Khoảng cách: {distance:.2f} km')  # 0.79 km

# Tìm cây gần nhất
def find_nearby_trees(center_lat, center_lon, radius_km=1):
    from public_map.models import UrbanTree
    
    nearby = []
    for tree in UrbanTree.objects.all():
        dist = haversine_distance(
            center_lat, center_lon,
            tree.latitude, tree.longitude
        )
        if dist <= radius_km:
            nearby.append({
                'tree': tree,
                'distance': dist
            })
    
    return sorted(nearby, key=lambda x: x['distance'])

trees = find_nearby_trees(21.0285, 105.8542, radius_km=0.5)
for item in trees:
    print(f"🌳 {item['tree'].code}: {item['distance']:.2f} km")
```

---

## WGS84 (EPSG:4326) - Hệ Tọa Độ GPS

**Tác dụng:** Tiêu chuẩn tọa độ GPS (vĩ độ, kinh độ số thập phân)

**Ví dụ:**
```
Hà Nội: 21.0285°N, 105.8542°E
Sài Gòn: 10.7769°N, 106.6966°E
Đà Nẵng: 16.0473°N, 108.2068°E
```

---

## GeoJSON - Định Dạng Địa Lý

**Tác dụng:** Lưu trữ & truyền tải dữ liệu địa lý (điểm, đường, đa giác)

**Code Demo:**
```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [105.8542, 21.0285]
      },
      "properties": {
        "code": "T001",
        "name": "Xoan Tía",
        "status": "TOT"
      }
    },
    {
      "type": "Feature",
      "geometry": {
        "type": "Polygon",
        "coordinates": [[
          [105.8, 21.0],
          [105.9, 21.0],
          [105.9, 21.1],
          [105.8, 21.1],
          [105.8, 21.0]
        ]]
      },
      "properties": {
        "name": "Khu Tây",
        "type": "ManagementZone"
      }
    }
  ]
}
```

**Sử dụng trong Leaflet:**
```javascript
fetch('/api/trees-geojson/')
  .then(r => r.json())
  .then(geojson => {
    L.geoJSON(geojson, {
      pointToLayer: (feature, latlng) => {
        const color = {
          'TOT': '#2ecc71',
          'SAU_BENH': '#f39c12',
          'NGUY_HIEM': '#e74c3c'
        }[feature.properties.status];
        
        return L.circleMarker(latlng, {
          radius: 8,
          fillColor: color,
          weight: 2
        });
      }
    }).addTo(map);
  });
```

---

# 📦 Cài Đặt & Chạy

**Yêu cầu:**
```bash
Python 3.9+
PostgreSQL 12+
pip install -r requirements.txt
```

**requirements.txt:**
```
Django==6.0.2
psycopg2-binary
Pillow
python-dateutil
pytz
```

**Chạy development:**
```bash
# Tạo migration
python manage.py makemigrations

# Áp dụng migration
python manage.py migrate

# Tạo superuser
python manage.py createsuperuser

# Chạy server
python manage.py runserver
# Truy cập: http://localhost:8000
```

---

# ✨ Tóm Tắt

| Phần | Công Cụ | Tác Dụng |
|------|---------|---------|
| **Frontend** | Bootstrap, Leaflet, Chart.js | Giao diện, bản đồ, biểu đồ |
| **Backend** | Django, Python, PostgreSQL | Server, database, xử lý logic |
| **GIS** | Leaflet.js, Nominatim, OSRM, Haversine | Bản đồ, định tuyến, tính khoảng cách |
| **Tiện Ích** | Fetch API, GeoJSON, Pillow | HTTP, dữ liệu địa lý, ảnh |

