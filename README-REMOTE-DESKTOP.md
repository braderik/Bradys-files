# Chrome Remote Desktop Setup for ChatGPT & Claude Access

🚀 **Quick Start Guide**: Access ChatGPT and Claude web interfaces from your work Windows PC by remotely controlling your personal Mac using Chrome Remote Desktop.

---

## 📋 What This Is

A complete, production-ready setup that lets you:
- Control your Mac from a Windows PC through a browser
- Access ChatGPT and Claude web interfaces with full feature parity
- Maintain end-to-end encryption and 2-factor authentication
- Auto-launch AI tools when you connect
- Comply with corporate security policies (no custom VPN or open ports)

**Architecture:** `Windows PC` → `Chrome Remote Desktop (Google)` → `Mac` → `ChatGPT + Claude`

---

## ⚡ Quick Start (5 Minutes)

### On Your Mac (One-Time Setup)

1. **Download this repository to your Mac:**
   ```bash
   # If you have git:
   git clone https://github.com/braderik/Bradys-files.git ~/Bradys-files

   # Or download ZIP and extract to ~/Bradys-files
   ```

2. **Run the automated setup:**
   ```bash
   cd ~/Bradys-files
   chmod +x scripts/setup-mac-host.sh scripts/launch-ai-desktop.sh
   ./scripts/setup-mac-host.sh
   ```

   This will:
   - Verify Chrome Remote Desktop is installed (prompts to install if missing)
   - Configure power management (prevent sleep on AC power)
   - Set up auto-launch of ChatGPT and Claude tabs at login

3. **Set up Chrome Remote Desktop:**
   - Open Chrome on your Mac
   - Go to: https://remotedesktop.google.com/access
   - Click "Set up Remote Access" → Download and install
   - Name your Mac (e.g., "Home-Mac-AI")
   - Create a strong PIN (8+ digits) and save it in your password manager

4. **Enable 2-Step Verification on your Google Account:**
   - Go to: https://myaccount.google.com/signinoptions/two-step-verification
   - Follow the setup wizard
   - **Save backup codes securely!**

### On Your Windows Work PC (Every Time You Connect)

1. Open browser → https://remotedesktop.google.com/access
2. Sign in with the same Google Account
3. Click your Mac device → Enter PIN
4. ChatGPT and Claude tabs should already be open and ready!

**That's it!** You're now controlling your Mac and can use ChatGPT/Claude as if you were sitting at your Mac.

---

## 📁 Repository Contents

```
Bradys-files/
├── README-REMOTE-DESKTOP.md       ← You are here
├── scripts/
│   ├── launch-ai-desktop.sh        ← Auto-opens ChatGPT & Claude tabs
│   └── setup-mac-host.sh           ← One-time Mac configuration
├── docs/
│   ├── remote-ui-sop.md            ← Complete setup & operations manual
│   ├── test-plan-remote-ui.md      ← Acceptance testing checklist
│   ├── security-checklist.md       ← Security hardening guide
│   └── claude-parity-notes.md      ← ChatGPT vs Claude feature comparison
```

---

## 📖 Documentation

### Essential Reading

1. **[Remote UI SOP](docs/remote-ui-sop.md)** – Complete setup, daily operations, and troubleshooting
2. **[Security Checklist](docs/security-checklist.md)** – Hardening steps and compliance guidance

### Optional Reading

3. **[Test Plan](docs/test-plan-remote-ui.md)** – Validate your setup works correctly
4. **[Claude Parity Notes](docs/claude-parity-notes.md)** – UI differences between ChatGPT and Claude
5. **[Weekly Finance Agent Architecture](docs/weekly-finance-agent-architecture.md)** – Draft architecture for guarded banking, transfer, and ETF-investing automation

---

## 🔒 Security Features

This setup is designed with security best practices:

- ✅ **End-to-end encryption** (AES-256) via Chrome Remote Desktop
- ✅ **2-Step Verification** required on Google Account
- ✅ **PIN protection** for unattended Mac access (8+ digit PIN recommended)
- ✅ **No open ports** on your Mac (Google handles NAT traversal)
- ✅ **No custom VPN** or corporate firewall conflicts
- ✅ **Session logging** (review "Last online" timestamps)

**Official Security Docs:** https://support.google.com/chrome/answer/6204841

---

## 🛠️ System Requirements

### Mac (Host Computer)
- macOS 10.15 (Catalina) or later
- Google Chrome (latest stable)
- 8GB+ RAM recommended
- Active internet connection (5+ Mbps upload recommended)
- Must remain powered on during remote sessions

### Windows PC (Work Computer)
- Windows 10/11 with modern browser (Chrome, Edge, Firefox)
- Access to https://remotedesktop.google.com (verify not blocked by corporate firewall)
- Internet connection (10+ Mbps download recommended)

---

## 🎯 Usage Scenarios

### Scenario 1: Quick AI Query
**Time:** 30 seconds

1. Connect via CRD → Enter PIN
2. ChatGPT/Claude tabs already open
3. Type prompt → Get answer
4. Copy/paste to work PC
5. Disconnect

### Scenario 2: Extended Conversation
**Time:** 5-30 minutes

1. Connect via CRD
2. Use ChatGPT or Claude for multi-turn conversation
3. Upload files from Mac (if needed)
4. Export/copy results
5. Disconnect when done

### Scenario 3: Compare ChatGPT vs Claude
**Time:** 2-10 minutes

1. Connect via CRD
2. Arrange browser tabs side-by-side on Mac (via CRD)
3. Type same prompt in both services
4. Compare responses
5. Copy preferred answer to work PC

---

## 🧪 Testing Your Setup

After installation, run through the [Test Plan](docs/test-plan-remote-ui.md) to verify:

- [ ] Connection establishes in ≤15 seconds
- [ ] Input latency is ≤200ms
- [ ] ChatGPT and Claude both work correctly
- [ ] 2-Step Verification and PIN are enforced
- [ ] Clipboard sync works (if enabled)
- [ ] Mac re-appears after reboot

**Acceptance criteria:** All critical tests (T-1 through T-6) must pass before daily use.

---

## 🐛 Troubleshooting

### Mac not appearing in Remote Devices list
1. Verify Mac is powered on and connected to internet
2. Check System Preferences → Users & Groups → Login Items for "ChromeRemoteDesktopHost"
3. Ensure you're signed into the same Google Account on both devices

### Poor performance / lag
1. Test network speed: https://fast.com (Mac should have 5+ Mbps upload)
2. Close unnecessary apps on Mac (Activity Monitor → CPU/Memory)
3. Reduce quality in CRD options (⚙️ icon → move slider toward "Faster")

### "PIN is incorrect" error
1. Verify PIN in your password manager
2. If forgotten: Remove device from CRD settings and re-add with new PIN

**Full troubleshooting guide:** [Remote UI SOP § Troubleshooting](docs/remote-ui-sop.md#troubleshooting)

---

## 🔄 Maintenance

### Weekly
- [ ] Test CRD connection from work PC
- [ ] Review "Last online" timestamp for anomalies

### Monthly
- [ ] Run Google Security Checkup: https://myaccount.google.com/security-checkup
- [ ] Update Chrome and macOS
- [ ] Review authorized CRD devices (remove unused)

### Quarterly (Every 90 Days)
- [ ] Rotate CRD PIN (remove and re-add device with new PIN)
- [ ] Audit ChatGPT/Claude conversation history

**Full maintenance schedule:** [Security Checklist § Maintenance](docs/security-checklist.md#maintenance-schedule)

---

## ❓ FAQ

### Q: Is this allowed by my employer?
**A:** Chrome Remote Desktop is a Google product commonly used in enterprise environments. However, verify with your IT policy regarding personal remote desktop usage. This setup does NOT transfer corporate data to your personal Mac.

### Q: Can I use this to access other applications besides ChatGPT/Claude?
**A:** Yes! CRD gives full control of your Mac. However, this repository is optimized for AI tool access. Avoid accessing corporate systems on your personal Mac.

### Q: What if my Mac goes to sleep?
**A:** The `setup-mac-host.sh` script disables system sleep on AC power. Ensure your Mac stays plugged in during work hours. Alternatively, use a smart plug or Wake-on-LAN.

### Q: How secure is this?
**A:** Very secure. CRD uses end-to-end AES-256 encryption, requires Google Account 2SV, and a separate PIN for Mac access. No ports are opened on your Mac. See [Security Checklist](docs/security-checklist.md) for full details.

### Q: Can I upload files from my Windows PC to ChatGPT/Claude?
**A:** Not directly. Files must be on the Mac's filesystem. Workaround: Upload files from Windows to Google Drive/Dropbox, then download to Mac via CRD.

### Q: Does this use APIs?
**A:** No. This setup uses the ChatGPT and Claude **web interfaces** (browser-based). No API keys or coding required.

### Q: What happens to my conversations?
**A:** Conversations are stored by OpenAI (ChatGPT) and Anthropic (Claude) on their servers, subject to their privacy policies. CRD does not log conversation content (only transmits screen pixels).

---

## 🆘 Support Resources

- **Chrome Remote Desktop Help:** https://support.google.com/chrome/answer/1649523
- **ChatGPT Help:** https://help.openai.com
- **Claude Help:** https://support.anthropic.com
- **Google Account Security:** https://myaccount.google.com/security-checkup

---

## 📜 License & Disclaimer

This repository is provided as-is for personal use. The author is not responsible for:
- Violations of corporate IT policies
- Data breaches or security incidents
- Service outages (Google, OpenAI, Anthropic)

**Use at your own risk.** Always verify compliance with your employer's acceptable use policy.

---

## 🤝 Contributing

Found a bug or have a suggestion? Please open an issue or submit a pull request.

**Maintainer:** Brady (braderik)
**Last Updated:** 2025-11-12

---

## 🚀 Next Steps

1. **Run setup on your Mac:** `./scripts/setup-mac-host.sh`
2. **Enable Google 2SV:** https://myaccount.google.com/signinoptions/two-step-verification
3. **Test connection from work PC:** https://remotedesktop.google.com/access
4. **Read the full SOP:** [docs/remote-ui-sop.md](docs/remote-ui-sop.md)
5. **Run the test plan:** [docs/test-plan-remote-ui.md](docs/test-plan-remote-ui.md)

**Happy remote working! 🎉**
