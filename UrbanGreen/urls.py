from django.contrib import admin
from django.urls import path
from public_map.views import (
    home_view, tree_detail_view, tree_list_view, 
    tree_add_view, tree_edit_view, tree_delete_view,
    species_list_view, species_add_view,
    landing_view
)

# --- THÊM 2 DÒNG NÀY ---
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home_view, name='home'),
    path('tree/<int:tree_id>/', tree_detail_view, name='tree_detail'),
    path('trees/', tree_list_view, name='tree_list'),
    path('tree/add/', tree_add_view, name='tree_add'),
    path('tree/<int:tree_id>/edit/', tree_edit_view, name='tree_edit'),
    path('tree/<int:tree_id>/delete/', tree_delete_view, name='tree_delete'),
    path('species/', species_list_view, name='species_list'),
    path('species/add/', species_add_view, name='species_add'),
    path('landing/', landing_view, name='landing'),
]

# --- THÊM ĐOẠN NÀY ĐỂ HIỂN THỊ ẢNH KHI ĐANG CHẠY THỬ (DEBUG) ---
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)