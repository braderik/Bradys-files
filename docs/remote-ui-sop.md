# Remote Desktop UI - Standard Operating Procedure

**Version:** 1.0
**Target:** Access ChatGPT and Claude web interfaces from work Windows PC via Chrome Remote Desktop
**Host:** macOS (personal/home computer)
**Client:** Windows PC (work computer)

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Mac Host Configuration](#mac-host-configuration)
4. [Windows Client Setup](#windows-client-setup)
5. [Daily Operations](#daily-operations)
6. [Troubleshooting](#troubleshooting)
7. [Security Best Practices](#security-best-practices)

---

## Overview

### Purpose
Enable secure remote access from a work Windows PC to a personal Mac, providing full control of ChatGPT and Claude web interfaces through Chrome Remote Desktop.

### Architecture
```
Windows PC (work)
    ↓ [HTTPS + E2E encrypted]
Chrome Remote Desktop Service (Google)
    ↓ [HTTPS + E2E encrypted]
macOS (home) → Browser → chat.openai.com + claude.ai
```

### Key Security Features
- End-to-end encryption via Chrome Remote Desktop
- Google Account 2-Step Verification (2SV) required
- PIN protection for unattended access
- No open ports or custom VPN required

**Official Documentation:**
- Chrome Remote Desktop: https://support.google.com/chrome/answer/1649523
- Security overview: https://support.google.com/chrome/answer/6204841

---

## Prerequisites

### Required Accounts
- [ ] Google Account with 2-Step Verification enabled
- [ ] ChatGPT account (free or paid)
- [ ] Claude account (optional, for parity testing)

### Software Requirements

**macOS (Host):**
- macOS 10.15 (Catalina) or later
- Google Chrome browser (latest stable)
- Chrome Remote Desktop extension
- Active internet connection (recommended: 5+ Mbps upload)

**Windows PC (Client):**
- Windows 10/11 with modern browser (Chrome, Edge, Firefox)
- Access to https://remotedesktop.google.com (verify not blocked by corporate firewall)

### Hardware Requirements

**macOS:**
- Must remain powered on during remote sessions
- Recommended: connected to AC power with "prevent sleep" enabled
- Minimum 8GB RAM for smooth browser performance

---

## Mac Host Configuration

### Step 1: Install Chrome Remote Desktop

1. Open Chrome on your Mac
2. Navigate to: https://remotedesktop.google.com/access
3. Click **"Set up Remote Access"** (under "Remote Access")
4. Click **"Download"** to install the Chrome Remote Desktop extension
5. Click **"Add to Chrome"** → **"Add extension"**
6. The installer will download automatically

### Step 2: Run the Chrome Remote Desktop Installer

1. Open the downloaded `.dmg` file
2. Follow the installation wizard
3. **Grant permissions when prompted:**
   - Screen Recording permission (required)
   - Accessibility permission (required)
   - System Preferences → Security & Privacy → Privacy tab

### Step 3: Configure Remote Access

1. Return to https://remotedesktop.google.com/access in Chrome
2. Under "Set up Remote Access," click **"Turn on"**
3. **Name your computer** (e.g., "Home-Mac-AI")
4. **Choose a PIN** (minimum 6 digits, recommend 8+)
   - Store securely (1Password, Bitwarden, etc.)
   - Do NOT share or reuse from other services
5. Click **"Start"**

Your Mac should now appear in the "Remote devices" list.

### Step 4: Run Automated Setup Script

Download and run the setup script to configure power management and auto-launch:

```bash
# Navigate to the scripts directory
cd ~/Downloads/Bradys-files/scripts

# Make scripts executable
chmod +x setup-mac-host.sh launch-ai-desktop.sh

# Run setup (will prompt for sudo password for power settings)
./setup-mac-host.sh
```

**What this script does:**
- Validates Chrome and Chrome Remote Desktop installation
- Disables system sleep on AC power (display can still sleep)
- Sets up `launch-ai-desktop.sh` to run at login
- Creates LaunchAgent for automatic browser tab opening

### Step 5: Manual Power Settings (if script fails)

1. Open **System Preferences** → **Energy Saver** (or **Battery** on newer macOS)
2. For "Power Adapter" tab:
   - Set **"Turn display off after"** to 10-15 minutes (or Never)
   - Uncheck **"Put hard disks to sleep when possible"**
   - Check **"Prevent automatic sleeping when the display is off"**
   - Uncheck **"Enable Power Nap"** (optional, reduces wake-ups)

### Step 6: Configure Browser for AI Services

1. Open Chrome (or your preferred browser)
2. Navigate to:
   - https://chat.openai.com/
   - https://claude.ai/
3. Sign in to both services
4. **Optional:** Right-click tabs → **"Pin Tab"** for persistence
5. **Optional:** Create a separate Chrome profile dedicated to AI work
   - Chrome → Profiles → Add → "AI Work"

### Step 7: Test Auto-Launch

```bash
# Manually test the launch script
./scripts/launch-ai-desktop.sh
```

You should see Chrome open with both ChatGPT and Claude tabs.

---

## Windows Client Setup

### Step 1: Verify Access to Chrome Remote Desktop

1. Open browser on Windows PC
2. Navigate to: https://remotedesktop.google.com/access
3. **If blocked:** Contact IT to whitelist `remotedesktop.google.com` (Google-owned, enterprise-approved)

### Step 2: Sign In

1. Sign in with the **same Google Account** used on the Mac
2. If 2-Step Verification is enabled (required), complete the 2SV challenge

### Step 3: Connect to Mac

1. Under "Remote devices," you should see your Mac (e.g., "Home-Mac-AI")
2. Click on the device name
3. Enter the PIN you created in Mac setup
4. Click **"Connect"**

**First connection:**
- May take 10-15 seconds to establish
- You'll see your Mac desktop in the browser window
- Mouse and keyboard should be fully responsive

---

## Daily Operations

### Connecting from Work PC

1. Open browser → https://remotedesktop.google.com/access
2. Select your Mac device
3. Enter PIN
4. Wait for connection (typically 5-10 seconds)

**Post-connection checklist:**
- [ ] Browser tabs (ChatGPT, Claude) are already open (auto-launch)
- [ ] Test keyboard input in one of the chat interfaces
- [ ] Verify mouse scrolling works smoothly

### Using ChatGPT via Remote Desktop

1. Click into the ChatGPT tab
2. Type prompts as normal
3. **Copy/paste:**
   - Text automatically syncs between Windows clipboard and Mac (if enabled in CRD settings)
   - To disable: Click Options (⚙️) in CRD toolbar → Uncheck "Enable clipboard sync"

### Using Claude via Remote Desktop

1. Click into the Claude tab
2. Interface is identical to local usage
3. **File uploads:**
   - Upload from Mac's local filesystem (not Windows)
   - Alternative: use clipboard paste for text content

### Adjusting Performance

**If laggy or low frame rate:**

1. Click **Options** (⚙️ icon) in the Chrome Remote Desktop toolbar
2. **Reduce quality:**
   - Move slider left toward "Faster"
   - Trades visual quality for responsiveness
3. **Close unnecessary applications** on Mac to free resources
4. **Check network:**
   - Windows PC: Ensure stable connection (Wi-Fi or Ethernet)
   - Mac: Check upload speed (should be 2+ Mbps)

**Target performance:**
- Input latency: < 200ms (keyboard to screen update)
- Frame rate: 20-30 fps minimum for comfortable use
- Text readability: 100% zoom, no scaling required

### Disconnecting Safely

**Option 1: Close the browser tab**
- Safest method
- Mac session continues running in background

**Option 2: Use CRD disconnect**
1. Click **Options** (⚙️) in CRD toolbar
2. Click **"Disconnect"**

**Option 3: Shut down Mac remotely (end of day)**
1. On Mac desktop (via CRD): Apple menu → Shut Down
2. Next session will require physical power-on or Wake-on-LAN

---

## Troubleshooting

### Mac not appearing in Remote Devices list

**Possible causes:**

1. **Mac is asleep/powered off**
   - Physical check required, or smart plug/remote power management

2. **Chrome Remote Desktop service not running**
   - On Mac: Check System Preferences → Users & Groups → Login Items
   - Ensure "ChromeRemoteDesktopHost" is listed and enabled

3. **Signed into different Google Account**
   - Verify account match on both devices
   - Sign out and back in if needed

4. **Network connectivity issue**
   - On Mac: Open Terminal, run `ping google.com` to verify internet
   - Check router/firewall settings (ensure no blocking of Google services)

### "PIN is incorrect" error

- Verify you're entering the correct PIN (check password manager)
- If forgotten, remove and re-add the device:
  1. On Mac: https://remotedesktop.google.com/access
  2. Click trash icon next to device → Remove
  3. Re-run setup (Step 3 in Mac Host Configuration)

### Poor performance / lag

**Diagnose:**

1. **Network speed test:**
   - Mac: https://fast.com → Check upload speed (should be 5+ Mbps)
   - Windows: Check download speed (should be 10+ Mbps)

2. **Mac resource usage:**
   - Open Activity Monitor on Mac (via CRD)
   - Check CPU and Memory tabs
   - Close resource-heavy apps (Xcode, video editors, etc.)

3. **Windows PC resources:**
   - Check Task Manager
   - Close unnecessary browser tabs/apps

**Solutions:**
- Lower quality in CRD options (⚙️)
- Restart browser on Windows PC
- Restart Chrome Remote Desktop on Mac:
  ```bash
  # In Terminal on Mac
  sudo launchctl stop com.google.chromeremotedesktop
  sudo launchctl start com.google.chromeremotedesktop
  ```

### Clipboard sync not working

1. In CRD window: Options (⚙️) → Verify "Enable clipboard sync" is checked
2. Try copying small plain text first (complex formatting may fail)
3. Restart CRD connection

### Mac went to sleep during session

**Prevention:**
1. Re-run `setup-mac-host.sh` to ensure power settings applied
2. Or manually:
   ```bash
   sudo pmset -c sleep 0
   ```
3. Connect Mac to AC power (required for "prevent sleep" to work)

---

## Security Best Practices

### Account Security

- [ ] Enable 2-Step Verification on Google Account
  - https://myaccount.google.com/signinoptions/two-step-verification
- [ ] Generate and store backup codes securely
- [ ] Use a unique, strong PIN for Chrome Remote Desktop (8+ digits)
- [ ] Store PIN in password manager, not browser or sticky notes

### Session Management

- [ ] **Always disconnect** when finished (don't just close work PC)
- [ ] Review active sessions: https://remotedesktop.google.com/access → Look for "Last online"
- [ ] If suspicious activity: Remove device and re-add with new PIN

### Privacy on Mac

- [ ] Create a dedicated macOS user for "AI Work" (optional)
  - System Preferences → Users & Groups → Add user
  - Keeps personal files/notifications separate
- [ ] Disable notifications during remote sessions
  - System Preferences → Notifications → Do Not Disturb
- [ ] Use incognito/private browser profile if handling sensitive prompts

### Corporate Compliance

- [ ] Verify Chrome Remote Desktop is allowed by IT policy
- [ ] Do NOT use for transferring corporate data to personal Mac
- [ ] Do NOT use work credentials on personal Mac
- [ ] Review acceptable use policy for external AI tools

### Network Security

- [ ] Chrome Remote Desktop uses end-to-end encryption (AES-256)
- [ ] No open ports required (Google handles NAT traversal)
- [ ] All traffic routes through Google's authenticated relay
- [ ] Do NOT install third-party remote desktop apps as alternatives

**Google's Security Documentation:**
- https://support.google.com/chrome/answer/6204841

---

## Maintenance

### Weekly

- [ ] Check for macOS updates: System Preferences → Software Update
- [ ] Check for Chrome updates: Chrome menu → About Google Chrome
- [ ] Test CRD connection from work PC

### Monthly

- [ ] Review Google Account security: https://myaccount.google.com/security-checkup
- [ ] Verify backup codes are accessible
- [ ] Clean up Mac storage if low (< 20GB free)

### As Needed

- [ ] Rotate Chrome Remote Desktop PIN (every 90 days recommended)
- [ ] Review and remove old/unused remote devices from CRD settings

---

## Quick Reference

| Action | Mac (Host) | Windows (Client) |
|--------|-----------|------------------|
| Install CRD | https://remotedesktop.google.com/access → Download | N/A (web-based) |
| Connect | N/A | https://remotedesktop.google.com/access → Select device |
| Disconnect | N/A | Close tab or Options → Disconnect |
| Change PIN | CRD settings → Remove device → Re-add | N/A |
| Auto-launch tabs | `./scripts/launch-ai-desktop.sh` | N/A |
| Check status | System Preferences → Users & Groups → Login Items | Browser → CRD Access page |

---

## Support Resources

- **Chrome Remote Desktop Help:** https://support.google.com/chrome/answer/1649523
- **Google Account Help:** https://support.google.com/accounts
- **ChatGPT Help:** https://help.openai.com/
- **Claude Help:** https://support.anthropic.com/

---

**Document Owner:** Brady
**Last Updated:** 2025-11-12
**Next Review:** 2025-12-12
