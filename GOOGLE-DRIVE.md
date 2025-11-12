# 📤 Upload to Google Drive & Download on Mac

**Step-by-step guide to distribute these files via Google Drive**

---

## Method 1: Upload GitHub ZIP to Google Drive

### Step 1: Download from GitHub to Your Computer

**Option A: Download ZIP directly**
1. Click this link: [Download ZIP](https://github.com/braderik/Bradys-files/archive/refs/heads/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu.zip)
2. Save to your Downloads folder

**Option B: Use command line (if on Mac/Linux)**
```bash
curl -L -o chrome-remote-desktop.zip "https://github.com/braderik/Bradys-files/archive/refs/heads/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu.zip"
```

### Step 2: Upload to Google Drive

1. Go to https://drive.google.com
2. Click **"New"** → **"File upload"**
3. Select the downloaded ZIP file (`chrome-remote-desktop.zip` or `Bradys-files-claude-remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu.zip`)
4. Wait for upload to complete

### Step 3: Share the File

**Option A: Get shareable link**
1. Right-click the uploaded ZIP file in Google Drive
2. Click **"Get link"**
3. Change to **"Anyone with the link"** → **"Viewer"**
4. Click **"Copy link"**
5. Save this link - you'll use it on your Mac

**Option B: Share to specific email**
1. Right-click the uploaded ZIP file
2. Click **"Share"**
3. Enter your Mac's email address
4. Click **"Send"**

---

## Method 2: Download from Google Drive on Mac

### Option A: Download via Browser (Simplest)

1. On your Mac, open the Google Drive link you copied
2. Click **"Download"** (top-right corner)
3. The ZIP will download to `~/Downloads`
4. Double-click to extract
5. Open Terminal:
   ```bash
   cd ~/Downloads/Bradys-files-*
   chmod +x scripts/*.sh
   ./scripts/setup-mac-host.sh
   ```

### Option B: Use Terminal with Google Drive Direct Link

If you have a Google Drive share link, use this script:

**Create download script:**
```bash
# Save this as download-from-gdrive.sh on your Mac
curl -o download-from-gdrive.sh "https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/scripts/download-from-gdrive.sh"
chmod +x download-from-gdrive.sh
```

**Run it with your Google Drive file ID:**
```bash
./download-from-gdrive.sh "YOUR_GOOGLE_DRIVE_FILE_ID"
```

*How to get File ID: From a link like `https://drive.google.com/file/d/1A2B3C4D5E6F/view`, the File ID is `1A2B3C4D5E6F`*

---

## Method 3: Use Google Drive Desktop App (Mac)

If you have Google Drive Desktop app installed:

### Step 1: Upload (any computer)
1. Open Google Drive folder on your computer
2. Drag the ZIP file into Google Drive folder
3. Wait for sync

### Step 2: Download (Mac)
1. Open Google Drive folder on Mac
2. The ZIP should already be synced
3. Double-click to extract
4. Open Terminal:
   ```bash
   cd ~/Google\ Drive/My\ Drive/Bradys-files-*
   chmod +x scripts/*.sh
   ./scripts/setup-mac-host.sh
   ```

---

## Quick Command Reference

### Extract and Setup from Downloads

```bash
# Navigate to Downloads
cd ~/Downloads

# Find the extracted folder
ls -d Bradys-files-*

# Go into it
cd Bradys-files-claude-remote-desktop-chatgpt-setup-*

# Make scripts executable
chmod +x scripts/*.sh

# Run setup
./scripts/setup-mac-host.sh
```

### Move to Permanent Location

```bash
# From the extracted folder
cd ~/Downloads/Bradys-files-*

# Move to home directory
cd ..
mv Bradys-files-* ~/chrome-remote-desktop-setup

# Navigate and run
cd ~/chrome-remote-desktop-setup
./scripts/setup-mac-host.sh
```

---

## 📋 Folder Structure After Extraction

```
chrome-remote-desktop-setup/
├── README-REMOTE-DESKTOP.md      ← Start here
├── DOWNLOAD.md                   ← Download options
├── GOOGLE-DRIVE.md              ← This file
├── install.sh                    ← Auto-installer (alternative)
├── scripts/
│   ├── setup-mac-host.sh         ← Run this first
│   ├── launch-ai-desktop.sh      ← Auto-launches ChatGPT/Claude
│   └── download-from-gdrive.sh   ← Download helper script
└── docs/
    ├── remote-ui-sop.md          ← Complete guide (read this!)
    ├── security-checklist.md     ← Security setup
    ├── test-plan-remote-ui.md    ← Test your setup
    └── claude-parity-notes.md    ← Feature comparison
```

---

## 🎯 Complete Workflow

### On Windows PC (or any computer with browser):
1. ✅ Download ZIP from GitHub: [Click here](https://github.com/braderik/Bradys-files/archive/refs/heads/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu.zip)
2. ✅ Go to https://drive.google.com
3. ✅ Upload ZIP file
4. ✅ Right-click → Get link → Copy link
5. ✅ Send link to yourself (email, message, etc.)

### On Mac:
1. ✅ Open the Google Drive link
2. ✅ Click Download
3. ✅ Extract ZIP (double-click)
4. ✅ Open Terminal:
   ```bash
   cd ~/Downloads/Bradys-files-*
   ./scripts/setup-mac-host.sh
   ```

**Total time: 2-3 minutes**

---

## 🆘 Troubleshooting

### "Download quota exceeded" error on Google Drive
**Solution:**
1. Make a copy to your own Google Drive:
   - Open the link → Click **"Add to My Drive"**
   - Then download from your own Drive
2. Or wait 24 hours and try again

### ZIP file won't extract
**Solution:**
```bash
# Manual extract in Terminal
cd ~/Downloads
unzip -q Bradys-files-*.zip
```

### Can't find extracted folder
**Solution:**
```bash
# Search for it
find ~/Downloads -name "Bradys-files-*" -type d
```

### "Permission denied" when running scripts
**Solution:**
```bash
chmod +x scripts/*.sh
# Then try again
./scripts/setup-mac-host.sh
```

---

## 🔗 Alternative: Direct GitHub Download Links

If Google Drive is blocked or unavailable:

| File | Direct GitHub Link |
|------|-------------------|
| Complete ZIP | https://github.com/braderik/Bradys-files/archive/refs/heads/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu.zip |
| Installer Only | https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/install.sh |
| Setup Script | https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/scripts/setup-mac-host.sh |

---

## 📧 Sharing with Others

If you want to share this setup with colleagues:

1. **Upload ZIP to your Google Drive** (see Method 1 above)
2. **Get shareable link** with "Anyone with the link can view"
3. **Share these instructions:**
   ```
   Chrome Remote Desktop Setup for Mac

   1. Download: [Your Google Drive Link]
   2. Extract the ZIP file
   3. Open Terminal and run:
      cd ~/Downloads/Bradys-files-*
      ./scripts/setup-mac-host.sh
   4. Follow the on-screen instructions
   ```

---

## ✅ After Download - Quick Setup

Once you have the files on your Mac:

```bash
# 1. Navigate to the folder
cd ~/Downloads/Bradys-files-*

# 2. Run setup
./scripts/setup-mac-host.sh

# 3. Follow the prompts for:
#    - Chrome Remote Desktop installation
#    - Power management settings
#    - Auto-launch configuration

# 4. Read the full guide
open README-REMOTE-DESKTOP.md
```

---

## 🌐 Next Steps After Installation

1. **Enable Google 2-Step Verification:**
   https://myaccount.google.com/signinoptions/two-step-verification

2. **Set up Chrome Remote Desktop:**
   https://remotedesktop.google.com/access

3. **Test from Windows PC:**
   - Go to https://remotedesktop.google.com/access
   - Sign in with same Google account
   - Select your Mac
   - Enter PIN

4. **Read the documentation:**
   - Quick Start: `README-REMOTE-DESKTOP.md`
   - Full Guide: `docs/remote-ui-sop.md`
   - Security: `docs/security-checklist.md`

---

**Need help?** See the [full troubleshooting guide](docs/remote-ui-sop.md#troubleshooting) or [README](README-REMOTE-DESKTOP.md).

🎉 **Enjoy your remote AI access!**
