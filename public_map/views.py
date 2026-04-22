from django.shortcuts import render, get_object_or_404, redirect
from .models import UrbanTree, MaintenanceLog, TreeSpecies, ManagementZone, ActivityLog, District, UserManagedDistrict
import json
from django.db.models import Q, Max, Subquery, OuterRef, F, Value, CharField, Count
from django.db.models.functions import Coalesce, TruncMonth
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError
from django.core.validators import validate_email
from django.core.paginator import Paginator
from datetime import datetime, date, timedelta
from django.http import JsonResponse, HttpResponse
from django.views.decorators.http import require_POST
from django.contrib.auth import logout
from django.views.decorators.csrf import csrf_protect, ensure_csrf_cookie, csrf_exempt
from django.utils import timezone
import csv
from functools import wraps


def admin_required(view_func):
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        if not request.user.is_staff:
            if request.path.startswith('/api/') or request.content_type == 'application/json':
                return JsonResponse({
                    'status': 'error',
                    'error': 'Bạn không có quyền thực hiện thao tác này.'
                }, status=403)
            messages.error(request, '❌ Bạn không có quyền thực hiện thao tác này.')
            return redirect('home')
        return view_func(request, *args, **kwargs)

    return _wrapped_view


def log_activity(request, action_type, entity_type, entity_code='', detail=''):
    """Persist action traces for admin activity center."""
    user = request.user if getattr(request, 'user', None) and request.user.is_authenticated else None
    ActivityLog.objects.create(
        user=user,
        action_type=action_type,
        entity_type=entity_type,
        entity_code=entity_code or '',
        detail=detail or '',
    )

def about_view(request):
    """Public introduction/about page - accessible without login."""
    return render(request, 'about.html')

@login_required
@ensure_csrf_cookie
def home_view(request):
    total_trees = UrbanTree.objects.count()
    total_species = TreeSpecies.objects.count()
    total_logs = MaintenanceLog.objects.count()
    sick_trees = UrbanTree.objects.filter(status='SAU_BENH').count()
    danger_trees = UrbanTree.objects.filter(status='NGUY_HIEM').count()
    healthy_trees = UrbanTree.objects.filter(status='TOT').count()
    recent_logs = MaintenanceLog.objects.select_related('tree', 'tree__species').order_by('-date')[:5]
    return render(request, 'index.html', {
        'total_trees': total_trees,
        'total_species': total_species,
        'total_logs': total_logs,
        'sick_trees': sick_trees,
        'danger_trees': danger_trees,
        'healthy_trees': healthy_trees,
        'recent_logs': recent_logs,
    })


@login_required
@ensure_csrf_cookie
def map_view(request):
    # 1. Lấy tham số từ thanh địa chỉ (Ví dụ: /?q=Phuong&status=SAU_BENH)
    query = request.GET.get('q', '')
    status_filter = request.GET.get('status', '')

    # 2. Bắt đầu với toàn bộ cây
    trees = UrbanTree.objects.all()

    # 2a. Áp dụng bộ lọc quyền - người dùng thường chỉ thấy quận/huyện được gán + cây không được gán
    if not request.user.is_staff:
        allowed_districts = District.objects.filter(
            managed_by_users__user=request.user
        ).distinct()
        trees = trees.filter(
            Q(district__in=allowed_districts) | Q(district__isnull=True)
        )

    # 3. Nếu có từ khóa tìm kiếm (theo Tên loài hoặc Mã cây)
    if query:
        trees = trees.filter(
            Q(species__name__icontains=query) | 
            Q(code__icontains=query)
        )
    
    # 4. Nếu có chọn trạng thái (Lọc cây sâu bệnh, nguy hiểm...)
    if status_filter:
        trees = trees.filter(status=status_filter)

    # --- Phần chuyển đổi JSON (Giữ nguyên như cũ) ---
    tree_list = []
    for tree in trees:
        image_url = tree.image.url if tree.image else ''
        
        # Lấy tất cả ảnh của cây
        tree_images = []
        for img in tree.images.all():
            tree_images.append(img.image.url)
        
        tree_list.append({
            'id': tree.id,
            'code': tree.code,
            'name': tree.species.name,
            'status': tree.status,
            'lat': tree.latitude,
            'long': tree.longitude,
            'height': tree.height,
            'image': image_url,
            'images': tree_images,
            'address': tree.address or ''
        })
    
    tree_json = json.dumps(tree_list)
    
    # Gửi thêm biến 'query' và 'status_filter' ra để giữ lại nội dung trong ô tìm kiếm
    return render(request, 'map.html', {
        'tree_json': tree_json,
        'query': query,
        'status_filter': status_filter
    })

# Hàm tạo danh sách đề xuất chăm sóc cho một cây
def generate_maintenance_recommendations(tree):
    """
    Sinh danh sách đề xuất chăm sóc dựa trên đặc tính loài và trạng thái cây
    Returns: list of dicts với các key: 'type', 'title', 'description', 'icon', 'priority'
    priority: 'critical', 'warning', 'info'
    """
    recommendations = []
    species = tree.species
    
    # 1. Kiểm tra trạng thái nguy hiểm
    if tree.status == 'NGUY_HIEM':
        recommendations.append({
            'type': 'danger',
            'title': 'Cây nguy hiểm — cần xử lý ngay',
            'description': 'Cây ở trạng thái nguy hiểm, cần kiểm tra và xử lý khẩn cấp.',
            'icon': '🚨',
            'priority': 'critical',
            'action': 'KIEM_TRA'
        })
    
    # 2. Kiểm tra trạng thái sâu bệnh
    if tree.status == 'SAU_BENH':
        recommendations.append({
            'type': 'warning',
            'title': 'Cây sâu bệnh — cần chăm sóc',
            'description': 'Cây có dấu hiệu sâu bệnh, cần kiểm tra và điều trị kịp thời.',
            'icon': '⚠️',
            'priority': 'warning',
            'action': 'KIEM_TRA'
        })
    
    # 3. Kiểm tra lịch sử kiểm tra (nếu chưa kiểm tra bao lâu)
    last_inspection = MaintenanceLog.objects.filter(
        tree=tree, 
        action='KIEM_TRA'
    ).order_by('-date').first()
    
    inspection_freq_days = species.inspection_frequency_days or 90
    
    if last_inspection:
        days_since_inspection = (date.today() - last_inspection.date).days
        if days_since_inspection > inspection_freq_days:
            recommendations.append({
                'type': 'info',
                'title': 'Quá hạn kiểm tra',
                'description': f'Cây chưa kiểm tra trong {days_since_inspection} ngày. Chu kỳ kiểm tra: {inspection_freq_days} ngày.',
                'icon': '📋',
                'priority': 'warning',
                'action': 'KIEM_TRA'
            })
    else:
        # Chưa bao giờ kiểm tra
        recommendations.append({
            'type': 'info',
            'title': 'Chưa từng kiểm tra',
            'description': f'Cây chưa có lịch sử kiểm tra. Chu kỳ kiểm tra: {inspection_freq_days} ngày.',
            'icon': '📋',
            'priority': 'info',
            'action': 'KIEM_TRA'
        })
    
    # 4. Kiểm tra đặc tính loài sâu bệnh
    if species.is_pest_prone:
        last_pesticide = MaintenanceLog.objects.filter(
            tree=tree,
            action='PHUN_THUOC'
        ).order_by('-date').first()
        
        if not last_pesticide:
            recommendations.append({
                'type': 'warning',
                'title': 'Loài dễ sâu bệnh — cần phun thuốc',
                'description': f'{species.name} dễ bị sâu bệnh. Chưa từng phun thuốc trừ sâu.',
                'icon': '🐛',
                'priority': 'warning',
                'action': 'PHUN_THUOC'
            })
    
    # 5. Kiểm tra dễ đổ/gãy
    if species.is_fall_prone:
        recommendations.append({
            'type': 'warning',
            'title': 'Loài dễ đổ/gãy — cần cắt tỉa',
            'description': f'{species.name} dễ đổ/gãy, cần cắt tỉa cõng định kỳ để giảm khối lượng.',
            'icon': '💨',
            'priority': 'warning',
            'action': 'CAT_TIA'
        })
    
    # 6. Kiểm tra mọc nhanh
    if species.is_fast_growing:
        last_pruning = MaintenanceLog.objects.filter(
            tree=tree,
            action='CAT_TIA'
        ).order_by('-date').first()
        
        if not last_pruning:
            recommendations.append({
                'type': 'info',
                'title': 'Cắt cắt tỉa — loại mọc nhanh',
                'description': f'{species.name} mọc nhanh cần cắt tỉa thường xuyên. Chưa từng cắt tỉa.',
                'icon': '✂️',
                'priority': 'info',
                'action': 'CAT_TIA'
            })
        else:
            days_since_pruning = (date.today() - last_pruning.date).days
            if days_since_pruning > 180:  # >6 tháng
                recommendations.append({
                    'type': 'info',
                    'title': 'Cắt tỉa — loại mọc nhanh',
                    'description': f'{species.name} mọc nhanh, lần cắt tỉa cuối cùng là {days_since_pruning} ngày trước.',
                    'icon': '✂️',
                    'priority': 'info',
                    'action': 'CAT_TIA'
                })
    
    # 7. Kiểm tra nhạy cảm hạn
    if species.is_drought_sensitive:
        watering_freq = species.watering_frequency_days or 7
        last_watering = MaintenanceLog.objects.filter(
            tree=tree,
            action='TUOI_NUOC'
        ).order_by('-date').first()
        
        if last_watering:
            days_since_watering = (date.today() - last_watering.date).days
            if days_since_watering > watering_freq * 2:  # Quá hạn tưới 2 lần
                recommendations.append({
                    'type': 'warning',
                    'title': 'Tưới nước — loài nhạy hạn',
                    'description': f'{species.name} nhạy cảm hạn hán. Lần tưới cuối: {days_since_watering} ngày. Chu kỳ tưới: {watering_freq} ngày.',
                    'icon': '💧',
                    'priority': 'warning',
                    'action': 'TUOI_NUOC'
                })
        else:
            recommendations.append({
                'type': 'warning',
                'title': 'Tưới nước — loài nhạy hạn',
                'description': f'{species.name} nhạy cảm hạn hán, chưa có lịch tưới nước. Chu kỳ tưới: {watering_freq} ngày.',
                'icon': '💧',
                'priority': 'warning',
                'action': 'TUOI_NUOC'
            })
    
    # 8. Kiểm tra rễ xâm lấn
    if species.is_invasive_roots:
        recommendations.append({
            'type': 'info',
            'title': 'Rễ xâm lấn — cần kiểm tra',
            'description': f'{species.name} có rễ xâm lấn, cần kiểm tra định kỳ để tránh hư hại công trình.',
            'icon': '🌳',
            'priority': 'info',
            'action': 'KIEM_TRA'
        })
    
    return recommendations

# Hàm mới: Xem chi tiết 1 cây
@login_required
def tree_detail_view(request, tree_id):
    # Lấy cây theo ID, nếu không thấy thì báo lỗi 404
    tree = get_object_or_404(UrbanTree, id=tree_id)
    
    # Kiểm tra quyền - người dùng thường chỉ có thể xem cây trong quận/huyện được gán hoặc cây không được gán
    if not request.user.is_staff:
        allowed_districts = District.objects.filter(
            managed_by_users__user=request.user
        ).distinct()
        if tree.district and not allowed_districts.filter(id=tree.district.id).exists():
            messages.error(request, '❌ Bạn không có quyền xem cây này. Cây này thuộc quận/huyện khác.')
            return redirect('tree_list')
    
    # ============ LẤY DỮ LIỆU HIỂN THỊ (Trước để tránh xung đột biến) ============
    # Lấy toàn bộ lịch sử chăm sóc của cây này, sắp xếp mới nhất lên đầu
    logs = MaintenanceLog.objects.filter(tree=tree).order_by('-date')
    
    # Những lựa chọn trạng thái cây
    status_choices = UrbanTree._meta.get_field('status').choices
    
    # Những lựa chọn loại công việc chăm sóc
    maintenance_choices = MaintenanceLog._meta.get_field('action').choices
    
    # Ngày hôm nay để dùng làm default
    today = date.today()
    
    # ============ XỬ LÝ FORM POST ============
    if request.method == 'POST':
        # -1. Xóa ảnh từ thư viện nếu có yêu cầu
        if 'delete_image_id' in request.POST:
            image_id = request.POST.get('delete_image_id')
            try:
                from .models import TreeImage
                img_to_delete = TreeImage.objects.get(id=image_id, tree=tree)
                
                # Nếu đây là ảnh đại diện, hãy cập nhật sang ảnh khác
                if tree.image.name == img_to_delete.image.name:
                    other_images = tree.images.exclude(id=image_id).first()
                    if other_images:
                        tree.image = other_images.image
                    else:
                        tree.image = None
                    tree.save()
                
                # Xóa file từ storage
                if img_to_delete.image:
                    from django.core.files.storage import default_storage
                    if default_storage.exists(img_to_delete.image.name):
                        default_storage.delete(img_to_delete.image.name)
                
                img_to_delete.delete()
                log_activity(
                    request,
                    action_type='DELETE_IMAGE',
                    entity_type='TREE',
                    entity_code=tree.code,
                    detail=f'Xóa 1 ảnh khỏi cây {tree.code}',
                )
                messages.success(request, '✅ Xóa ảnh thành công!')
                return redirect('tree_detail', tree_id=tree_id)
            except TreeImage.DoesNotExist:
                messages.error(request, '❌ Ảnh không tồn tại!')
            except Exception as e:
                messages.error(request, f'❌ Lỗi khi xóa ảnh: {str(e)}')
        
        # 0. Loại bỏ xử lý chỉnh sửa thông tin cây (form đã bị xóa khỏi template)
        # Các trường chiều cao, trunk_radius, canopy_diameter, planting_year không thể chỉnh sửa từ detail view
        # Nếu cần chỉnh sửa, hãy sử dụng tree_add.html/tree_edit.html
        
        # 1. Cập nhật/Thêm ảnh cây nếu có upload (hỗ trợ nhiều ảnh)
        elif 'image' in request.FILES:
            uploaded_files = request.FILES.getlist('image')
            for uploaded_file in uploaded_files:
                from .models import TreeImage
                TreeImage.objects.create(
                    tree=tree,
                    image=uploaded_file,
                    caption=''
                )
            
            # Cũng cập nhật trường image cũ để tương thích
            if uploaded_files:
                tree.image = uploaded_files[0]
                tree.save()
            
            log_activity(
                request,
                action_type='UPLOAD_IMAGE',
                entity_type='TREE',
                entity_code=tree.code,
                detail=f'Cập nhật {len(uploaded_files)} ảnh cho cây {tree.code}',
            )
            messages.success(request, f'✅ Tải lên {len(uploaded_files)} ảnh thành công!')
            return redirect('tree_detail', tree_id=tree_id)
        
        # 2. Thêm lịch sử chăm sóc nếu có submit form
        if 'add_maintenance' in request.POST:
            maintenance_date = request.POST.get('date', '')
            action = request.POST.get('action', '')
            performer = request.POST.get('performer', '')
            note = request.POST.get('note', '')
            
            if maintenance_date and action and performer:
                # Chuẩn bị dữ liệu cho tạo MaintenanceLog
                maintenance_log = MaintenanceLog(
                    tree=tree,
                    date=maintenance_date,
                    action=action,
                    performer=performer,
                    note=note
                )
                
                # Theo dõi các thay đổi để hiển thị "từ X → Y"
                changes_detail = []
                
                # Thêm các trường tùy theo loại công việc (nếu được hỗ trợ)
                try:
                    if action == 'BON_PHAN':
                        fertilizer = request.POST.get('fertilizer_name', '').strip()
                        if fertilizer and hasattr(maintenance_log, 'fertilizer_name'):
                            try:
                                maintenance_log.fertilizer_name = fertilizer
                                changes_detail.append(f"Phân bón: loại {fertilizer}")
                            except:
                                pass
                            
                    elif action == 'PHUN_THUOC':
                        pesticide = request.POST.get('pesticide_name', '').strip()
                        if pesticide and hasattr(maintenance_log, 'pesticide_name'):
                            try:
                                maintenance_log.pesticide_name = pesticide
                                changes_detail.append(f"Chất bảo vệ thực vật: {pesticide}")
                            except:
                                pass
                            
                    elif action == 'TUOI_NUOC':
                        water_amount = request.POST.get('water_amount', '')
                        if water_amount and hasattr(maintenance_log, 'water_amount'):
                            try:
                                water_val = float(water_amount)
                                maintenance_log.water_amount = water_val
                                changes_detail.append(f"Lượng nước tưới: {water_val} lít")
                            except (ValueError, TypeError):
                                pass
                                
                    elif action == 'CAT_TIA':
                        # Cắt tỉa - cập nhật diện tích vòm (nếu column tồn tại)
                        canopy_diameter = request.POST.get('measurement_canopy_diameter', '')
                        if canopy_diameter:
                            try:
                                new_value = float(canopy_diameter)
                                if hasattr(tree, 'canopy_diameter'):
                                    try:
                                        old_value = float(tree.canopy_diameter) if tree.canopy_diameter else 0
                                        tree.canopy_diameter = new_value
                                        maintenance_log.measurement_canopy_diameter = new_value
                                        if new_value < old_value:
                                            change_desc = f"Diện tích vòm giảm từ {old_value}m² xuống {new_value}m²"
                                        elif new_value > old_value:
                                            change_desc = f"Diện tích vòm tăng từ {old_value}m² lên {new_value}m²"
                                        else:
                                            change_desc = f"Diện tích vòm: {new_value}m² (không thay đổi)"
                                        changes_detail.append(change_desc)
                                    except (ValueError, TypeError):
                                        pass
                            except ValueError:
                                pass
                                
                    elif action == 'KIEM_TRA':
                        # Kiểm tra định kỳ - cập nhật kích thước (height, trunk_radius, canopy_diameter)
                        height = request.POST.get('measurement_height', '')
                        trunk_radius = request.POST.get('measurement_trunk_radius', '')
                        canopy_diameter = request.POST.get('measurement_canopy_diameter', '')
                        
                        if height:
                            try:
                                new_value = float(height)
                                old_value = float(tree.height) if tree.height else 0
                                tree.height = new_value
                                maintenance_log.measurement_height = new_value
                                if new_value < old_value:
                                    change_desc = f"Chiều cao cây giảm từ {old_value}m xuống {new_value}m"
                                elif new_value > old_value:
                                    change_desc = f"Chiều cao cây tăng từ {old_value}m lên {new_value}m"
                                else:
                                    change_desc = f"Chiều cao cây: {new_value}m (không thay đổi)"
                                changes_detail.append(change_desc)
                            except (ValueError, TypeError):
                                pass
                        
                        # trunk_radius và canopy_diameter chỉ update nếu model có field
                        if trunk_radius and hasattr(tree, 'trunk_radius'):
                            try:
                                new_value = float(trunk_radius)
                                old_value = float(tree.trunk_radius) if tree.trunk_radius else 0
                                tree.trunk_radius = new_value
                                maintenance_log.measurement_trunk_radius = new_value
                                if new_value < old_value:
                                    change_desc = f"Đường kính thân cây giảm từ {old_value}cm xuống {new_value}cm"
                                elif new_value > old_value:
                                    change_desc = f"Đường kính thân cây tăng từ {old_value}cm lên {new_value}cm"
                                else:
                                    change_desc = f"Đường kính thân cây: {new_value}cm (không thay đổi)"
                                changes_detail.append(change_desc)
                            except (ValueError, TypeError):
                                pass
                        
                        if canopy_diameter and hasattr(tree, 'canopy_diameter'):
                            try:
                                new_value = float(canopy_diameter)
                                old_value = float(tree.canopy_diameter) if tree.canopy_diameter else 0
                                tree.canopy_diameter = new_value
                                maintenance_log.measurement_canopy_diameter = new_value
                                if new_value < old_value:
                                    change_desc = f"Diện tích vòm giảm từ {old_value}m² xuống {new_value}m²"
                                elif new_value > old_value:
                                    change_desc = f"Diện tích vòm tăng từ {old_value}m² lên {new_value}m²"
                                else:
                                    change_desc = f"Diện tích vòm: {new_value}m² (không thay đổi)"
                                changes_detail.append(change_desc)
                            except (ValueError, TypeError):
                                pass
                    
                    # Thêm chi tiết thay đổi vào note nếu có
                    if changes_detail:
                        detail_str = " | ".join(changes_detail)
                        if maintenance_log.note:
                            maintenance_log.note = f"{maintenance_log.note} [{detail_str}]"
                        else:
                            maintenance_log.note = detail_str
                    
                    # Lưu MaintenanceLog
                    try:
                        maintenance_log.save()
                    except Exception as e:
                        # Nếu lỗi vì column không tồn tại, save lại mà không new fields
                        if 'does not exist' in str(e).lower():
                            # Tạo mới MaintenanceLog chỉ với fields cơ bản (maintain.note đã có changes_detail)
                            maintenance_log = MaintenanceLog(
                                tree=tree,
                                date=maintenance_date,
                                action=action,
                                performer=performer,
                                note=maintenance_log.note  # Sử dụng note đã được update, không phải note cũ
                            )
                            maintenance_log.save()
                        else:
                            raise
                    
                    # Lưu tree với các thay đổi measurements
                    try:
                        tree.save()
                    except Exception as e:
                        if 'does not exist' in str(e).lower():
                            # Nếu lỗi column không tồn tại, save tất cả measurement fields
                            tree.save(update_fields=['height', 'trunk_radius', 'canopy_diameter'])
                        else:
                            raise
                    
                except Exception as e:
                    messages.error(request, f'❌ Lỗi khi lưu lịch sử chăm sóc: {str(e)}')
                    return redirect('tree_detail', tree_id=tree_id)
                
                log_activity(
                    request,
                    action_type='ADD_MAINTENANCE',
                    entity_type='TREE',
                    entity_code=tree.code,
                    detail=f'Thêm chăm sóc {action} cho cây {tree.code} bởi {performer}',
                )
                
                # Cập nhật trạng thái cây nếu được chọn
                new_status = request.POST.get('new_status', '')
                if new_status and new_status != tree.status:
                    tree.status = new_status
                    tree.save()
                
                messages.success(request, '✅ Thêm lịch sử chăm sóc thành công!')
                return redirect('tree_detail', tree_id=tree_id)
            else:
                messages.error(request, '❌ Vui lòng điền đầy đủ thông tin bắt buộc!')
    
    # Sinh danh sách đề xuất chăm sóc
    suggested_maintenance = generate_maintenance_recommendations(tree)
    
    return render(request, 'tree_detail.html', {
        'tree': tree,
        'logs': logs,
        'status_choices': status_choices,
        'maintenance_choices': maintenance_choices,
        'today': today,
        'tree_images': tree.images.all().order_by('-uploaded_at'),  # Lấy tất cả ảnh, sắp xếp mới nhất trước
        'species_list': TreeSpecies.objects.all(),
        'suggested_maintenance': suggested_maintenance,  # Danh sách đề xuất
        'soil_qualities': tree.soil_qualities.all(),  # Chất lượng đất của cây
    })

# ============ DANH SÁCH CÂY ============
@login_required
def tree_list_view(request):
    query = request.GET.get('q', '')
    status_filter = request.GET.get('status', '')
    
    trees = UrbanTree.objects.all().select_related('species', 'district')
    
    # Apply permission filtering - regular users only see their assigned districts + unspecified trees
    if not request.user.is_staff:
        allowed_districts = District.objects.filter(
            managed_by_users__user=request.user
        ).distinct()
        trees = trees.filter(
            Q(district__in=allowed_districts) | Q(district__isnull=True)
        )
    
    if query:
        trees = trees.filter(
            Q(species__name__icontains=query) | 
            Q(code__icontains=query)
        )
    
    if status_filter:
        trees = trees.filter(status=status_filter)
    
    # Phân trang: 15 cây mỗi trang
    paginator = Paginator(trees, 15)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    status_choices = UrbanTree._meta.get_field('status').choices
    
    return render(request, 'tree_list.html', {
        'page_obj': page_obj,
        'trees': page_obj.object_list,
        'query': query,
        'status_filter': status_filter,
        'status_choices': status_choices,
        'paginator': paginator,
    })

# ============ THÊM CÂY MỚI ============
@login_required
def tree_add_view(request):
    if request.method == 'POST':
        print(f"\n=== DEBUG: tree_add POST request ===")
        print(f"POST data keys: {list(request.POST.keys())}")
        print(f"FILES data keys: {list(request.FILES.keys())}")
        try:
            species_id = request.POST.get('species')
            code_prefix = request.POST.get('code', '').strip()
            planting_year = request.POST.get('planting_year', '').strip()
            address = request.POST.get('address', '')
            locations_json = request.POST.get('locations', '[]')
            statuses = request.POST.getlist('statuses')
            heights = request.POST.getlist('heights')
            trunk_radiuses = request.POST.getlist('trunk_radius')
            canopy_diameters = request.POST.getlist('canopy_diameter')

            locations = json.loads(locations_json)

            if not all([species_id, code_prefix, planting_year]) or len(locations) == 0:
                messages.error(request, '❌ Vui lòng điền đầy đủ thông tin (Loài cây, Mã cây, Năm trồng) và chọn ít nhất 1 vị trí trên bản đồ!')
                return redirect('tree_add')

            species = TreeSpecies.objects.get(id=species_id)
            
            # Handle district assignment
            district_id = request.POST.get('district')
            district = None
            if district_id:
                try:
                    district = District.objects.get(id=district_id)
                    # Validate user permissions - regular users can only assign to their districts
                    if not request.user.is_staff:
                        allowed_districts = District.objects.filter(
                            managed_by_users__user=request.user
                        ).distinct()
                        if not allowed_districts.filter(id=district_id).exists():
                            messages.error(request, '❌ Bạn không có quyền gán cây vào quận/huyện này!')
                            return redirect('tree_add')
                except District.DoesNotExist:
                    messages.error(request, '❌ Quận/huyện không tồn tại!')
                    return redirect('tree_add')

            # Tìm số thứ tự tiếp theo cho prefix
            existing = UrbanTree.objects.filter(code__istartswith=code_prefix).values_list('code', flat=True)
            max_num = 0
            for c in existing:
                suffix = c[len(code_prefix):]
                if suffix.isdigit():
                    max_num = max(max_num, int(suffix))

            created_codes = []
            last_tree = None
            errors = []
            
            for i, loc in enumerate(locations):
                try:
                    num = max_num + i + 1
                    code = f"{code_prefix}{num:03d}"
                    tree_status = statuses[i] if i < len(statuses) else 'TOT'
                    if i < len(heights) and heights[i]:
                        tree_height = float(heights[i])
                    else:
                        tree_height = 0.0
                    
                    # Parse optional measurement fields from each tree
                    tree_trunk_radius = None
                    if i < len(trunk_radiuses) and trunk_radiuses[i]:
                        try:
                            tree_trunk_radius = float(trunk_radiuses[i])
                        except (ValueError, TypeError):
                            tree_trunk_radius = None
                    
                    tree_canopy_diameter = None
                    if i < len(canopy_diameters) and canopy_diameters[i]:
                        try:
                            tree_canopy_diameter = float(canopy_diameters[i])
                        except (ValueError, TypeError):
                            tree_canopy_diameter = None
                    
                    tree_planting_year = None
                    if planting_year:
                        try:
                            tree_planting_year = int(planting_year)
                        except (ValueError, TypeError):
                            error_msg = f"Năm trồng cây không hợp lệ: {planting_year}"
                            raise ValueError(error_msg)
                    
                    tree = UrbanTree(
                        species=species,
                        code=code,
                        height=tree_height,
                        status=tree_status,
                        latitude=float(loc['lat']),
                        longitude=float(loc['lng']),
                        address=address,
                        district=district
                    )
                    
                    # Chỉ set measurement fields nếu model có hỗ trợ
                    if hasattr(UrbanTree, 'trunk_radius'):
                        tree.trunk_radius = tree_trunk_radius
                    if hasattr(UrbanTree, 'canopy_diameter'):
                        tree.canopy_diameter = tree_canopy_diameter
                    if hasattr(UrbanTree, 'planting_year'):
                        tree.planting_year = tree_planting_year
                    
                    # Lấy tất cả ảnh cho cây này từ input images_i
                    tree_images = request.FILES.getlist(f'images_{i}')
                    
                    if tree_images:
                        tree.image = tree_images[0]
                    
                    # Cố gắng save tree, nếu lỗi vì column không tồn tại thì try again chỉ với basic fields
                    try:
                        tree.save()
                    except Exception as e:
                        print(f"❌ Error saving tree {code}: {str(e)}")
                        if 'does not exist' in str(e).lower() or 'unexpected keyword' in str(e).lower():
                            # Columns/fields không tồn tại, save lại mà không dùng measurement fields
                            tree = UrbanTree(
                                species=species,
                                code=code,
                                height=tree_height,
                                status=tree_status,
                                latitude=float(loc['lat']),
                                longitude=float(loc['lng']),
                                address=address
                            )
                            if tree_images:
                                tree.image = tree_images[0]
                            tree.save()
                        else:
                            raise
                    
                    # Thêm chất lượng đất cho cây
                    soil_quality_id = request.POST.get('soil_quality')
                    if soil_quality_id:
                        from .models import SoilQuality
                        try:
                            soil_quality = SoilQuality.objects.get(id=soil_quality_id)
                            tree.soil_qualities.add(soil_quality)
                        except SoilQuality.DoesNotExist:
                            pass
                    
                    # Lưu tất cả ảnh cho cây này vào TreeImage
                    if tree_images:
                        from .models import TreeImage
                        for uploaded_file in tree_images:
                            print(f"DEBUG: Saving image {uploaded_file.name} (size: {uploaded_file.size}) for tree {code}")
                            try:
                                TreeImage.objects.create(
                                    tree=tree,
                                    image=uploaded_file,
                                    caption=''
                                )
                                print(f"  ✓ Image saved successfully")
                            except Exception as e:
                                print(f"  ✗ Error saving image: {str(e)}")
                    
                    log_activity(
                        request,
                        action_type='ADD_TREE',
                        entity_type='TREE',
                        entity_code=code,
                        detail=f'Thêm cây mới {code} ({species.name})',
                    )
                    created_codes.append(code)
                    last_tree = tree
                    print(f"✓ Tree {code} created successfully with {len(tree_images)} images")
                
                except Exception as tree_error:
                    error_msg = f"Lỗi tạo cây #{i+1}: {str(tree_error)}"
                    print(f"✗ {error_msg}")
                    errors.append(error_msg)
                    continue
            
            # Xử lý kết quả
            if errors:
                for err in errors:
                    messages.warning(request, f"⚠️ {err}")
            
            if len(created_codes) == 0:
                messages.error(request, f'❌ Không thêm được cây nào. Vui lòng kiểm tra thông tin!')
                return redirect('tree_add')
            elif len(created_codes) == 1:
                messages.success(request, f'✅ Thêm cây {created_codes[0]} thành công!')
                return redirect('tree_detail', tree_id=last_tree.id)
            else:
                msg = f'✅ Thêm {len(created_codes)} cây thành công: {created_codes[0]} → {created_codes[-1]}'
                if errors:
                    msg += f' (có {len(errors)} lỗi)'
                messages.success(request, msg)
                return redirect('tree_list')

        except ValueError:
            messages.error(request, '❌ Vui lòng nhập dữ liệu đúng định dạng!')
            return redirect('tree_add')
        except Exception as e:
            messages.error(request, f'❌ Lỗi: {str(e)}')
            return redirect('tree_add')

    species_list = TreeSpecies.objects.all()
    status_choices = UrbanTree._meta.get_field('status').choices

    # Get allowed districts based on user permissions
    if request.user.is_staff:
        # Admin can see all districts
        allowed_districts = District.objects.all()
    else:
        # Regular user can only see assigned districts
        allowed_districts = District.objects.filter(
            managed_by_users__user=request.user
        ).distinct()

    # Pass existing trees for map display
    all_trees = UrbanTree.objects.all()
    tree_list_data = []
    for t in all_trees:
        tree_list_data.append({
            'code': t.code,
            'name': t.species.name,
            'status': t.status,
            'lat': t.latitude,
            'long': t.longitude,
        })
    existing_json = json.dumps(tree_list_data)

    # Lấy danh sách chất lượng đất
    from .models import SoilQuality
    soil_qualities = SoilQuality.objects.all()

    return render(request, 'tree_add.html', {
        'species_list': species_list,
        'status_choices': status_choices,
        'existing_json': existing_json,
        'soil_qualities': soil_qualities,
        'districts': allowed_districts,
    })

# ============ XÓA CÂY ============
@login_required
def tree_delete_view(request, tree_id):
    tree = get_object_or_404(UrbanTree, id=tree_id)
    
    if request.method == 'POST':
        code = tree.code
        log_activity(
            request,
            action_type='DELETE_TREE',
            entity_type='TREE',
            entity_code=code,
            detail=f'Xóa cây {code}',
        )
        tree.delete()
        messages.success(request, f'✅ Xóa cây {code} thành công!')
        return redirect('tree_list')
    
    return render(request, 'tree_delete.html', {'tree': tree})


# ============ LOẠI CÂY: DANH SÁCH VÀ THÊM MỚI ============
@login_required
def species_list_view(request):
    species = TreeSpecies.objects.all().order_by('name')
    query = request.GET.get('q', '')
    trait_filter = request.GET.get('trait', '')

    if query:
        species = species.filter(
            Q(name__icontains=query) | Q(characteristics__icontains=query)
        )

    trait_filters = {
        'pest': 'is_pest_prone',
        'fall': 'is_fall_prone',
        'fast': 'is_fast_growing',
        'drought': 'is_drought_sensitive',
        'roots': 'is_invasive_roots',
    }
    if trait_filter in trait_filters:
        species = species.filter(**{trait_filters[trait_filter]: True})

    # Phân trang: 15 loài/trang
    paginator = Paginator(species, 15)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)

    return render(request, 'species_list.html', {
        'page_obj': page_obj,
        'species_list': page_obj.object_list,
        'paginator': paginator,
        'query': query,
        'trait_filter': trait_filter,
        'total_species': TreeSpecies.objects.count(),
    })


@login_required
@admin_required
def species_add_view(request):
    if request.method == 'POST':
        name = request.POST.get('name', '').strip()
        characteristics = request.POST.get('characteristics', '').strip()
        is_pest_prone = 'is_pest_prone' in request.POST
        is_fall_prone = 'is_fall_prone' in request.POST
        is_fast_growing = 'is_fast_growing' in request.POST
        is_drought_sensitive = 'is_drought_sensitive' in request.POST
        is_invasive_roots = 'is_invasive_roots' in request.POST
        watering_freq = int(request.POST.get('watering_frequency_days', 7) or 7)
        inspection_freq = int(request.POST.get('inspection_frequency_days', 90) or 90)

        if not name:
            messages.error(request, '❌ Vui lòng nhập tên loài!')
            return redirect('species_add')

        if TreeSpecies.objects.filter(name__iexact=name).exists():
            messages.error(request, '❌ Loài này đã tồn tại!')
            return redirect('species_add')

        TreeSpecies.objects.create(
            name=name,
            characteristics=characteristics,
            is_pest_prone=is_pest_prone,
            is_fall_prone=is_fall_prone,
            is_fast_growing=is_fast_growing,
            is_drought_sensitive=is_drought_sensitive,
            is_invasive_roots=is_invasive_roots,
            watering_frequency_days=watering_freq,
            inspection_frequency_days=inspection_freq,
        )
        log_activity(
            request,
            action_type='ADD_SPECIES',
            entity_type='SPECIES',
            entity_code=name,
            detail=f'Thêm loài cây {name}',
        )
        messages.success(request, f'✅ Thêm loài "{name}" thành công!')
        return redirect('species_list')

    return render(request, 'species_add.html')


@login_required
@admin_required
def species_edit_view(request, species_id):
    species = get_object_or_404(TreeSpecies, id=species_id)

    if request.method == 'POST':
        name = request.POST.get('name', '').strip()
        characteristics = request.POST.get('characteristics', '').strip()
        is_pest_prone = 'is_pest_prone' in request.POST
        is_fall_prone = 'is_fall_prone' in request.POST
        is_fast_growing = 'is_fast_growing' in request.POST
        is_drought_sensitive = 'is_drought_sensitive' in request.POST
        is_invasive_roots = 'is_invasive_roots' in request.POST
        watering_freq = int(request.POST.get('watering_frequency_days', 7) or 7)
        inspection_freq = int(request.POST.get('inspection_frequency_days', 90) or 90)

        if not name:
            messages.error(request, '❌ Vui lòng nhập tên loài!')
            return redirect('species_edit', species_id=species.id)

        if TreeSpecies.objects.filter(name__iexact=name).exclude(id=species.id).exists():
            messages.error(request, '❌ Loài này đã tồn tại!')
            return redirect('species_edit', species_id=species.id)

        species.name = name
        species.characteristics = characteristics
        species.is_pest_prone = is_pest_prone
        species.is_fall_prone = is_fall_prone
        species.is_fast_growing = is_fast_growing
        species.is_drought_sensitive = is_drought_sensitive
        species.is_invasive_roots = is_invasive_roots
        species.watering_frequency_days = watering_freq
        species.inspection_frequency_days = inspection_freq
        species.save()
        log_activity(
            request,
            action_type='EDIT_SPECIES',
            entity_type='SPECIES',
            entity_code=species.name,
            detail=f'Cập nhật loài cây {species.name}',
        )
        messages.success(request, f'✅ Cập nhật loài "{name}" thành công!')
        return redirect('species_list')

    return render(request, 'species_edit.html', {'species': species})


@login_required
@admin_required
def species_delete_view(request, species_id):
    species = get_object_or_404(TreeSpecies, id=species_id)
    if request.method == 'POST':
        tree_count = UrbanTree.objects.filter(species=species).count()
        if tree_count > 0:
            messages.error(request, f'❌ Không thể xóa! Loài "{species.name}" đang có {tree_count} cây liên kết.')
            return redirect('species_list')
        name = species.name
        log_activity(
            request,
            action_type='DELETE_SPECIES',
            entity_type='SPECIES',
            entity_code=name,
            detail=f'Xóa loài cây {name}',
        )
        species.delete()
        messages.success(request, f'✅ Đã xóa loài "{name}" thành công!')
    return redirect('species_list')


# ============ DASHBOARD BÁO CÁO THỐNG KÊ ============
@login_required
@admin_required
def dashboard_view(request):
    # Pie chart — số cây theo loài
    species_data = list(
        UrbanTree.objects.values('species__name')
        .annotate(count=Count('id'))
        .order_by('-count')
    )
    species_labels = [d['species__name'] for d in species_data]
    species_counts = [d['count'] for d in species_data]

    # Bar chart — trạng thái cây
    status_map = {'TOT': 'Tốt', 'SAU_BENH': 'Sâu bệnh', 'NGUY_HIEM': 'Nguy hiểm'}
    status_data = list(
        UrbanTree.objects.values('status')
        .annotate(count=Count('id'))
        .order_by('status')
    )
    status_labels = [status_map.get(d['status'], d['status']) for d in status_data]
    status_counts = [d['count'] for d in status_data]

    # Line chart — chăm sóc theo tháng (12 tháng gần nhất)
    twelve_months_ago = date.today() - timedelta(days=365)
    monthly_data = list(
        MaintenanceLog.objects.filter(date__gte=twelve_months_ago)
        .annotate(month=TruncMonth('date'))
        .values('month')
        .annotate(count=Count('id'))
        .order_by('month')
    )
    month_labels = [d['month'].strftime('%m/%Y') for d in monthly_data]
    month_counts = [d['count'] for d in monthly_data]

    # Bar chart — công việc chăm sóc theo loại
    action_map = dict(MaintenanceLog._meta.get_field('action').choices)
    action_data = list(
        MaintenanceLog.objects.values('action')
        .annotate(count=Count('id'))
        .order_by('-count')
    )
    action_labels = [action_map.get(d['action'], d['action']) for d in action_data]
    action_counts = [d['count'] for d in action_data]

    # Tổng quan
    total_trees = UrbanTree.objects.count()
    total_species = TreeSpecies.objects.count()
    total_logs = MaintenanceLog.objects.count()

    return render(request, 'dashboard.html', {
        'species_labels': json.dumps(species_labels),
        'species_counts': json.dumps(species_counts),
        'status_labels': json.dumps(status_labels),
        'status_counts': json.dumps(status_counts),
        'month_labels': json.dumps(month_labels),
        'month_counts': json.dumps(month_counts),
        'action_labels': json.dumps(action_labels),
        'action_counts': json.dumps(action_counts),
        'total_trees': total_trees,
        'total_species': total_species,
        'total_logs': total_logs,
    })


# ============ EXPORT EXCEL/CSV ============
@login_required
@admin_required
def export_trees_csv(request):
    response = HttpResponse(content_type='text/csv; charset=utf-8-sig')
    response['Content-Disposition'] = 'attachment; filename="danh_sach_cay.csv"'
    response.write('\ufeff')  # BOM for Excel UTF-8
    writer = csv.writer(response)
    writer.writerow(['Mã cây', 'Loài', 'Chiều cao (m)', 'Trạng thái', 'Vĩ độ', 'Kinh độ', 'Địa chỉ'])
    status_map = {'TOT': 'Tốt', 'SAU_BENH': 'Sâu bệnh', 'NGUY_HIEM': 'Nguy hiểm'}
    for t in UrbanTree.objects.select_related('species').order_by('code'):
        writer.writerow([t.code, t.species.name, t.height, status_map.get(t.status, t.status), t.latitude, t.longitude, t.address])
    return response


@login_required
@admin_required
def export_maintenance_csv(request):
    response = HttpResponse(content_type='text/csv; charset=utf-8-sig')
    response['Content-Disposition'] = 'attachment; filename="lich_su_cham_soc.csv"'
    response.write('\ufeff')
    writer = csv.writer(response)
    writer.writerow(['Mã cây', 'Loài', 'Ngày', 'Công việc', 'Người thực hiện', 'Ghi chú'])
    action_map = dict(MaintenanceLog._meta.get_field('action').choices)
    for log in MaintenanceLog.objects.select_related('tree', 'tree__species').order_by('-date'):
        writer.writerow([log.tree.code, log.tree.species.name, log.date.strftime('%d/%m/%Y'), action_map.get(log.action, log.action), log.performer, log.note])
    return response


# ============ LỊCH CHĂM SÓC ============
@login_required
def maintenance_list_view(request):
    query = request.GET.get('q', '')
    action_filter = request.GET.get('action', '')

    logs = MaintenanceLog.objects.select_related('tree', 'tree__species').order_by('-date')

    if query:
        logs = logs.filter(
            Q(tree__code__icontains=query) |
            Q(tree__species__name__icontains=query) |
            Q(performer__icontains=query)
        )

    if action_filter:
        logs = logs.filter(action=action_filter)

    action_choices = MaintenanceLog._meta.get_field('action').choices

    # ============ AI ĐỀ XUẤT CHĂM SÓC ============
    today = date.today()
    recommendations = []

    trees = UrbanTree.objects.select_related('species').all()

    for tree in trees:
        species = tree.species

        # 1. Kiểm tra định kỳ quá hạn
        last_inspection = MaintenanceLog.objects.filter(
            tree=tree, action='KIEM_TRA'
        ).order_by('-date').values_list('date', flat=True).first()

        inspection_freq = species.inspection_frequency_days
        if last_inspection:
            last_inspection_date = last_inspection.date() if hasattr(last_inspection, 'date') else last_inspection
            days_since_inspection = (today - last_inspection_date).days
            if days_since_inspection >= inspection_freq:
                urgency = 'high' if days_since_inspection >= inspection_freq * 2 else 'medium'
                recommendations.append({
                    'tree': tree,
                    'type': 'inspection',
                    'icon': 'fa-clipboard-check',
                    'color': '#e74c3c' if urgency == 'high' else '#f39c12',
                    'urgency': urgency,
                    'title': 'Cần kiểm tra định kỳ',
                    'detail': f'Lần kiểm tra cuối: {last_inspection.strftime("%d/%m/%Y")} ({days_since_inspection} ngày trước). Chu kỳ: {inspection_freq} ngày.',
                    'days_overdue': days_since_inspection - inspection_freq,
                })
        else:
            recommendations.append({
                'tree': tree,
                'type': 'inspection',
                'icon': 'fa-clipboard-check',
                'color': '#e74c3c',
                'urgency': 'high',
                'title': 'Chưa từng kiểm tra',
                'detail': f'Cây chưa có lịch sử kiểm tra. Chu kỳ khuyến nghị: {inspection_freq} ngày.',
                'days_overdue': 999,
            })

        # 2. Tưới nước quá hạn
        last_watering = MaintenanceLog.objects.filter(
            tree=tree, action='TUOI_NUOC'
        ).order_by('-date').values_list('date', flat=True).first()

        watering_freq = species.watering_frequency_days
        if last_watering:
            last_watering_date = last_watering.date() if hasattr(last_watering, 'date') else last_watering
            days_since_water = (today - last_watering_date).days
            if days_since_water >= watering_freq:
                urgency = 'high' if days_since_water >= watering_freq * 3 else 'medium'
                recommendations.append({
                    'tree': tree,
                    'type': 'watering',
                    'icon': 'fa-droplet',
                    'color': '#3498db',
                    'urgency': urgency,
                    'title': 'Cần tưới nước',
                    'detail': f'Lần tưới cuối: {last_watering.strftime("%d/%m/%Y")} ({days_since_water} ngày trước). Chu kỳ: {watering_freq} ngày.',
                    'days_overdue': days_since_water - watering_freq,
                })

        # 3. Cây dễ sâu bệnh cần phun thuốc
        if species.is_pest_prone:
            last_spray = MaintenanceLog.objects.filter(
                tree=tree, action='PHUN_THUOC'
            ).order_by('-date').values_list('date', flat=True).first()

            if last_spray:
                last_spray_date = last_spray.date() if hasattr(last_spray, 'date') else last_spray
                days_since_spray = (today - last_spray_date).days
                if days_since_spray >= 60:
                    recommendations.append({
                        'tree': tree,
                        'type': 'pest',
                        'icon': 'fa-bug',
                        'color': '#e67e22',
                        'urgency': 'high' if days_since_spray >= 120 else 'medium',
                        'title': 'Cần phun thuốc phòng sâu bệnh',
                        'detail': f'Loài dễ sâu bệnh. Lần phun cuối: {last_spray.strftime("%d/%m/%Y")} ({days_since_spray} ngày trước).',
                        'days_overdue': days_since_spray - 60,
                    })
            else:
                recommendations.append({
                    'tree': tree,
                    'type': 'pest',
                    'icon': 'fa-bug',
                    'color': '#e74c3c',
                    'urgency': 'high',
                    'title': 'Cần phun thuốc phòng sâu bệnh',
                    'detail': f'Loài dễ sâu bệnh nhưng chưa từng được phun thuốc.',
                    'days_overdue': 999,
                })

        # 4. Cây đang ở trạng thái xấu
        if tree.status == 'SAU_BENH':
            last_any = MaintenanceLog.objects.filter(
                tree=tree
            ).order_by('-date').values_list('date', flat=True).first()
            last_any_date = last_any.date() if (last_any and hasattr(last_any, 'date')) else last_any
            days_no_care = (today - last_any_date).days if last_any_date else 999
            if days_no_care >= 14:
                recommendations.append({
                    'tree': tree,
                    'type': 'health',
                    'icon': 'fa-heart-pulse',
                    'color': '#e74c3c',
                    'urgency': 'high',
                    'title': 'Cây đang sâu bệnh — cần chăm sóc gấp',
                    'detail': f'Trạng thái: Sâu bệnh. {"Chưa được chăm sóc gần đây." if days_no_care >= 30 else f"Lần chăm sóc cuối: {days_no_care} ngày trước."}',
                    'days_overdue': days_no_care,
                })

        if tree.status == 'NGUY_HIEM':
            recommendations.append({
                'tree': tree,
                'type': 'danger',
                'icon': 'fa-triangle-exclamation',
                'color': '#c0392b',
                'urgency': 'critical',
                'title': 'Cây nguy hiểm — cần xử lý ngay',
                'detail': 'Cây đang ở trạng thái nguy hiểm, cần kiểm tra và xử lý khẩn cấp.',
                'days_overdue': 9999,
            })

        # 5. Cây dễ đổ — cần kiểm tra sau mưa/bão
        if species.is_fall_prone:
            last_check = MaintenanceLog.objects.filter(
                tree=tree, action='KIEM_TRA'
            ).order_by('-date').values_list('date', flat=True).first()
            last_check_date = last_check.date() if (last_check and hasattr(last_check, 'date')) else last_check
            days_since = (today - last_check_date).days if last_check_date else 999
            if days_since >= 30:
                recommendations.append({
                    'tree': tree,
                    'type': 'fall',
                    'icon': 'fa-wind',
                    'color': '#9b59b6',
                    'urgency': 'high' if days_since >= 60 else 'medium',
                    'title': 'Loài dễ đổ — cần kiểm tra thân/rễ',
                    'detail': f'Loài dễ đổ/gãy khi gió lớn. {"Chưa từng kiểm tra." if days_since >= 999 else f"Lần kiểm tra cuối: {days_since} ngày trước."}',
                    'days_overdue': days_since - 30,
                })

        # 6. Cây mọc nhanh — cần cắt tỉa
        if species.is_fast_growing:
            last_prune = MaintenanceLog.objects.filter(
                tree=tree, action='CAT_TIA'
            ).order_by('-date').values_list('date', flat=True).first()
            last_prune_date = last_prune.date() if (last_prune and hasattr(last_prune, 'date')) else last_prune
            days_since = (today - last_prune_date).days if last_prune else 999
            if days_since >= 45:
                recommendations.append({
                    'tree': tree,
                    'type': 'pruning',
                    'icon': 'fa-scissors',
                    'color': '#27ae60',
                    'urgency': 'high' if days_since >= 90 else 'medium',
                    'title': 'Cần cắt tỉa — loài mọc nhanh',
                    'detail': f'Loài mọc nhanh cần cắt tỉa thường xuyên. {"Chưa từng cắt tỉa." if days_since >= 999 else f"Lần cắt cuối: {days_since} ngày trước."}',
                    'days_overdue': days_since - 45,
                })

        # 7. Nhạy cảm hạn hán — ưu tiên tưới
        if species.is_drought_sensitive:
            last_water = MaintenanceLog.objects.filter(
                tree=tree, action='TUOI_NUOC'
            ).order_by('-date').values_list('date', flat=True).first()
            last_water_date = last_water.date() if (last_water and hasattr(last_water, 'date')) else last_water
            days_since = (today - last_water_date).days if last_water else 999
            freq = max(species.watering_frequency_days // 2, 3)  # tưới gấp đôi tần suất
            if days_since >= freq:
                recommendations.append({
                    'tree': tree,
                    'type': 'drought',
                    'icon': 'fa-sun',
                    'color': '#f1c40f',
                    'urgency': 'high' if days_since >= freq * 3 else 'medium',
                    'title': 'Nhạy hạn — cần tưới ưu tiên',
                    'detail': f'Loài nhạy cảm hạn hán, cần tưới mỗi {freq} ngày. {"Chưa từng tưới." if days_since >= 999 else f"Lần tưới cuối: {days_since} ngày trước."}',
                    'days_overdue': days_since - freq,
                })

        # 8. Rễ xâm lấn — cần kiểm tra hệ rễ
        if species.is_invasive_roots:
            last_check = MaintenanceLog.objects.filter(
                tree=tree, action='KIEM_TRA'
            ).order_by('-date').values_list('date', flat=True).first()
            last_check_roots_date = last_check.date() if (last_check and hasattr(last_check, 'date')) else last_check
            days_since = (today - last_check_roots_date).days if last_check else 999
            if days_since >= 60:
                recommendations.append({
                    'tree': tree,
                    'type': 'roots',
                    'icon': 'fa-diagram-project',
                    'color': '#7f8c8d',
                    'urgency': 'medium',
                    'title': 'Rễ xâm lấn — kiểm tra hạ tầng',
                    'detail': f'Loài có rễ xâm lấn, có thể ảnh hưởng vỉa hè/công trình. {"Chưa từng kiểm tra." if days_since >= 999 else f"Lần kiểm tra cuối: {days_since} ngày trước."}',
                    'days_overdue': days_since - 60,
                })

    # Sắp xếp: critical > high > medium
    urgency_order = {'critical': 0, 'high': 1, 'medium': 2}
    recommendations.sort(key=lambda r: (urgency_order.get(r['urgency'], 3), -r['days_overdue']))

    # Gộp đề xuất theo từng cây — mỗi cây chỉ hiện 1 lần
    grouped = {}
    for rec in recommendations:
        tree_id = rec['tree'].id
        if tree_id not in grouped:
            grouped[tree_id] = {
                'tree': rec['tree'],
                'urgency': rec['urgency'],
                'max_overdue': rec['days_overdue'],
                'issues': [],
            }
        g = grouped[tree_id]
        # Giữ urgency cao nhất
        if urgency_order.get(rec['urgency'], 3) < urgency_order.get(g['urgency'], 3):
            g['urgency'] = rec['urgency']
        if rec['days_overdue'] > g['max_overdue']:
            g['max_overdue'] = rec['days_overdue']
        g['issues'].append({
            'type': rec['type'],
            'icon': rec['icon'],
            'color': rec['color'],
            'title': rec['title'],
            'detail': rec['detail'],
        })

    grouped_recommendations = list(grouped.values())
    grouped_recommendations.sort(key=lambda g: (urgency_order.get(g['urgency'], 3), -g['max_overdue']))

    # Lọc đề xuất theo search query (mã cây hoặc tên loài)
    if query:
        grouped_recommendations = [
            g for g in grouped_recommendations
            if query.lower() in g['tree'].code.lower() or 
               query.lower() in g['tree'].species.name.lower()
        ]

    # Thống kê đề xuất
    stats = {
        'total': len(grouped_recommendations),
        'critical': sum(1 for g in grouped_recommendations if g['urgency'] == 'critical'),
        'high': sum(1 for g in grouped_recommendations if g['urgency'] == 'high'),
        'medium': sum(1 for g in grouped_recommendations if g['urgency'] == 'medium'),
        'total_issues': len(recommendations),
    }

    # Phân trang: lịch chăm sóc (10 items mỗi trang)
    paginator_logs = Paginator(logs, 10)
    page_logs = request.GET.get('page_logs', 1)
    page_obj_logs = paginator_logs.get_page(page_logs)

    # Phân trang: đề xuất chăm sóc (8 items mỗi trang)
    paginator_recs = Paginator(grouped_recommendations, 8)
    page_recs = request.GET.get('page_recs', 1)
    page_obj_recs = paginator_recs.get_page(page_recs)

    return render(request, 'maintenance_list.html', {
        'page_obj_logs': page_obj_logs,
        'logs': page_obj_logs.object_list,
        'query': query,
        'action_filter': action_filter,
        'action_choices': action_choices,
        'page_obj_recs': page_obj_recs,
        'recommendations': page_obj_recs.object_list,
        'ai_stats': stats,
        'today': today,
    })


# ============ API: BULK MAINTENANCE ============
@login_required
@require_POST
def bulk_maintenance_view(request):
    """
    API endpoint để tạo maintenance logs cho nhiều cây cùng lúc.
    Nhận POST request với JSON:
    {
        "tree_ids": [1, 2, 3, ...],
        "performer": "Tên người chăm sóc",
        "action": "CAT_TIA|BON_PHAN|PHUN_THUOC|KIEM_TRA|TUOI_NUOC",
        "date": "2024-01-15",
        "note": "Ghi chú (tuỳ chọn)"
    }
    """
    try:
        import json
        data = json.loads(request.body)
        
        tree_ids = data.get('tree_ids', [])
        performer = data.get('performer', '').strip()
        action = data.get('action', '').strip()
        maintenance_date = data.get('date', '').strip()
        note = data.get('note', '').strip()
        
        # Validation
        if not tree_ids or not isinstance(tree_ids, list):
            return JsonResponse({'status': 'error', 'error': 'Danh sách cây trống hoặc không hợp lệ'}, status=400)
        
        if not performer:
            return JsonResponse({'status': 'error', 'error': 'Vui lòng nhập tên người chăm sóc'}, status=400)
        
        if not action:
            return JsonResponse({'status': 'error', 'error': 'Vui lòng chọn loại công việc'}, status=400)
        
        if not maintenance_date:
            return JsonResponse({'status': 'error', 'error': 'Vui lòng cung cấp ngày'}, status=400)
        
        # Validate action c choices
        valid_actions = ['CAT_TIA', 'BON_PHAN', 'PHUN_THUOC', 'KIEM_TRA', 'TUOI_NUOC']
        if action not in valid_actions:
            return JsonResponse({'status': 'error', 'error': f'Loại công việc không hợp lệ'}, status=400)
        
        # Get all trees and check they exist
        trees = UrbanTree.objects.filter(id__in=tree_ids)
        if trees.count() != len(tree_ids):
            return JsonResponse({'status': 'error', 'error': 'Một số cây không tồn tại'}, status=400)
        
        # Create maintenance logs for each tree
        created_count = 0
        for tree in trees:
            MaintenanceLog.objects.create(
                tree=tree,
                date=maintenance_date,
                action=action,
                performer=performer,
                note=note
            )
            created_count += 1

        log_activity(
            request,
            action_type='BULK_MAINTENANCE',
            entity_type='TREE',
            entity_code=f'{created_count} cây',
            detail=f'Chăm sóc hàng loạt {action} cho {created_count} cây bởi {performer}',
        )
        
        return JsonResponse({
            'status': 'ok',
            'count': created_count,
            'message': f'Thực hiện kiểm tra cho {created_count} cây'
        })
    
    except json.JSONDecodeError:
        return JsonResponse({'status': 'error', 'error': 'Dữ liệu JSON không hợp lệ'}, status=400)
    except ValueError as e:
        return JsonResponse({'status': 'error', 'error': f'Lỗi: {str(e)}'}, status=400)
    except Exception as e:
        return JsonResponse({'status': 'error', 'error': f'Lỗi server: {str(e)}'}, status=500)


# ============ CUSTOM LOGOUT VIEW ============
@require_POST
@csrf_exempt  # In development, bypass CSRF check that fails with null origins
def custom_logout_view(request):
    """Custom logout view that handles logout properly"""
    logout(request)
    return redirect('login')


# ============ CSRF FAILURE VIEW ============
def csrf_failure(request, reason=""):
    """Custom CSRF failure view"""
    return render(request, 'csrf_error.html', {'reason': reason}, status=403)


# ============ ADMIN DASHBOARD ============
@login_required
@admin_required
def admin_dashboard_view(request):
    """Admin dashboard - Statistics and management"""
    from django.contrib.auth.models import User
    
    total_users = User.objects.count()
    admin_users = User.objects.filter(is_staff=True).count()
    regular_users = total_users - admin_users
    
    total_trees = UrbanTree.objects.count()
    total_species = TreeSpecies.objects.count()
    total_logs = MaintenanceLog.objects.count()
    total_zones = ManagementZone.objects.count()
    active_users = User.objects.filter(is_active=True).count()
    inactive_users = total_users - active_users
    new_users_this_week = User.objects.filter(date_joined__date__gte=(date.today() - timedelta(days=6))).count()
    
    # Recent users
    recent_users = User.objects.order_by('-date_joined')[:5]
    
    # Recent activities
    recent_trees = UrbanTree.objects.order_by('-id')[:5]
    recent_logs = MaintenanceLog.objects.order_by('-date')[:5]

    # Registration chart data (last 7 days)
    chart_days = [date.today() - timedelta(days=i) for i in range(6, -1, -1)]
    registrations_by_day = []
    labels_by_day = []
    for d in chart_days:
        labels_by_day.append(d.strftime('%d/%m'))
        registrations_by_day.append(User.objects.filter(date_joined__date=d).count())
    
    context = {
        'total_users': total_users,
        'admin_users': admin_users,
        'regular_users': regular_users,
        'total_trees': total_trees,
        'total_species': total_species,
        'total_logs': total_logs,
        'total_zones': total_zones,
        'active_users': active_users,
        'inactive_users': inactive_users,
        'new_users_this_week': new_users_this_week,
        'recent_users': recent_users,
        'recent_trees': recent_trees,
        'recent_logs': recent_logs,
        'registration_labels_json': json.dumps(labels_by_day),
        'registration_values_json': json.dumps(registrations_by_day),
        'user_status_values_json': json.dumps([active_users, inactive_users]),
        'now': timezone.localtime(),
    }
    
    return render(request, 'admin_dashboard.html', context)


# ============ ADMIN USER MANAGEMENT ============
@login_required
@admin_required
def admin_users_view(request):
    """Admin user management page"""
    from django.contrib.auth.models import User

    # Handle create new user
    if request.method == 'POST' and 'create_user' in request.POST:
        username = request.POST.get('new_username', '').strip()
        email = request.POST.get('new_email', '').strip()
        password = request.POST.get('new_password', '').strip()
        is_staff = 'new_is_staff' in request.POST
        is_active = 'new_is_active' in request.POST
        first_name = request.POST.get('new_first_name', '').strip()
        last_name = request.POST.get('new_last_name', '').strip()

        if not username or not password:
            messages.error(request, '❌ Username và Password không được để trống')
        elif len(password) < 8:
            messages.error(request, '❌ Password phải có ít nhất 8 ký tự')
        elif User.objects.filter(username=username).exists():
            messages.error(request, f'❌ Username "{username}" đã tồn tại')
        elif len(first_name) > 150 or len(last_name) > 150:
            messages.error(request, '❌ Họ hoặc tên quá dài (tối đa 150 ký tự)')
        elif email:
            try:
                validate_email(email)
                if User.objects.filter(email__iexact=email).exists():
                    messages.error(request, f'❌ Email "{email}" đã được sử dụng')
                    return redirect('admin_users')
            except ValidationError:
                messages.error(request, '❌ Email không hợp lệ')
                return redirect('admin_users')
            try:
                validate_password(password)
            except ValidationError as e:
                for err in e.messages:
                    messages.error(request, f'❌ {err}')
                return redirect('admin_users')
            try:
                User.objects.create_user(
                    username=username,
                    email=email,
                    password=password,
                    first_name=first_name,
                    last_name=last_name,
                    is_staff=is_staff,
                    is_active=is_active,
                )
                messages.success(request, f'✅ Tạo người dùng {username} thành công')
            except Exception as e:
                messages.error(request, f'❌ Lỗi: {str(e)}')
            return redirect('admin_users')
        else:
            try:
                validate_password(password)
            except ValidationError as e:
                for err in e.messages:
                    messages.error(request, f'❌ {err}')
                return redirect('admin_users')
            try:
                User.objects.create_user(
                    username=username,
                    email=email,
                    password=password,
                    first_name=first_name,
                    last_name=last_name,
                    is_staff=is_staff,
                    is_active=is_active,
                )
                messages.success(request, f'✅ Tạo người dùng {username} thành công')
            except Exception as e:
                messages.error(request, f'❌ Lỗi: {str(e)}')
        return redirect('admin_users')
    
    # Handle user permission toggle
    if request.method == 'POST' and 'toggle_admin' in request.POST:
        user_id = request.POST.get('user_id')
        try:
            user = User.objects.get(id=user_id)
            if user.id != request.user.id:  # Không cho phép tự thay đổi quyền
                user.is_staff = not user.is_staff
                user.save()
                messages.success(request, f'✅ Đã cập nhật quyền cho {user.username}')
            else:
                messages.error(request, '❌ Bạn không thể thay đổi quyền của chính mình')
        except User.DoesNotExist:
            messages.error(request, '❌ Người dùng không tồn tại')
        return redirect('admin_users')

    # Handle user active/banned toggle
    if request.method == 'POST' and 'toggle_active' in request.POST:
        user_id = request.POST.get('user_id')
        try:
            user = User.objects.get(id=user_id)
            if user.id != request.user.id:
                user.is_active = not user.is_active
                user.save(update_fields=['is_active'])
                state = 'kích hoạt' if user.is_active else 'khóa'
                messages.success(request, f'✅ Đã {state} tài khoản {user.username}')
            else:
                messages.error(request, '❌ Bạn không thể khóa tài khoản của chính mình')
        except User.DoesNotExist:
            messages.error(request, '❌ Người dùng không tồn tại')
        return redirect('admin_users')

    # Handle edit user profile from modal
    if request.method == 'POST' and 'edit_user' in request.POST:
        user_id = request.POST.get('user_id')
        try:
            target = User.objects.get(id=user_id)
            edit_email = request.POST.get('edit_email', '').strip()
            edit_first_name = request.POST.get('edit_first_name', '').strip()
            edit_last_name = request.POST.get('edit_last_name', '').strip()
            edit_is_staff = 'edit_is_staff' in request.POST
            edit_is_active = 'edit_is_active' in request.POST

            if edit_email:
                try:
                    validate_email(edit_email)
                except ValidationError:
                    messages.error(request, '❌ Email không hợp lệ')
                    return redirect('admin_users')
                if User.objects.filter(email__iexact=edit_email).exclude(id=target.id).exists():
                    messages.error(request, '❌ Email này đã được tài khoản khác sử dụng')
                    return redirect('admin_users')

            if len(edit_first_name) > 150 or len(edit_last_name) > 150:
                messages.error(request, '❌ Họ hoặc tên quá dài (tối đa 150 ký tự)')
                return redirect('admin_users')

            if target.id == request.user.id and not edit_is_staff:
                messages.error(request, '❌ Bạn không thể tự hạ quyền Admin của chính mình')
                return redirect('admin_users')

            if target.id == request.user.id and not edit_is_active:
                messages.error(request, '❌ Bạn không thể tự khóa tài khoản của chính mình')
                return redirect('admin_users')

            target.email = edit_email
            target.first_name = edit_first_name
            target.last_name = edit_last_name
            target.is_staff = edit_is_staff
            target.is_active = edit_is_active
            target.save()
            messages.success(request, f'✅ Đã cập nhật thông tin người dùng {target.username}')
        except User.DoesNotExist:
            messages.error(request, '❌ Người dùng không tồn tại')
        return redirect('admin_users')
    
    # Handle delete user
    if request.method == 'POST' and 'delete_user' in request.POST:
        user_id = request.POST.get('user_id')
        try:
            user = User.objects.get(id=user_id)
            if user.id != request.user.id:
                username = user.username
                user.delete()
                messages.success(request, f'✅ Đã xóa người dùng {username}')
            else:
                messages.error(request, '❌ Bạn không thể xóa chính mình')
        except User.DoesNotExist:
            messages.error(request, '❌ Người dùng không tồn tại')
        return redirect('admin_users')
    
    # Query with search/filter/pagination
    q = request.GET.get('q', '').strip()
    role = request.GET.get('role', '').strip()
    status = request.GET.get('status', '').strip()

    users_qs = User.objects.all().order_by('-date_joined')
    if q:
        users_qs = users_qs.filter(
            Q(username__icontains=q)
            | Q(email__icontains=q)
            | Q(first_name__icontains=q)
            | Q(last_name__icontains=q)
        )
    if role == 'admin':
        users_qs = users_qs.filter(is_staff=True)
    elif role == 'user':
        users_qs = users_qs.filter(is_staff=False)
    if status == 'active':
        users_qs = users_qs.filter(is_active=True)
    elif status == 'banned':
        users_qs = users_qs.filter(is_active=False)

    paginator = Paginator(users_qs, 10)
    page_obj = paginator.get_page(request.GET.get('page'))
    
    context = {
        'users': page_obj,
        'page_obj': page_obj,
        'total_users': User.objects.count(),
        'admin_users': User.objects.filter(is_staff=True).count(),
        'regular_users': User.objects.filter(is_staff=False).count(),
        'active_users': User.objects.filter(is_active=True).count(),
        'banned_users': User.objects.filter(is_active=False).count(),
        'q': q,
        'selected_role': role,
        'selected_status': status,
    }
    
    return render(request, 'admin_users.html', context)


# ============ ADMIN DISTRICT PERMISSIONS ============
@login_required
@admin_required
def admin_district_permissions_view(request):
    """Admin page to manage user-district permissions"""
    from django.contrib.auth.models import User
    
    # Handle POST requests (add/remove permissions)
    if request.method == 'POST':
        action = request.POST.get('action')
        user_id = request.POST.get('user_id')
        district_id = request.POST.get('district_id')
        
        try:
            user = User.objects.get(id=user_id)
            district = District.objects.get(id=district_id)
            
            if action == 'add':
                umd, created = UserManagedDistrict.objects.get_or_create(
                    user=user, district=district
                )
                if created:
                    messages.success(request, f'✅ Gán quận/huyện "{district.name}" cho user "{user.username}" thành công')
                    log_activity(request, 'ADD_DISTRICT_PERM', 'USER_DISTRICT', f'{user.username}-{district.name}', f'Gán quyền quận {district.name} cho {user.username}')
                else:
                    messages.info(request, f'ℹ️ User "{user.username}" đã được gán quận/huyện "{district.name}"')
            
            elif action == 'remove':
                try:
                    umd = UserManagedDistrict.objects.get(user=user, district=district)
                    umd.delete()
                    messages.success(request, f'✅ Xóa quyền quận/huyện "{district.name}" của user "{user.username}" thành công')
                    log_activity(request, 'REMOVE_DISTRICT_PERM', 'USER_DISTRICT', f'{user.username}-{district.name}', f'Xóa quyền quận {district.name} của {user.username}')
                except UserManagedDistrict.DoesNotExist:
                    messages.warning(request, f'⚠️ User "{user.username}" không có quyền quản lý quận/huyện "{district.name}"')
        
        except User.DoesNotExist:
            messages.error(request, '❌ User không tồn tại')
        except District.DoesNotExist:
            messages.error(request, '❌ Quận/huyện không tồn tại')
        except Exception as e:
            messages.error(request, f'❌ Lỗi: {str(e)}')
        
        return redirect('admin_district_permissions')
    
    # GET request - display the permission management page
    # Tìm kiếm: filter theo username hoặc email
    search_query = request.GET.get('q', '').strip()
    
    if search_query:
        users_qs = User.objects.filter(
            Q(username__icontains=search_query) | 
            Q(email__icontains=search_query) |
            Q(first_name__icontains=search_query) |
            Q(last_name__icontains=search_query)
        ).filter(is_active=True).order_by('username')
    else:
        users_qs = User.objects.filter(is_active=True).order_by('username')
    
    districts = District.objects.all().order_by('name')
    
    # Phân trang: 10 users/trang
    paginator = Paginator(users_qs, 10)
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)
    
    # Build user-district matrix for displayed page only
    user_district_list = []
    total_permissions = 0
    
    for user in page_obj.object_list:
        user_districts = UserManagedDistrict.objects.filter(user=user).values_list('district_id', flat=True)
        user_districts_set = set(user_districts)
        total_permissions += len(user_districts_set)
        
        user_district_list.append({
            'user': user,
            'district_ids': user_districts_set,
            'total': len(user_districts_set)
        })
    
    context = {
        'page_obj': page_obj,
        'users': page_obj.object_list,
        'districts': districts,
        'user_district_list': user_district_list,
        'paginator': paginator,
        'total_users': User.objects.filter(is_active=True).count(),
        'total_districts': len(districts),
        'total_permissions': total_permissions,
        'search_query': search_query,
    }
    
    return render(request, 'admin_permissions.html', context)


# ============ ADMIN ACTIVITY LOGS ============
@login_required
@admin_required
def admin_activity_view(request):
    q = request.GET.get('q', '')
    action_type = request.GET.get('action_type', '')
    entity_type = request.GET.get('entity_type', '')
    
    activities = ActivityLog.objects.select_related('user').order_by('-created_at')
    
    if q:
        activities = activities.filter(
            Q(entity_code__icontains=q) |
            Q(detail__icontains=q) |
            Q(user__username__icontains=q)
        )
    if action_type:
        activities = activities.filter(action_type=action_type)
    if entity_type:
        activities = activities.filter(entity_type=entity_type)
    
    paginator = Paginator(activities, 20)
    page_obj = paginator.get_page(request.GET.get('page'))
    
    context = {
        'page_obj': page_obj,
        'logs': page_obj.object_list,
        'q': q,
        'action_type': action_type,
        'entity_type': entity_type,
        'selected_action': action_type,
        'action_choices': ActivityLog.ACTION_CHOICES,
        'total_activities': ActivityLog.objects.count(),
    }
    
    return render(request, 'admin_activity.html', context)


# ============ ERROR HANDLERS ============
def custom_404_view(request, exception=None):
    """Custom 404 error page handler."""
    return render(request, '404.html', status=404)


def custom_500_view(request):
    """Custom 500 error page handler."""
    return render(request, '500.html', status=500)


# ============ IMPORT EXCEL/CSV ============
@login_required
@admin_required
def import_maintenance_view(request):
    """Import maintenance logs from Excel/CSV file"""
    from .forms import MaintenanceImportForm, get_file_parser
    
    if request.method == 'POST':
        form = MaintenanceImportForm(request.POST, request.FILES)
        if form.is_valid():
            file = request.FILES['file']
            file_name = file.name
            
            # Chọn parser phù hợp
            parser = get_file_parser(file_name)
            if not parser:
                messages.error(request, '❌ Định dạng file không được hỗ trợ!')
                return redirect('import_maintenance')
            
            # Phân tích file
            rows, error = parser(file)
            if error:
                messages.error(request, f'❌ Lỗi khi đọc file: {error}')
                return redirect('import_maintenance')
            
            if not rows:
                messages.error(request, '❌ File không có dữ liệu!')
                return redirect('import_maintenance')
            
            # Xử lý từng dòng
            success_count = 0
            error_list = []
            
            for row_idx, row in enumerate(rows, 2):  # Bắt đầu từ dòng 2 (dòng 1 là header)
                try:
                    # Lấy dữ liệu từ file
                    tree_code = str(row.get('Mã cây', '')).strip()
                    date_str = str(row.get('Ngày', '')).strip()
                    action = str(row.get('Công việc', '')).strip()
                    performer = str(row.get('Người thực hiện', '')).strip()
                    note = str(row.get('Ghi chú', '')).strip() if 'Ghi chú' in row else ''
                    
                    # Validation
                    if not all([tree_code, date_str, action, performer]):
                        error_list.append(f"Dòng {row_idx}: Thiếu dữ liệu bắt buộc (Mã cây, Ngày, Công việc, Người thực hiện)")
                        continue
                    
                    # Tìm cây theo mã
                    try:
                        tree = UrbanTree.objects.get(code__iexact=tree_code)
                    except UrbanTree.DoesNotExist:
                        error_list.append(f"Dòng {row_idx}: Cây với mã '{tree_code}' không tồn tại!")
                        continue
                    
                    # Kiểm tra hành động (action) có hợp lệ không
                    action_choices = dict(MaintenanceLog._meta.get_field('action').choices)
                    action_key = None
                    
                    # Thử match dựa vào key hoặc display name
                    for key, display_name in action_choices.items():
                        if action.upper() == key or action == display_name:
                            action_key = key
                            break
                    
                    if not action_key:
                        error_list.append(f"Dòng {row_idx}: Hành động '{action}' không hợp lệ. Các hành động được phép: {', '.join(action_choices.values())}")
                        continue
                    
                    # Phân tích ngày (dự kiến format: dd/mm/yyyy hoặc yyyy-mm-dd)
                    try:
                        # Thử định dạng dd/mm/yyyy
                        if '/' in date_str:
                            date_parts = date_str.split('/')
                            if len(date_parts) == 3:
                                day, month, year = int(date_parts[0]), int(date_parts[1]), int(date_parts[2])
                                maintenance_date = date(year, month, day)
                            else:
                                raise ValueError("Định dạng ngày không hợp lệ")
                        else:
                            # Thử định dạng yyyy-mm-dd
                            from datetime import datetime as dt
                            maintenance_date = dt.strptime(date_str, '%Y-%m-%d').date()
                    except Exception as date_error:
                        error_list.append(f"Dòng {row_idx}: Ngày '{date_str}' không hợp lệ. Sử dụng định dạng dd/mm/yyyy hoặc yyyy-mm-dd")
                        continue
                    
                    # Kiểm tra xem log đã tồn tại chưa
                    if MaintenanceLog.objects.filter(
                        tree=tree,
                        date=maintenance_date,
                        action=action_key,
                        performer__iexact=performer
                    ).exists():
                        error_list.append(f"Dòng {row_idx}: Log này đã tồn tại (cùng cây, ngày, hành động, người thực hiện)")
                        continue
                    
                    # Tạo MaintenanceLog
                    log = MaintenanceLog(
                        tree=tree,
                        date=maintenance_date,
                        action=action_key,
                        performer=performer,
                        note=note or ''
                    )
                    
                    # Xử lý các fields tùy theo loại hành động
                    if action_key == 'BON_PHAN' and 'Tên phân bón' in row:
                        log.fertilizer_name = str(row.get('Tên phân bón', '')).strip()
                    
                    if action_key == 'PHUN_THUOC' and 'Tên thuốc' in row:
                        log.pesticide_name = str(row.get('Tên thuốc', '')).strip()
                    
                    if action_key == 'TUOI_NUOC' and 'Lượng nước (lít)' in row:
                        try:
                            log.water_amount = float(row.get('Lượng nước (lít)', 0))
                        except (ValueError, TypeError):
                            pass
                    
                    # Lưu log
                    try:
                        log.save()
                        success_count += 1
                    except Exception as save_error:
                        if 'does not exist' in str(save_error).lower():
                            # Nếu các fields tuy chọn không tồn tại, save lại mà không dùng chúng
                            log = MaintenanceLog(
                                tree=tree,
                                date=maintenance_date,
                                action=action_key,
                                performer=performer,
                                note=note or ''
                            )
                            log.save()
                            success_count += 1
                        else:
                            error_list.append(f"Dòng {row_idx}: Lỗi khi lưu - {str(save_error)}")
                    
                    # Log activity
                    log_activity(
                        request,
                        action_type='ADD_MAINTENANCE',
                        entity_type='TREE',
                        entity_code=tree_code,
                        detail=f'Import chăm sóc từ file {file_name}',
                    )
                
                except Exception as e:
                    error_list.append(f"Dòng {row_idx}: Lỗi không mong đợi - {str(e)}")
            
            # Hiển thị kết quả
            if success_count > 0:
                messages.success(request, f'✅ Import thành công {success_count} bản ghi lịch sử chăm sóc!')
            
            if error_list:
                for error_msg in error_list[:10]:  # Hiển thị tối đa 10 lỗi để tránh quá dài
                    messages.warning(request, f"⚠️ {error_msg}")
                if len(error_list) > 10:
                    messages.warning(request, f"⚠️ ... và {len(error_list) - 10} lỗi khác")
            
            if success_count == 0:
                messages.error(request, '❌ Không import được bản ghi nào!')
            
            return redirect('import_maintenance')
    else:
        form = MaintenanceImportForm()
    
    return render(request, 'import_maintenance.html', {
        'form': form,
        'action_choices': MaintenanceLog._meta.get_field('action').choices,
    })


@login_required
@admin_required
def import_trees_view(request):
    """Import trees from Excel/CSV file"""
    from .forms import TreeImportForm, get_file_parser
    from .models import SoilQuality
    
    if request.method == 'POST':
        form = TreeImportForm(request.POST, request.FILES)
        if form.is_valid():
            file = request.FILES['file']
            file_name = file.name
            
            # Chọn parser phù hợp
            parser = get_file_parser(file_name)
            if not parser:
                messages.error(request, '❌ Định dạng file không được hỗ trợ!')
                return redirect('import_trees')
            
            # Phân tích file
            rows, error = parser(file)
            if error:
                messages.error(request, f'❌ Lỗi khi đọc file: {error}')
                return redirect('import_trees')
            
            if not rows:
                messages.error(request, '❌ File không có dữ liệu!')
                return redirect('import_trees')
            
            # Xử lý từng dòng
            success_count = 0
            error_list = []
            
            for row_idx, row in enumerate(rows, 2):  # Bắt đầu từ dòng 2
                try:
                    # Lấy dữ liệu
                    code = str(row.get('Mã cây', '')).strip()
                    species_name = str(row.get('Loài', '')).strip()
                    height_str = str(row.get('Chiều cao (m)', '')).strip()
                    status = str(row.get('Trạng thái', '')).strip()
                    lat_str = str(row.get('Vĩ độ', '')).strip()
                    lon_str = str(row.get('Kinh độ', '')).strip()
                    address = str(row.get('Địa chỉ', '')).strip()
                    
                    # Validation
                    if not all([code, species_name, height_str, status, lat_str, lon_str]):
                        error_list.append(f"Dòng {row_idx}: Thiếu dữ liệu bắt buộc")
                        continue
                    
                    # Tìm loài cây
                    try:
                        species = TreeSpecies.objects.get(name__iexact=species_name)
                    except TreeSpecies.DoesNotExist:
                        error_list.append(f"Dòng {row_idx}: Loài cây '{species_name}' không tồn tại!")
                        continue
                    
                    # Kiểm tra mã cây đã tồn tại chưa
                    if UrbanTree.objects.filter(code__iexact=code).exists():
                        error_list.append(f"Dòng {row_idx}: Cây với mã '{code}' đã tồn tại!")
                        continue
                    
                    # Kiểm tra trạng thái
                    status_choices = dict(UrbanTree._meta.get_field('status').choices)
                    status_key = None
                    for key, display_name in status_choices.items():
                        if status.upper() == key or status == display_name:
                            status_key = key
                            break
                    
                    if not status_key:
                        error_list.append(f"Dòng {row_idx}: Trạng thái '{status}' không hợp lệ. Các trạng thái được phép: {', '.join(status_choices.values())}")
                        continue
                    
                    # Phân tích số từ
                    try:
                        height = float(height_str)
                        latitude = float(lat_str)
                        longitude = float(lon_str)
                    except ValueError:
                        error_list.append(f"Dòng {row_idx}: Chiều cao, vĩ độ, kinh độ phải là số hợp lệ")
                        continue
                    
                    # Tạo cây
                    tree = UrbanTree(
                        code=code,
                        species=species,
                        height=height,
                        status=status_key,
                        latitude=latitude,
                        longitude=longitude,
                        address=address or ''
                    )
                    
                    # Xử lý các fields tùy chọn
                    if hasattr(tree, 'trunk_radius') and 'Đường kính thân (cm)' in row:
                        try:
                            tree.trunk_radius = float(row.get('Đường kính thân (cm)', 0))
                        except (ValueError, TypeError):
                            pass
                    
                    if hasattr(tree, 'canopy_diameter') and 'Diện tích vòm (m²)' in row:
                        try:
                            tree.canopy_diameter = float(row.get('Diện tích vòm (m²)', 0))
                        except (ValueError, TypeError):
                            pass
                    
                    if hasattr(tree, 'planting_year') and 'Năm trồng' in row:
                        try:
                            tree.planting_year = int(row.get('Năm trồng', 0))
                        except (ValueError, TypeError):
                            pass
                    
                    # Lưu cây
                    try:
                        tree.save()
                    except Exception as save_error:
                        if 'does not exist' in str(save_error).lower():
                            tree = UrbanTree(
                                code=code,
                                species=species,
                                height=height,
                                status=status_key,
                                latitude=latitude,
                                longitude=longitude,
                                address=address or ''
                            )
                            tree.save()
                        else:
                            raise
                    
                    # Log activity
                    log_activity(
                        request,
                        action_type='ADD_TREE',
                        entity_type='TREE',
                        entity_code=code,
                        detail=f'Import cây từ file {file_name}',
                    )
                    
                    success_count += 1
                
                except Exception as e:
                    error_list.append(f"Dòng {row_idx}: Lỗi không mong đợi - {str(e)}")
            
            # Hiển thị kết quả
            if success_count > 0:
                messages.success(request, f'✅ Import thành công {success_count} cây!')
            
            if error_list:
                for error_msg in error_list[:10]:
                    messages.warning(request, f"⚠️ {error_msg}")
                if len(error_list) > 10:
                    messages.warning(request, f"⚠️ ... và {len(error_list) - 10} lỗi khác")
            
            if success_count == 0:
                messages.error(request, '❌ Không import được cây nào!')
            
            return redirect('import_trees')
    else:
        form = TreeImportForm()
    
    return render(request, 'import_trees.html', {'form': form})


# ============ USER PROFILE PAGE ============
@login_required
def user_profile_view(request):
    """User profile page - Personal information"""
    from django.contrib.auth.models import User
    
    user = request.user
    
    # Handle profile update
    if request.method == 'POST':
        action = request.POST.get('action')
        
        if action == 'update_profile':
            first_name = request.POST.get('first_name', user.first_name).strip()
            last_name = request.POST.get('last_name', user.last_name).strip()
            email = request.POST.get('email', user.email).strip()

            if email:
                try:
                    validate_email(email)
                except ValidationError:
                    messages.error(request, '❌ Email không hợp lệ')
                    return redirect('user_profile')

                if User.objects.filter(email__iexact=email).exclude(id=user.id).exists():
                    messages.error(request, '❌ Email này đã được tài khoản khác sử dụng')
                    return redirect('user_profile')

            if len(first_name) > 150 or len(last_name) > 150:
                messages.error(request, '❌ Họ hoặc tên quá dài (tối đa 150 ký tự)')
                return redirect('user_profile')

            user.first_name = first_name
            user.last_name = last_name
            user.email = email
            user.save()
            messages.success(request, '✅ Cập nhật hồ sơ thành công')
            return redirect('user_profile')
        
        elif action == 'change_password':
            old_password = request.POST.get('old_password', '')
            new_password = request.POST.get('new_password', '')
            confirm_password = request.POST.get('confirm_password', '')
            
            if not user.check_password(old_password):
                messages.error(request, '❌ Mật khẩu cũ không đúng')
            elif new_password != confirm_password:
                messages.error(request, '❌ Mật khẩu mới không trùng khớp')
            elif len(new_password) < 8:
                messages.error(request, '❌ Mật khẩu phải có ít nhất 8 ký tự')
            else:
                try:
                    validate_password(new_password, user)
                except ValidationError as e:
                    for err in e.messages:
                        messages.error(request, f'❌ {err}')
                    return redirect('user_profile')

                user.set_password(new_password)
                user.save()
                messages.success(request, '✅ Đổi mật khẩu thành công. Hãy đăng nhập lại')
                return redirect('login')
    
    context = {
        'user': user,
        'role': 'Admin' if user.is_staff else 'User',
    }

    # Activity statistics
    try:
        # Total activities logged
        user_activities = ActivityLog.objects.filter(user=user) if user.is_staff else []
        context['user_activity_count'] = user_activities.count() if user.is_staff else 0
        
        # Maintenance logs created/performed by user
        user_logs = MaintenanceLog.objects.filter(performer__icontains=user.get_full_name() or user.username)
        context['user_logs_count'] = user_logs.count()
        
        # Most recent activity
        if user.is_staff and user_activities.exists():
            context['user_last_activity'] = user_activities.order_by('-created_at').first().created_at
        elif user_logs.exists():
            context['user_last_activity'] = user_logs.order_by('-date').first().date
        else:
            context['user_last_activity'] = None
        
        # Trees managed/viewed
        all_trees = UrbanTree.objects.all()
        # Filter by user's allowed districts if not staff
        if not user.is_staff:
            allowed_districts = District.objects.filter(
                managed_by_users__user=user
            ).distinct()
            all_trees = all_trees.filter(
                Q(district__in=allowed_districts) | Q(district__isnull=True)
            )
        context['user_trees_count'] = all_trees.count()
    except Exception:
        context['user_activity_count'] = 0
        context['user_logs_count'] = 0
        context['user_last_activity'] = None
        context['user_trees_count'] = 0
    
    return render(request, 'user_profile.html', context)