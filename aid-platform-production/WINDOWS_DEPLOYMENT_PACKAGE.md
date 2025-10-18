# Aid Platform - Windows Production Package

## 📦 Package Information

**File:** `aid-platform-v1.0-production.zip` (12 MB)
**Platform:** Windows 10/11
**Date:** October 18, 2025
**Version:** 1.0.0

## ✅ What's Included

This package contains **everything** needed to run the Aid Platform on Windows:

### Application Files
- ✅ Backend server (PocketBase)
- ✅ Frontend web interface (SvelteKit)
- ✅ All source code and dependencies

### Windows Batch Files (No Linux Knowledge Required!)
- ✅ `start-aid-app.bat` - Start the application
- ✅ `stop-aid-app.bat` - Stop the application
- ✅ `backup_database.bat` - Manual backup
- ✅ `update_app.bat` - Manual update from GitHub
- ✅ `setup_auto_update.bat` - Setup automatic updates
- ✅ `setup_auto_backup.bat` - Setup automatic backups

### Documentation
- ✅ `START_HERE.md` - Quick start guide (5 minutes)
- ✅ `DEPLOYMENT_INSTRUCTIONS_SYRIA.md` - Complete deployment guide
- ✅ `AUTO_UPDATE_GUIDE.md` - Update system documentation
- ✅ `BACKUP_GUIDE.md` - Backup and restore procedures

## 🚚 How to Send to Syria

### Option 1: USB Drive (Recommended)
1. Copy `aid-platform-v1.0-production.zip` to USB drive
2. Send with someone traveling to Syria
3. Most reliable for first deployment

### Option 2: Cloud Storage
1. Upload to Google Drive, Dropbox, or OneDrive
2. Share download link with Syria team
3. They download and extract

### Option 3: Email
- If your email supports 12 MB attachments
- Quick but requires good internet

## 📋 What Syria Team Does

### One-Time Setup (10 minutes)
1. **Extract** the zip file to `C:\aid-platform-v1.0-production`
2. **Install** Git for Windows and Node.js
3. **Open Command Prompt** and navigate to `frontend` folder
4. **Run:** `npm install -g pnpm`
5. **Run:** `pnpm install`
6. **Double-click:** `start-aid-app.bat`
7. **Login** and change default password
8. **Right-click and run as Administrator:**
   - `setup_auto_update.bat`
   - `setup_auto_backup.bat`

### Daily Use (1 click)
- **Double-click:** `start-aid-app.bat`
- That's it! Browser opens automatically

## 🔄 How Updates Work

After initial setup:

1. **You (UAE)** push code changes to GitHub
2. **Syria laptop** automatically checks for updates daily at 3 AM
3. **Automatic download** and installation
4. **Automatic backup** before each update
5. **Automatic rollback** if update fails

They can also manually update anytime by double-clicking `update_app.bat`.

## 💾 How Backups Work

After running `setup_auto_backup.bat`:

- **Hourly backups** - Automatic, keeps last 24
- **Daily exports** - Automatic at 2 AM, keeps last 30
- **Manual backups** - Double-click `backup_database.bat` anytime

**Important:** Syria team should copy `exports/` folder to USB drive weekly!

## 🔐 Security

**Default Login (MUST CHANGE):**
- Email: `admin@example.com`
- Password: `admin123`

**After first login:**
1. Change admin password
2. Create individual user accounts
3. Don't share credentials

## 🎯 Key Features

- ✅ **Offline-first** - Works without internet
- ✅ **Bilingual** - English and Arabic with RTL support
- ✅ **Auto-updates** - Remote maintenance from UAE
- ✅ **Auto-backups** - Protection against power loss
- ✅ **Multi-currency** - USD, EUR, AED, SAR, SYP
- ✅ **Role-based access** - Admin, Monitor, Volunteer
- ✅ **Financial tracking** - Donations and expenses
- ✅ **User management** - Complete user administration

## 📊 System Requirements

**Minimum:**
- Windows 10 or 11
- 4 GB RAM
- 1 GB free disk space
- Git for Windows
- Node.js v22+

**Recommended:**
- Windows 11
- 8 GB RAM
- 5 GB free disk space (for backups)
- Stable power supply or UPS

## 🆘 Support

If Syria team encounters issues:

1. **Check logs** in `logs/` folder
2. **Review documentation:**
   - Setup issues → `START_HERE.md`
   - Update issues → `AUTO_UPDATE_GUIDE.md`
   - Backup issues → `BACKUP_GUIDE.md`
3. **Contact UAE team** with:
   - Description of problem
   - Error messages
   - Log file contents

## ✨ What Makes This Special

### No Linux Knowledge Required
- All scripts are Windows batch files (`.bat`)
- Double-click to run
- No command line expertise needed

### Fully Automated
- Updates happen automatically
- Backups happen automatically
- No manual maintenance required

### Disaster-Proof
- Hourly backups protect against power loss
- Auto-rollback if updates fail
- Export backups for USB storage

### Remote Maintenance
- Push updates from UAE
- No need to travel to Syria
- No need to send files again

## 📝 Checklist for Syria Team

### Initial Setup
- [ ] Extract zip file
- [ ] Install Git for Windows
- [ ] Install Node.js
- [ ] Run `pnpm install` in frontend folder
- [ ] Double-click `start-aid-app.bat`
- [ ] Login and change password
- [ ] Run `setup_auto_update.bat` as Administrator
- [ ] Run `setup_auto_backup.bat` as Administrator
- [ ] Test backup by running `backup_database.bat`

### Weekly Tasks
- [ ] Copy `exports/` folder to USB drive
- [ ] Verify backups are being created
- [ ] Check `logs/update.log` for any issues

### Monthly Tasks
- [ ] Test restoring from backup
- [ ] Review and clean up old user accounts
- [ ] Archive old export backups to external storage

## 🎉 Ready to Deploy!

Everything is included in the zip file. Just send it to Syria and they follow `START_HERE.md`.

**No additional setup needed from your side!**

---

**Questions?** Contact the UAE development team.

