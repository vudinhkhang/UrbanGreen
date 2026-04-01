from django import template
from django.conf import settings
import os

register = template.Library()

@register.filter
def debug_image_path(image_field):
    """Debug helper to show image file paths and check if files exist"""
    if not image_field:
        return "❌ No image"
    
    try:
        image_path = image_field.path if hasattr(image_field, 'path') else None
        file_exists = False
        
        if image_path:
            file_exists = os.path.exists(image_path)
        else:
            # Try using storage
            from django.core.files.storage import default_storage
            file_exists = default_storage.exists(image_field.name) if hasattr(image_field, 'name') else False
        
        status = "✅" if file_exists else "❌"
        return f"{status} {image_field.name if hasattr(image_field, 'name') else str(image_field)}"
    except Exception as e:
        return f"⚠️ Error: {str(e)}"

@register.simple_tag
def get_media_root():
    """Get MEDIA_ROOT path"""
    return settings.MEDIA_ROOT

@register.simple_tag
def get_media_url():
    """Get MEDIA_URL path"""
    return settings.MEDIA_URL
