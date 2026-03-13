from django.contrib import admin
from django.urls import path
from django.contrib.auth import views as auth_views
from public_map.views import (
    home_view, map_view, tree_detail_view, tree_list_view,
    tree_add_view, tree_edit_view, tree_delete_view,
    species_list_view, species_add_view, species_edit_view, species_delete_view,
    maintenance_list_view, dashboard_view,
    export_trees_csv, export_maintenance_csv,
    bulk_maintenance_view,
)

# --- THÊM 2 DÒNG NÀY ---
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('login/', auth_views.LoginView.as_view(template_name='login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(), name='logout'),
    path('', home_view, name='home'),
    path('map/', map_view, name='map'),
    path('tree/<int:tree_id>/', tree_detail_view, name='tree_detail'),
    path('trees/', tree_list_view, name='tree_list'),
    path('tree/add/', tree_add_view, name='tree_add'),
    path('tree/<int:tree_id>/edit/', tree_edit_view, name='tree_edit'),
    path('tree/<int:tree_id>/delete/', tree_delete_view, name='tree_delete'),
    path('species/', species_list_view, name='species_list'),
    path('species/add/', species_add_view, name='species_add'),
    path('species/<int:species_id>/edit/', species_edit_view, name='species_edit'),
    path('species/<int:species_id>/delete/', species_delete_view, name='species_delete'),
    path('dashboard/', dashboard_view, name='dashboard'),
    path('export/trees/', export_trees_csv, name='export_trees'),
    path('export/maintenance/', export_maintenance_csv, name='export_maintenance'),
    path('maintenance/', maintenance_list_view, name='maintenance_list'),
    path('api/bulk-maintenance/', bulk_maintenance_view, name='bulk_maintenance'),
]

# --- THÊM ĐOẠN NÀY ĐỂ HIỂN THỊ ẢNH KHI ĐANG CHẠY THỬ (DEBUG) ---
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)