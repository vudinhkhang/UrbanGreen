from django.contrib import admin
from django.urls import path
from public_map.views import home_view

# --- THÊM 2 DÒNG NÀY ---
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home_view, name='home'),
]

# --- THÊM ĐOẠN NÀY ĐỂ HIỂN THỊ ẢNH KHI ĐANG CHẠY THỬ (DEBUG) ---
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)