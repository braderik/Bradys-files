# 🍎 Install on Mac - Simple Instructions

**Download and save all Chrome Remote Desktop setup files on your Mac in under 2 minutes.**

---

## 🚀 Method 1: One-Command Install (EASIEST)

**Just copy and paste this into Terminal on your Mac:**

```bash
curl -fsSL https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/install.sh | bash
```

**That's it!**

✅ Downloads everything automatically
✅ Saves to `~/chrome-remote-desktop-setup`
✅ Makes scripts executable
✅ Asks if you want to run setup immediately

**Time: 30 seconds**

---

## 📦 Method 2: Download ZIP File

### Step 1: Download
Click this link on your Mac: **[Download ZIP](https://github.com/braderik/Bradys-files/archive/refs/heads/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu.zip)**

The file will save to your `Downloads` folder.

### Step 2: Extract
Double-click the downloaded `.zip` file to extract it.

### Step 3: Move and Run
Open **Terminal** (Applications → Utilities → Terminal) and paste:

```bash
# Move to a permanent location
mv ~/Downloads/Bradys-files-* ~/chrome-remote-desktop-setup

# Navigate into the folder
cd ~/chrome-remote-desktop-setup

# Make scripts executable
chmod +x scripts/*.sh

# Run the setup
./scripts/setup-mac-host.sh
```

**Time: 2 minutes**

---

## 🔧 Method 3: Use Git (If You Have It)

Open **Terminal** and paste:

```bash
git clone -b claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu https://github.com/braderik/Bradys-files.git ~/chrome-remote-desktop-setup
cd ~/chrome-remote-desktop-setup
./scripts/setup-mac-host.sh
```

**Time: 45 seconds**

---

## 📤 Method 4: Via Google Drive

**If GitHub is blocked or you prefer Google Drive:**

### Step A: Get the ZIP file on Google Drive
1. On any computer, download: [GitHub ZIP](https://github.com/braderik/Bradys-files/archive/refs/heads/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu.zip)
2. Go to https://drive.google.com
3. Upload the ZIP file
4. Right-click → "Get link" → "Anyone with the link"
5. Copy the link

### Step B: Download on Mac
On your Mac, open the Google Drive link in Safari and click **Download**.

Then in **Terminal**:
```bash
cd ~/Downloads
unzip Bradys-files-*.zip
mv Bradys-files-* ~/chrome-remote-desktop-setup
cd ~/chrome-remote-desktop-setup
chmod +x scripts/*.sh
./scripts/setup-mac-host.sh
```

**Full guide:** [GOOGLE-DRIVE.md](GOOGLE-DRIVE.md)

---

## ✅ What Gets Saved on Your Mac

After downloading, you'll have this folder structure:

```
~/chrome-remote-desktop-setup/
├── README-REMOTE-DESKTOP.md       ← Start here
├── DOWNLOAD.md                    ← Download options
├── GOOGLE-DRIVE.md                ← Google Drive guide
├── INSTALL-ON-MAC.md              ← This file
├── install.sh                     ← Auto-installer
│
├── scripts/
│   ├── setup-mac-host.sh          ← Run this first! ⭐
│   ├── launch-ai-desktop.sh       ← Auto-launches ChatGPT/Claude
│   └── download-from-gdrive.sh    ← Google Drive downloader
│
└── docs/
    ├── remote-ui-sop.md           ← Complete guide (read this!)
    ├── security-checklist.md      ← Security setup
    ├── test-plan-remote-ui.md     ← Test checklist
    └── claude-parity-notes.md     ← ChatGPT vs Claude comparison
```

**Location:** `~/chrome-remote-desktop-setup` (in your home folder)

---

## 🎯 After Download - Quick Setup

Once files are saved on your Mac, run the setup:

```bash
cd ~/chrome-remote-desktop-setup
./scripts/setup-mac-host.sh
```

**This script will:**
- ✅ Check if Chrome Remote Desktop is installed
- ✅ Configure power settings (prevent sleep)
- ✅ Set up auto-launch for ChatGPT and Claude tabs
- ✅ Guide you through the remaining steps

---

## 📋 Complete Setup Checklist

After downloading files:

- [ ] Run `./scripts/setup-mac-host.sh` (automated Mac configuration)
- [ ] Install Chrome Remote Desktop: https://remotedesktop.google.com/access
- [ ] Name your Mac (e.g., "Home-Mac-AI")
- [ ] Set a PIN (8+ digits, save in password manager)
- [ ] Enable Google 2-Step Verification: https://myaccount.google.com/signinoptions/two-step-verification
- [ ] Test from Windows PC: https://remotedesktop.google.com/access

**Total setup time: 10-15 minutes**

---

## 🆘 Troubleshooting

### "How do I open Terminal on Mac?"
1. Press `Command (⌘) + Space` to open Spotlight
2. Type "Terminal"
3. Press Enter

### "Permission denied when running scripts"
Run this first:
```bash
cd ~/chrome-remote-desktop-setup
chmod +x scripts/*.sh
```

### "No such file or directory"
Make sure you're in the right folder:
```bash
cd ~/chrome-remote-desktop-setup
pwd  # Should show: /Users/YourName/chrome-remote-desktop-setup
ls   # Should list: README-REMOTE-DESKTOP.md, scripts, docs, etc.
```

### "curl: command not found"
Use **Method 2** (Download ZIP) instead - it doesn't require Terminal.

### "Cannot connect to GitHub"
Use **Method 4** (Google Drive) - requires uploading to Google Drive first from another computer.

---

## 🔗 Direct Download Links

If you need specific files:

| What You Need | Direct Link |
|---------------|-------------|
| **Complete ZIP (recommended)** | [Download](https://github.com/braderik/Bradys-files/archive/refs/heads/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu.zip) |
| One-line installer | [install.sh](https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/install.sh) |
| Mac setup script | [setup-mac-host.sh](https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/scripts/setup-mac-host.sh) |
| Quick start guide | [README](https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/README-REMOTE-DESKTOP.md) |

---

## 📖 Next Steps

1. **Download files** (use Method 1, 2, 3, or 4 above)
2. **Run setup:** `./scripts/setup-mac-host.sh`
3. **Read the guide:** `open ~/chrome-remote-desktop-setup/README-REMOTE-DESKTOP.md`
4. **Set up Chrome Remote Desktop:** https://remotedesktop.google.com/access
5. **Test from Windows PC:** https://remotedesktop.google.com/access

---

## 💡 Quick Command Reference

**To download (Method 1):**
```bash
curl -fsSL https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/install.sh | bash
```

**To run setup after download:**
```bash
cd ~/chrome-remote-desktop-setup
./scripts/setup-mac-host.sh
```

**To read documentation:**
```bash
cd ~/chrome-remote-desktop-setup
open README-REMOTE-DESKTOP.md
```

**To view files:**
```bash
cd ~/chrome-remote-desktop-setup
ls -la
```

---

## ✨ What Happens After Setup

Once setup is complete:

1. Your Mac will appear in Chrome Remote Desktop devices
2. ChatGPT and Claude tabs will auto-launch when you connect
3. You can control your Mac from any Windows PC (with PIN)
4. Full end-to-end encryption (AES-256)
5. Compliant with corporate security policies

**Connection time from Windows PC: 10-15 seconds**

---

## 🎉 You're Done!

After following any of the methods above, you'll have:
- ✅ All files saved on your Mac
- ✅ Scripts ready to run
- ✅ Complete documentation available offline
- ✅ Everything needed for Chrome Remote Desktop setup

**Need help?** See the [full troubleshooting guide](docs/remote-ui-sop.md#troubleshooting).

---

**Last Updated:** 2025-11-12
**Repository:** https://github.com/braderik/Bradys-files
**Branch:** `claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu`
