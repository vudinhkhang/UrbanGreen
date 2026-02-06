from django.shortcuts import render
from .models import UrbanTree
import json

def home_view(request):
    trees = UrbanTree.objects.all()
    
    tree_list = []
    for tree in trees:
        # Kiểm tra xem cây có ảnh không, nếu có thì lấy đường dẫn, không thì để rỗng
        image_url = tree.image.url if tree.image else ''
        
        tree_list.append({
            'code': tree.code,
            'name': tree.species.name,
            'status': tree.status,
            'lat': tree.latitude,
            'long': tree.longitude,
            'height': tree.height,
            'image': image_url  # <--- Gửi link ảnh sang đây
        })
    
    tree_json = json.dumps(tree_list)
    
    return render(request, 'index.html', {
        'trees': trees,
        'tree_json': tree_json
    })