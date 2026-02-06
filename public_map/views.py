from django.shortcuts import render
from .models import UrbanTree
import json # <--- Nhớ thêm dòng này

def home_view(request):
    # 1. Lấy dữ liệu từ Database
    trees = UrbanTree.objects.all()
    
    # 2. Chuyển đổi dữ liệu thành dạng List để JavaScript hiểu được
    tree_list = []
    for tree in trees:
        tree_list.append({
            'code': tree.code,
            'name': tree.species.name,
            'status': tree.status,
            'lat': tree.latitude,
            'long': tree.longitude,
            'height': tree.height
        })
    
    # 3. Biến đổi List thành chuỗi JSON
    tree_json = json.dumps(tree_list)
    
    # 4. Gửi cả 2 dữ liệu sang HTML
    context = {
        'trees': trees,       # Dùng để hiện danh sách dạng bảng (nếu cần)
        'tree_json': tree_json # Dùng để vẽ lên bản đồ
    }
    
    return render(request, 'index.html', context)