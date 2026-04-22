from django import forms
from django.core.exceptions import ValidationError
from .models import MaintenanceLog, UrbanTree
import csv
import io


class MaintenanceImportForm(forms.Form):
    """Form để nhập file Excel/CSV lịch sử chăm sóc"""
    file = forms.FileField(
        label='Chọn file Excel hoặc CSV',
        help_text='Định dạng: .xlsx, .csv (tối đa 5MB)',
        widget=forms.FileInput(attrs={
            'accept': '.xlsx,.csv,.xls',
            'class': 'form-control',
        })
    )
    
    def clean_file(self):
        """Kiểm tra file được upload"""
        file = self.cleaned_data.get('file')
        if not file:
            raise ValidationError('Vui lòng chọn file.')
        
        # Kiểm tra kích thước file (tối đa 5MB)
        if file.size > 5 * 1024 * 1024:
            raise ValidationError('Kích thước file không được vượt quá 5MB.')
        
        # Kiểm tra định dạng file
        valid_extensions = ['.xlsx', '.csv', '.xls']
        file_name = file.name.lower()
        if not any(file_name.endswith(ext) for ext in valid_extensions):
            raise ValidationError(f'Chỉ hỗ trợ các định dạng: {", ".join(valid_extensions)}')
        
        return file


class TreeImportForm(forms.Form):
    """Form để nhập file Excel/CSV danh sách cây"""
    file = forms.FileField(
        label='Chọn file Excel hoặc CSV',
        help_text='Định dạng: .xlsx, .csv (tối đa 5MB)',
        widget=forms.FileInput(attrs={
            'accept': '.xlsx,.csv,.xls',
            'class': 'form-control',
        })
    )
    
    def clean_file(self):
        """Kiểm tra file được upload"""
        file = self.cleaned_data.get('file')
        if not file:
            raise ValidationError('Vui lòng chọn file.')
        
        if file.size > 5 * 1024 * 1024:
            raise ValidationError('Kích thước file không được vượt quá 5MB.')
        
        valid_extensions = ['.xlsx', '.csv', '.xls']
        file_name = file.name.lower()
        if not any(file_name.endswith(ext) for ext in valid_extensions):
            raise ValidationError(f'Chỉ hỗ trợ các định dạng: {", ".join(valid_extensions)}')
        
        return file


def parse_csv_file(file):
    """Phân tích file CSV"""
    try:
        # Đọc file với encoding UTF-8 hoặc UTF-8-sig (BOM)
        content = file.read()
        try:
            text = content.decode('utf-8-sig')
        except:
            text = content.decode('utf-8')
        
        reader = csv.DictReader(io.StringIO(text))
        if not reader.fieldnames:
            raise ValueError('File CSV không có header')
        
        return list(reader), None
    except Exception as e:
        return None, str(e)


def parse_excel_file(file):
    """Phân tích file Excel (.xlsx, .xls)"""
    try:
        import openpyxl
        
        file.seek(0)
        wb = openpyxl.load_workbook(file, read_only=True)
        ws = wb.active
        
        rows = []
        headers = None
        
        for row_idx, row in enumerate(ws.iter_rows(values_only=True), 1):
            if row_idx == 1:
                headers = [str(cell).strip() if cell else '' for cell in row]
                if not headers or all(not h for h in headers):
                    raise ValueError('File Excel không có header')
                continue
            
            if all(cell is None for cell in row):
                continue
            
            row_data = {headers[i]: row[i] for i in range(len(headers))}
            rows.append(row_data)
        
        wb.close()
        return rows, None
    except ImportError:
        return None, 'openpyxl chưa được cài đặt. Xin vui lòng cài: pip install openpyxl'
    except Exception as e:
        return None, str(e)


def get_file_parser(file_name):
    """Lựa chọn parser phù hợp dựa trên loại file"""
    if file_name.lower().endswith('.csv'):
        return parse_csv_file
    elif file_name.lower().endswith(('.xlsx', '.xls')):
        return parse_excel_file
    else:
        return None
