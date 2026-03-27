# 🚀 Quick Start Guide - UrbanGreen Custom Admin Dashboard

## 📊 What's New?

Your UrbanGreen system now has **3 new custom dashboard pages** that replace Django Admin:

### 1. Admin Dashboard (`/admin-panel/`)
- **Purpose:** Overview and statistics for administrators
- **Access:** Only users with Admin role
- **Shows:** User stats, tree stats, recent activities

### 2. User Management (`/admin-users/`)
- **Purpose:** Create, edit, and manage user accounts
- **Access:** Only users with Admin role
- **Features:** Create users, toggle admin status, delete users

### 3. User Profile (`/user-profile/`)
- **Purpose:** Personal user profile and settings
- **Access:** All logged-in users
- **Features:** Edit profile, change password, view account info

---

## 🔐 Test Accounts

Use these accounts to test the system:

### Admin Account
```
URL: http://localhost:8000/
Username: demo_admin
Password: Admin@12345
Role: Administrator (can manage everything)
```

### Regular User Account
```
URL: http://localhost:8000/
Username: demo_user
Password: User@12345
Role: Regular User (read-only access)
```

---

## 🎯 Testing Guide

### Test 1: Login as Admin
1. Go to http://localhost:8000/
2. Click "Đăng nhập" (Login)
3. Enter: `demo_admin` / `Admin@12345`
4. Click on your username → dropdown menu
5. You should see:
   - 👤 Hồ Sơ Cá Nhân (Profile)
   - 🎛️ Admin Dashboard
   - 👥 Quản Lý Người Dùng (User Management)

### Test 2: Visit Admin Dashboard
1. Click "Admin Dashboard" in dropdown menu
2. OR go to: http://localhost:8000/admin-panel/
3. You should see:
   - 📊 Statistics cards (users, admins, trees)
   - 👥 Recent users
   - 🌳 Recently added trees
   - 🔧 Recent maintenance logs
   - ⚙️ Management tools

### Test 3: Manage Users
1. Click "Quản Lý Người Dùng" (User Management)
2. OR go to: http://localhost:8000/admin-users/
3. You can:
   - ➕ **Create** new user: Fill form and click "Tạo Người Dùng"
   - ⬆️ **Promote** user to admin: Click "Nâng Admin"
   - ⬇️ **Demote** admin to user: Click "Hạ Admin"
   - 🗑️ **Delete** user: Click "Xóa" (will ask for confirmation)

### Test 4: Edit User Profile
1. Click on your username in top-right
2. Click "Hồ Sơ Cá Nhân" (My Profile)
3. OR go to: http://localhost:8000/user-profile/
4. You can:
   - 📝 Edit: Name, email, username (read-only)
   - 🔐 Change: Password (requires old password)

### Test 5: Login as Regular User
1. Logout by clicking username → "Đăng xuất"
2. Login with: `demo_user` / `User@12345`
3. Notice:
   - Dropdown menu shows only: Profile &Đăng xuất (Logout)
   - **NO** Admin Dashboard option
   - **NO** User Management option
4. Try to access: http://localhost:8000/admin-panel/
   - Should get **"Access Denied"** error

### Test 6: Check Tree Access Restrictions
1. While logged in as `demo_user`:
2. Go to: http://localhost:8000/trees/
3. You should see trees but:
   - ❌ **NO** Edit button
   - ❌ **NO** Delete button
   - ❌ **NO** Add Tree button
4. Go to: http://localhost:8000/map/
5. You should see map but:
   - ❌ **NO** "Add Tree" button
   - ❌ **NO** Bulk maintenance panel
6. Click on a tree:
   - See tree info
   - ❌ **NO** Image upload form
   - ❌ **NO** Maintenance form

---

## 📧 Email Configuration (Optional)

The system is set up to send emails via Mailtrap. To enable:

1. Create account at: https://mailtrap.io/
2. Get your credentials from Settings → Sending domain
3. Edit `UrbanGreen/settings.py`:
   ```python
   EMAIL_HOST_USER = 'your_username_from_mailtrap'
   EMAIL_HOST_PASSWORD = 'your_password_from_mailtrap'
   ```
4. Test sending email:
   ```bash
   python manage.py shell
   >>> from django.core.mail import send_mail
   >>> send_mail('Test', 'Hello World', 'noreply@urbangreenmanagement.com', ['your_email@example.com'])
   1
   ```

---

## 🔍 System Verification

Run verification script to check system status:
```bash
python verify_system.py
```

This will show:
- ✅ Total users and roles
- ✅ Database statistics
- ✅ Email configuration status

---

## 🐛 Troubleshooting

### "Access Denied" Error
- You're trying to access an admin-only page
- Only users with Admin role can access `/admin-panel/` and `/admin-users/`
- Regular users can only access `/user-profile/`

### "User Not Found" Error
- User has been deleted
- Try creating a new user through User Management

### Password Change Not Working
- Old password is incorrect
- New passwords don't match
- New password is too short (min 6 characters)

### Can't See User Dropdown Menu
- Not logged in - go to login page
- Session expired - logout and login again

---

## 📋 URL Reference

| Page | URL | Accessible By | Purpose |
|------|-----|----------------|---------|
| Home | `/` | Everyone | Home page |
| Login | `/login/` | Not logged in | Authentication |
| Map | `/map/` | Everyone | View tree map |
| Trees | `/trees/` | Everyone | View tree list |
| Tree Add | `/tree/add/` | Admin only | Add new tree |
| Species | `/species/` | Everyone | View species |
| Dashboard | `/dashboard/` | Everyone | Statistics & export |
| **Admin Panel** | **/admin-panel/** | **Admin only** | **New dashboard** |
| **User Management** | **/admin-users/** | **Admin only** | **New user mgmt** |
| **My Profile** | **/user-profile/** | **All users** | **New profile page** |

---

## ✨ Key Features

### Permission System
- ✅ Uses `is_staff` flag for role distinction
- ✅ Backend protection on all admin views
- ✅ Frontend hiding of admin-only controls
- ✅ API returns 403 for unauthorized requests

### No Django Admin
- ✅ Removed `/admin/` access
- ✅ Custom replacement dashboards
- ✅ User-friendly interface
- ✅ Mobile responsive design

### Database
- ✅ SQLite (as requested, no PostgreSQL)
- ✅ No structural changes needed
- ✅ Backward compatible
- ✅ All data preserved

---

## 📞 Support

**All requirements completed:**
- ✅ Role-based permission system (admin vs user)
- ✅ Custom admin dashboard (no Django Admin)
- ✅ User management page
- ✅ User profile page
- ✅ SQLite database
- ✅ Mailtrap email configuration

**Next Steps:**
- Add your Mailtrap credentials for email functionality
- Customize dashboard styles if needed
- Add more user roles if needed (optional)

---

**Status:** ✅ Ready for Use
**Last Updated:** March 2024
**Version:** 1.0
