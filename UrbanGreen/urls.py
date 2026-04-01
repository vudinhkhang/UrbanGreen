from django.contrib import admin
from django.urls import path, re_path
from django.contrib.auth import views as auth_views
from public_map.views import (
    about_view,
    home_view, map_view, tree_detail_view, tree_list_view,
    tree_add_view, tree_delete_view,
    species_list_view, species_add_view, species_edit_view, species_delete_view,
    maintenance_list_view, dashboard_view,
    export_trees_csv, export_maintenance_csv,
    bulk_maintenance_view,
    custom_logout_view,
    admin_dashboard_view, admin_users_view, user_profile_view, admin_activity_view,
    custom_404_view, custom_500_view,
)

# --- THÊM 2 DÒNG NÀY ---
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin-panel/', admin_dashboard_view, name='admin_dashboard'),
    path('admin-users/', admin_users_view, name='admin_users'),
    path('admin-activities/', admin_activity_view, name='admin_activities'),
    path('user-profile/', user_profile_view, name='user_profile'),
    path('admin/', admin.site.urls),
    path('login/', auth_views.LoginView.as_view(template_name='login.html'), name='login'),
    path('logout/', custom_logout_view, name='logout'),
    path('about/', about_view, name='about'),
    path('', home_view, name='home'),
    path('map/', map_view, name='map'),
    path('tree/<int:tree_id>/', tree_detail_view, name='tree_detail'),
    path('trees/', tree_list_view, name='tree_list'),
    path('tree/add/', tree_add_view, name='tree_add'),
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
    # Test error pages in DEBUG mode (remove in production)
    path('404/', custom_404_view, name='test_404'),
]

# --- THÊM ĐOẠN NÀY ĐỂ HIỂN THỊ ẢNH KHI ĐANG CHẠY THỬ (DEBUG) ---
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

# Catch-all for 404 pages (MUST be at the VERY END after static/media URLs)
urlpatterns += [
    re_path(r'^.*$', custom_404_view, name='catch_all_404'),
]

# Error handlers
handler404 = custom_404_view
handler500 = custom_500_view