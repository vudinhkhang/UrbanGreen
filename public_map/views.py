from django.shortcuts import render, get_object_or_404, redirect
from .models import UrbanTree, MaintenanceLog, TreeSpecies
import json
from django.db.models import Q
from django.contrib import messages
from datetime import datetime, date
from django.http import JsonResponse

def home_view(request):
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
            'image': image_url
        })
    
    tree_json = json.dumps(tree_list)
    
    # Gửi thêm biến 'query' và 'status_filter' ra để giữ lại nội dung trong ô tìm kiếm
    return render(request, 'index.html', {
        'tree_json': tree_json,
        'query': query,
        'status_filter': status_filter
    })

# Hàm mới: Xem chi tiết 1 cây
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
def tree_add_view(request):
    if request.method == 'POST':
        try:
            species_id = request.POST.get('species')
            code = request.POST.get('code', '').strip()
            height = request.POST.get('height', '')
            status = request.POST.get('status', '')
            latitude = request.POST.get('latitude', '')
            longitude = request.POST.get('longitude', '')
            address = request.POST.get('address', '')
            image = request.FILES.get('image')
            
            # Kiểm tra dữ liệu bắt buộc
            if not all([species_id, code, height, status, latitude, longitude]):
                messages.error(request, '❌ Vui lòng điền đầy đủ thông tin bắt buộc!')
                return redirect('tree_add')
            
            # Kiểm tra mã cây đã tồn tại chưa
            if UrbanTree.objects.filter(code=code).exists():
                messages.error(request, '❌ Mã cây này đã tồn tại!')
                return redirect('tree_add')
            
            species = TreeSpecies.objects.get(id=species_id)
            
            tree = UrbanTree(
                species=species,
                code=code,
                height=float(height),
                status=status,
                latitude=float(latitude),
                longitude=float(longitude),
                address=address
            )
            
            if image:
                tree.image = image
            
            tree.save()
            messages.success(request, f'✅ Thêm cây {code} thành công!')
            return redirect('tree_detail', tree_id=tree.id)
        
        except ValueError:
            messages.error(request, '❌ Vui lòng nhập dữ liệu đúng định dạng!')
            return redirect('tree_add')
        except Exception as e:
            messages.error(request, f'❌ Lỗi: {str(e)}')
            return redirect('tree_add')
    
    species_list = TreeSpecies.objects.all()
    status_choices = UrbanTree._meta.get_field('status').choices
    
    return render(request, 'tree_add.html', {
        'species_list': species_list,
        'status_choices': status_choices
    })

# ============ SỬA CÂY ============
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
def tree_delete_view(request, tree_id):
    tree = get_object_or_404(UrbanTree, id=tree_id)
    
    if request.method == 'POST':
        code = tree.code
        tree.delete()
        messages.success(request, f'✅ Xóa cây {code} thành công!')
        return redirect('tree_list')
    
    return render(request, 'tree_delete.html', {'tree': tree})


# ============ LOẠI CÂY: DANH SÁCH VÀ THÊM MỚI ============
def species_list_view(request):
    species = TreeSpecies.objects.all().order_by('name')
    return render(request, 'species_list.html', {'species_list': species})


def species_add_view(request):
    if request.method == 'POST':
        name = request.POST.get('name', '').strip()
        characteristics = request.POST.get('characteristics', '').strip()

        if not name:
            messages.error(request, '❌ Vui lòng nhập tên loài!')
            return redirect('species_add')

        if TreeSpecies.objects.filter(name__iexact=name).exists():
            messages.error(request, '❌ Loài này đã tồn tại!')
            return redirect('species_add')

        TreeSpecies.objects.create(name=name, characteristics=characteristics)
        messages.success(request, f'✅ Thêm loài "{name}" thành công!')
        return redirect('species_list')

    return render(request, 'species_add.html')

# ============ LANDING PAGE ============
def landing_view(request):
    return render(request, 'landing.html')