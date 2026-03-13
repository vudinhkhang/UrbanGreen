from django.shortcuts import render, get_object_or_404, redirect
from .models import UrbanTree, MaintenanceLog, TreeSpecies, ManagementZone
import json
from django.db.models import Q, Max, Subquery, OuterRef, F, Value, CharField, Count
from django.db.models.functions import Coalesce, TruncMonth
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from datetime import datetime, date, timedelta
from django.http import JsonResponse, HttpResponse
from django.views.decorators.http import require_POST
import csv

@login_required
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
def map_view(request):
    # 1. Lấy tham số từ thanh địa chỉ (Ví dụ: /?q=Phuong&status=SAU_BENH)
    query = request.GET.get('q', '')
    status_filter = request.GET.get('status', '')

    # 2. Bắt đầu với toàn bộ cây
    trees = UrbanTree.objects.all()

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
        tree_list.append({
            'id': tree.id,
            'code': tree.code,
            'name': tree.species.name,
            'status': tree.status,
            'lat': tree.latitude,
            'long': tree.longitude,
            'height': tree.height,
            'image': image_url,
            'address': tree.address or ''
        })
    
    tree_json = json.dumps(tree_list)
    
    # Gửi thêm biến 'query' và 'status_filter' ra để giữ lại nội dung trong ô tìm kiếm
    return render(request, 'map.html', {
        'tree_json': tree_json,
        'query': query,
        'status_filter': status_filter
    })

# Hàm mới: Xem chi tiết 1 cây
@login_required
def tree_detail_view(request, tree_id):
    # Lấy cây theo ID, nếu không thấy thì báo lỗi 404
    tree = get_object_or_404(UrbanTree, id=tree_id)
    
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
        # 1. Cập nhật ảnh cây nếu có upload
        if 'image' in request.FILES:
            tree.image = request.FILES['image']
            tree.save()
            messages.success(request, '✅ Cập nhật ảnh thành công!')
        
        # 2. Thêm lịch sử chăm sóc nếu có submit form
        if 'add_maintenance' in request.POST:
            maintenance_date = request.POST.get('date', '')
            action = request.POST.get('action', '')
            performer = request.POST.get('performer', '')
            note = request.POST.get('note', '')
            
            if maintenance_date and action and performer:
                MaintenanceLog.objects.create(
                    tree=tree,
                    date=maintenance_date,
                    action=action,
                    performer=performer,
                    note=note
                )
                # Cập nhật trạng thái cây nếu được chọn
                new_status = request.POST.get('new_status', '')
                if new_status and new_status != tree.status:
                    old_display = tree.get_status_display()
                    tree.status = new_status
                    tree.save()
                    messages.success(request, f'✅ Thêm lịch sử chăm sóc và cập nhật trạng thái → {tree.get_status_display()} thành công!')
                else:
                    messages.success(request, '✅ Thêm lịch sử chăm sóc thành công!')
                return redirect('tree_detail', tree_id=tree_id)
            else:
                messages.error(request, '❌ Vui lòng điền đầy đủ thông tin bắt buộc!')
    
    return render(request, 'tree_detail.html', {
        'tree': tree,
        'logs': logs,
        'status_choices': status_choices,
        'maintenance_choices': maintenance_choices,
        'today': today
    })

# ============ DANH SÁCH CÂY ============
@login_required
def tree_list_view(request):
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
    
    status_choices = UrbanTree._meta.get_field('status').choices
    
    return render(request, 'tree_list.html', {
        'trees': trees,
        'query': query,
        'status_filter': status_filter,
        'status_choices': status_choices
    })

# ============ THÊM CÂY MỚI ============
@login_required
def tree_add_view(request):
    if request.method == 'POST':
        try:
            species_id = request.POST.get('species')
            code_prefix = request.POST.get('code', '').strip()
            height = request.POST.get('height', '')
            address = request.POST.get('address', '')
            locations_json = request.POST.get('locations', '[]')
            statuses = request.POST.getlist('statuses')
            heights = request.POST.getlist('heights')

            locations = json.loads(locations_json)

            if not all([species_id, code_prefix, height]) or len(locations) == 0:
                messages.error(request, '❌ Vui lòng điền đầy đủ thông tin và chọn ít nhất 1 vị trí trên bản đồ!')
                return redirect('tree_add')

            species = TreeSpecies.objects.get(id=species_id)

            # Tìm số thứ tự tiếp theo cho prefix
            existing = UrbanTree.objects.filter(code__istartswith=code_prefix).values_list('code', flat=True)
            max_num = 0
            for c in existing:
                suffix = c[len(code_prefix):]
                if suffix.isdigit():
                    max_num = max(max_num, int(suffix))

            created_codes = []
            last_tree = None
            images = request.FILES.getlist('images')
            for i, loc in enumerate(locations):
                num = max_num + i + 1
                code = f"{code_prefix}{num:03d}"
                tree_status = statuses[i] if i < len(statuses) else 'TOT'
                tree_height = float(heights[i]) if i < len(heights) else float(height)
                tree = UrbanTree(
                    species=species,
                    code=code,
                    height=tree_height,
                    status=tree_status,
                    latitude=float(loc['lat']),
                    longitude=float(loc['lng']),
                    address=address
                )
                if i < len(images):
                    tree.image = images[i]
                tree.save()
                created_codes.append(code)
                last_tree = tree

            if len(created_codes) == 1:
                messages.success(request, f'✅ Thêm cây {created_codes[0]} thành công!')
                return redirect('tree_detail', tree_id=last_tree.id)
            else:
                messages.success(request, f'✅ Thêm {len(created_codes)} cây thành công: {created_codes[0]} → {created_codes[-1]}')
                return redirect('tree_list')

        except ValueError:
            messages.error(request, '❌ Vui lòng nhập dữ liệu đúng định dạng!')
            return redirect('tree_add')
        except Exception as e:
            messages.error(request, f'❌ Lỗi: {str(e)}')
            return redirect('tree_add')

    species_list = TreeSpecies.objects.all()
    status_choices = UrbanTree._meta.get_field('status').choices

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

    return render(request, 'tree_add.html', {
        'species_list': species_list,
        'status_choices': status_choices,
        'existing_json': existing_json,
    })

# ============ SỬA CÂY ============
@login_required
def tree_edit_view(request, tree_id):
    tree = get_object_or_404(UrbanTree, id=tree_id)
    
    if request.method == 'POST':
        try:
            tree.species_id = request.POST.get('species', tree.species_id)
            tree.code = request.POST.get('code', tree.code).strip()
            tree.height = float(request.POST.get('height', tree.height))
            tree.status = request.POST.get('status', tree.status)
            tree.latitude = float(request.POST.get('latitude', tree.latitude))
            tree.longitude = float(request.POST.get('longitude', tree.longitude))
            tree.address = request.POST.get('address', tree.address)
            
            if 'image' in request.FILES:
                tree.image = request.FILES['image']
            
            tree.save()
            messages.success(request, f'✅ Cập nhật cây {tree.code} thành công!')
            return redirect('tree_detail', tree_id=tree.id)
        
        except ValueError:
            messages.error(request, '❌ Vui lòng nhập dữ liệu đúng định dạng!')
        except Exception as e:
            messages.error(request, f'❌ Lỗi: {str(e)}')
    
    species_list = TreeSpecies.objects.all()
    status_choices = UrbanTree._meta.get_field('status').choices
    
    return render(request, 'tree_edit.html', {
        'tree': tree,
        'species_list': species_list,
        'status_choices': status_choices
    })

# ============ XÓA CÂY ============
@login_required
def tree_delete_view(request, tree_id):
    tree = get_object_or_404(UrbanTree, id=tree_id)
    
    if request.method == 'POST':
        code = tree.code
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

    return render(request, 'species_list.html', {
        'species_list': species,
        'query': query,
        'trait_filter': trait_filter,
    })


@login_required
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
        messages.success(request, f'✅ Thêm loài "{name}" thành công!')
        return redirect('species_list')

    return render(request, 'species_add.html')


@login_required
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
        messages.success(request, f'✅ Cập nhật loài "{name}" thành công!')
        return redirect('species_list')

    return render(request, 'species_edit.html', {'species': species})


@login_required
def species_delete_view(request, species_id):
    species = get_object_or_404(TreeSpecies, id=species_id)
    if request.method == 'POST':
        tree_count = UrbanTree.objects.filter(species=species).count()
        if tree_count > 0:
            messages.error(request, f'❌ Không thể xóa! Loài "{species.name}" đang có {tree_count} cây liên kết.')
            return redirect('species_list')
        name = species.name
        species.delete()
        messages.success(request, f'✅ Đã xóa loài "{name}" thành công!')
    return redirect('species_list')


# ============ DASHBOARD BÁO CÁO THỐNG KÊ ============
@login_required
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
            days_since_inspection = (today - last_inspection).days
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
            days_since_water = (today - last_watering).days
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
                days_since_spray = (today - last_spray).days
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
            days_no_care = (today - last_any).days if last_any else 999
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
            days_since = (today - last_check).days if last_check else 999
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
            days_since = (today - last_prune).days if last_prune else 999
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
            days_since = (today - last_water).days if last_water else 999
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
            days_since = (today - last_check).days if last_check else 999
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

    # Thống kê đề xuất
    stats = {
        'total': len(grouped_recommendations),
        'critical': sum(1 for g in grouped_recommendations if g['urgency'] == 'critical'),
        'high': sum(1 for g in grouped_recommendations if g['urgency'] == 'high'),
        'medium': sum(1 for g in grouped_recommendations if g['urgency'] == 'medium'),
        'total_issues': len(recommendations),
    }

    return render(request, 'maintenance_list.html', {
        'logs': logs,
        'query': query,
        'action_filter': action_filter,
        'action_choices': action_choices,
        'recommendations': grouped_recommendations,
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
        
        return JsonResponse({
            'status': 'ok',
            'count': created_count,
            'message': f'Đã lưu chăm sóc cho {created_count} cây'
        })
    
    except json.JSONDecodeError:
        return JsonResponse({'status': 'error', 'error': 'Dữ liệu JSON không hợp lệ'}, status=400)
    except ValueError as e:
        return JsonResponse({'status': 'error', 'error': f'Lỗi: {str(e)}'}, status=400)
    except Exception as e:
        return JsonResponse({'status': 'error', 'error': f'Lỗi server: {str(e)}'}, status=500)