# 📥 Download & Install on Mac

**Quick commands to download and set up Chrome Remote Desktop for ChatGPT/Claude access on your Mac.**

---

## 🚀 One-Line Install (Easiest)

Open **Terminal** on your Mac and run this command:

```bash
curl -fsSL https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/install.sh | bash
```

**What this does:**
1. Downloads all files from GitHub
2. Installs to `~/chrome-remote-desktop-setup`
3. Makes scripts executable
4. Asks if you want to run setup immediately

**Time:** ~30 seconds

---

## 🔒 Security-Conscious Install (Review First)

If you prefer to review the script before running:

### Step 1: Download the installer
```bash
curl -o install.sh https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/install.sh
```

### Step 2: Review the script
```bash
cat install.sh
# or
open -a TextEdit install.sh
```

### Step 3: Run the installer
```bash
chmod +x install.sh
./install.sh
```

---

## 📦 Manual Download (No Terminal)

If you prefer using your browser:

### Step 1: Download ZIP
Click this link: [Download ZIP](https://github.com/braderik/Bradys-files/archive/refs/heads/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu.zip)

### Step 2: Extract the ZIP
Double-click the downloaded `.zip` file in your Downloads folder.

### Step 3: Move to home directory
```bash
mv ~/Downloads/Bradys-files-* ~/chrome-remote-desktop-setup
```

### Step 4: Make scripts executable
```bash
cd ~/chrome-remote-desktop-setup
chmod +x scripts/*.sh
```

### Step 5: Run setup
```bash
./scripts/setup-mac-host.sh
```

---

## 🔧 Alternative: Clone with Git

If you have Git installed:

```bash
git clone -b claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu https://github.com/braderik/Bradys-files.git ~/chrome-remote-desktop-setup
cd ~/chrome-remote-desktop-setup
./scripts/setup-mac-host.sh
```

---

## ✅ After Installation

Once installed, you'll find everything in `~/chrome-remote-desktop-setup/`:

```
chrome-remote-desktop-setup/
├── README-REMOTE-DESKTOP.md    ← Start here for overview
├── DOWNLOAD.md                 ← This file
├── install.sh                  ← Installer script
├── scripts/
│   ├── setup-mac-host.sh       ← Run this first
│   └── launch-ai-desktop.sh    ← Auto-launches ChatGPT/Claude
└── docs/
    ├── remote-ui-sop.md        ← Complete guide
    ├── security-checklist.md   ← Security hardening
    ├── test-plan-remote-ui.md  ← Test your setup
    └── claude-parity-notes.md  ← Feature comparison
```

### Run the setup:
```bash
cd ~/chrome-remote-desktop-setup
./scripts/setup-mac-host.sh
```

### Read the quick start:
```bash
open ~/chrome-remote-desktop-setup/README-REMOTE-DESKTOP.md
```

---

## 🆘 Troubleshooting

### "Command not found: curl"
This is rare on Mac. Update macOS or use the manual download method.

### "Permission denied"
Run with `chmod +x`:
```bash
chmod +x install.sh
./install.sh
```

### "Cannot connect to GitHub"
Check your internet connection or use the manual ZIP download method.

### Installation hangs or fails
1. Cancel with `Ctrl+C`
2. Clean up: `rm -rf ~/chrome-remote-desktop-setup`
3. Try again or use manual download

---

## 🔗 Direct File Links

If you need to download individual files:

| File | Direct Link |
|------|-------------|
| Installer | https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/install.sh |
| Setup Script | https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/scripts/setup-mac-host.sh |
| Launch Script | https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/scripts/launch-ai-desktop.sh |
| Quick Start | https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/README-REMOTE-DESKTOP.md |
| Full Guide | https://raw.githubusercontent.com/braderik/Bradys-files/claude/remote-desktop-chatgpt-setup-011CV4Ck3EcGTQfRz4HhWbyu/docs/remote-ui-sop.md |

---

## 📞 Next Steps After Download

1. **Run the setup script:**
   ```bash
   cd ~/chrome-remote-desktop-setup
   ./scripts/setup-mac-host.sh
   ```

2. **Enable Google 2-Step Verification:**
   https://myaccount.google.com/signinoptions/two-step-verification

3. **Install Chrome Remote Desktop:**
   https://remotedesktop.google.com/access

4. **Test from your Windows PC:**
   - Open browser → https://remotedesktop.google.com/access
   - Sign in → Select your Mac → Enter PIN

5. **Read the full documentation:**
   ```bash
   open ~/chrome-remote-desktop-setup/README-REMOTE-DESKTOP.md
   ```

---

**Need help?** Check the [full documentation](README-REMOTE-DESKTOP.md) or [troubleshooting guide](docs/remote-ui-sop.md#troubleshooting).

🎉 **Happy remote working!**
