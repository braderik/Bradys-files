# Chrome Remote Desktop - Security Checklist

**Version:** 1.0
**Last Updated:** 2025-11-12
**Review Frequency:** Monthly

---

## Purpose

This checklist ensures Chrome Remote Desktop is configured with security best practices to protect access to your personal Mac from unauthorized use, while maintaining compliance with work policies.

**Official Security Documentation:**
- Chrome Remote Desktop Security: https://support.google.com/chrome/answer/6204841
- Google 2-Step Verification: https://support.google.com/accounts/answer/185839

---

## Initial Setup Security

### Google Account Hardening

- [ ] **2-Step Verification (2SV) enabled**
  - Go to: https://myaccount.google.com/signinoptions/two-step-verification
  - Recommended method: Authenticator app (Google Authenticator, Authy, 1Password)
  - Avoid: SMS-only (vulnerable to SIM swapping)

- [ ] **Backup codes generated and stored securely**
  - Generate at: https://myaccount.google.com/signinoptions/two-step-verification/enroll-welcome
  - Store in password manager (NOT on Mac desktop or email)
  - Keep one physical copy in secure location (safe, wallet)

- [ ] **Security key added (optional, highest security)**
  - Recommended: YubiKey, Google Titan Key
  - Setup: https://myaccount.google.com/signinoptions/two-step-verification

- [ ] **Account recovery options up-to-date**
  - Verify recovery email and phone number
  - https://myaccount.google.com/recovery

- [ ] **Password strength verified**
  - Minimum 16 characters, unique (not reused)
  - Use password manager to generate/store
  - Check: https://myaccount.google.com/security-checkup

### Chrome Remote Desktop Configuration

- [ ] **PIN set to 8+ digits (not 6-digit minimum)**
  - Avoid: birthdays, repeating digits, sequential numbers
  - Generate random PIN via password manager

- [ ] **PIN stored securely**
  - Use password manager (1Password, Bitwarden, LastPass)
  - Do NOT store in browser, sticky notes, or plain text files

- [ ] **Device name is non-revealing**
  - Good: "Home-Mac-01"
  - Bad: "John-Smith-123-Main-St" (exposes personal info)

- [ ] **Only necessary devices are authorized**
  - Review: https://remotedesktop.google.com/access
  - Remove old/unused devices (click trash icon)

### macOS Host Security

- [ ] **FileVault (disk encryption) enabled**
  - System Preferences → Security & Privacy → FileVault
  - Required if Mac is ever physically lost/stolen

- [ ] **Automatic login disabled**
  - System Preferences → Users & Groups → Uncheck "Automatic login"
  - Requires password after reboot

- [ ] **Firewall enabled**
  - System Preferences → Security & Privacy → Firewall → Turn On Firewall
  - CRD does not require open ports (Google handles NAT traversal)

- [ ] **Screen lock after inactivity**
  - System Preferences → Security & Privacy → General
  - Set "Require password immediately after sleep or screen saver begins"
  - Desktop & Screen Saver → Start after 10 minutes

- [ ] **Gatekeeper enabled (default)**
  - Only allow apps from App Store and identified developers
  - Do NOT disable for CRD (unnecessary)

- [ ] **Software updates enabled**
  - System Preferences → Software Update → Automatic updates ON
  - Keep macOS, Chrome, and CRD current

---

## Operational Security (Ongoing)

### Session Management

- [ ] **Always disconnect after use**
  - Do NOT rely on "closing laptop" at work
  - Explicitly disconnect: Close CRD tab or Options → Disconnect

- [ ] **Verify active sessions monthly**
  - Check: https://remotedesktop.google.com/access → "Last online" timestamp
  - If suspicious, remove device and re-add with new PIN

- [ ] **Use incognito mode on shared work PCs (optional)**
  - Prevents Google Account staying signed in
  - Requires re-authentication each time

### Privacy Controls

- [ ] **Clipboard sync disabled by default**
  - In CRD window: Options (⚙️) → Uncheck "Enable clipboard sync"
  - Only enable when needed, then disable again

- [ ] **macOS notifications silenced during sessions**
  - Prevents personal messages from appearing on screen
  - Quick toggle: System Preferences → Notifications → Do Not Disturb

- [ ] **Separate browser profile for AI work (optional)**
  - Chrome → Profiles → Add → "AI Work"
  - Keeps personal browsing history separate
  - Sign out of personal accounts in this profile

- [ ] **No personal data accessed via work PC**
  - Only use for ChatGPT/Claude (work-related AI queries)
  - Do NOT browse personal email, banking, social media via CRD

### Data Handling

- [ ] **Sensitive files are NOT uploaded to ChatGPT/Claude**
  - Avoid: tax documents, medical records, credentials
  - Review OpenAI/Anthropic data policies before uploading

- [ ] **Corporate data is NOT transferred to personal Mac**
  - Violates most corporate policies
  - Use CRD only for AI tool access, not file transfer

- [ ] **Conversations with sensitive content are deleted**
  - ChatGPT: https://chat.openai.com/settings → Data Controls → Delete
  - Claude: https://claude.ai/settings → Clear conversation history

---

## Network Security

### Chrome Remote Desktop Protocol

- [ ] **Understand CRD security model** (read-only verification)
  - All traffic is end-to-end encrypted (AES-256)
  - Google cannot decrypt session content
  - OAuth 2.0 authentication with 2SV
  - No ports opened on Mac (Google relay handles NAT)
  - Reference: https://support.google.com/chrome/answer/6204841

- [ ] **Do NOT install third-party remote desktop apps as "alternatives"**
  - Examples to avoid: TeamViewer, AnyDesk (unless required by employer)
  - Stick to Google's official CRD (less attack surface)

- [ ] **Mac is behind router NAT (typical home setup)**
  - Verify: Mac has private IP (192.168.x.x or 10.x.x.x)
  - Check: System Preferences → Network → Advanced → TCP/IP
  - Do NOT put Mac in DMZ or port-forward RDP/VNC

### Work PC Network

- [ ] **Verify CRD is allowed by corporate policy**
  - Check with IT if https://remotedesktop.google.com is accessible
  - Some corporate firewalls block personal remote desktop tools

- [ ] **Use secure work PC (not public/shared computer)**
  - Avoid: library computers, hotel business centers
  - Risk: keyloggers, screen recording malware

- [ ] **Work PC is running updated antivirus/EDR**
  - Corporate-managed devices should have endpoint protection
  - Verify with IT if unsure

---

## Incident Response

### If Google Account is Compromised

1. **Immediately revoke CRD access:**
   - https://myaccount.google.com/permissions → Chrome Remote Desktop → Remove Access

2. **Change Google Account password:**
   - https://myaccount.google.com/signinoptions/password

3. **Review recent activity:**
   - https://myaccount.google.com/notifications
   - https://myaccount.google.com/device-activity

4. **Re-enable CRD only after securing account**

### If Mac is Lost/Stolen

1. **Remove Mac from CRD devices:**
   - https://remotedesktop.google.com/access → Click trash icon next to device

2. **Use Find My to lock/erase Mac:**
   - https://www.icloud.com/find → Select Mac → Lost Mode or Erase

3. **Change Google Account password (in case Mac was unlocked when stolen)**

4. **Contact local authorities with serial number**

### If Unauthorized CRD Session Detected

1. **Check "Last online" timestamp:**
   - https://remotedesktop.google.com/access → Review when device was accessed

2. **If suspicious, immediately:**
   - Remove device from CRD
   - Change Google password
   - Change CRD PIN (re-add device with new PIN)
   - Review Google Account activity logs

3. **Enable Google Account alerts:**
   - https://myaccount.google.com/notifications → Critical security alerts

---

## Compliance & Policy

### Corporate Policy Alignment

- [ ] **Remote desktop use is permitted**
  - Review employee handbook or IT acceptable use policy
  - Some employers prohibit personal remote access tools

- [ ] **AI tool use (ChatGPT/Claude) is allowed**
  - Verify with legal/compliance if using for work-related queries
  - Some industries (healthcare, finance) restrict AI use

- [ ] **No corporate credentials on personal Mac**
  - Do NOT sign into work email, Slack, GitHub, etc. via CRD
  - Keep work and personal environments strictly separated

- [ ] **No confidential corporate data on personal Mac**
  - Do NOT copy/paste proprietary code, customer data, trade secrets
  - Use CRD only for generic AI queries

### Personal Responsibility

- [ ] **Understand you are responsible for security of personal Mac**
  - Corporate IT does not manage your personal device
  - Apply same rigor as work devices (updates, backups, encryption)

- [ ] **Maintain plausible deniability for corporate data**
  - If audited, you can demonstrate no corporate data touched personal Mac
  - Keep logs/screenshots of only AI tool usage if needed

---

## Maintenance Schedule

### Weekly
- [ ] Test CRD connection (verify PIN still works)
- [ ] Review "Last online" timestamp for anomalies

### Monthly
- [ ] Run Google Security Checkup: https://myaccount.google.com/security-checkup
- [ ] Update Chrome and macOS
- [ ] Review authorized CRD devices (remove unused)
- [ ] Verify backup codes are still accessible

### Quarterly (Every 90 Days)
- [ ] Rotate CRD PIN (remove and re-add device with new PIN)
- [ ] Review Google Account recovery options
- [ ] Audit ChatGPT/Claude conversation history (delete if needed)

### Annually
- [ ] Change Google Account password
- [ ] Review and update this security checklist
- [ ] Re-verify corporate policy allows CRD usage

---

## Security Audit Record

| Date | Reviewer | Checklist Version | Issues Found | Status |
|------|----------|-------------------|--------------|--------|
| YYYY-MM-DD | | 1.0 | None / See notes | Pass / Fail |
| | | | | |
| | | | | |

**Notes:**
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________

---

## Quick Reference: Security Best Practices

| Risk | Mitigation |
|------|------------|
| Unauthorized CRD access | 2SV + strong PIN (8+ digits) + regular password rotation |
| Compromised Google Account | 2SV + backup codes + security key (optional) |
| Data leakage to personal Mac | Never transfer corporate data; CRD only for AI tools |
| Session hijacking | Always disconnect after use; monitor "Last online" |
| Physical Mac theft | FileVault encryption + Find My enabled + screen lock |
| Work policy violation | Verify CRD and AI tools are allowed; keep audit trail |
| Weak authentication | Unique password (16+ chars) + authenticator app, not SMS |

---

## Appendix: Recommended Tools

### Password Managers (for PIN and password storage)
- 1Password: https://1password.com
- Bitwarden: https://bitwarden.com
- LastPass: https://www.lastpass.com

### Two-Factor Authenticator Apps
- Google Authenticator: https://support.google.com/accounts/answer/1066447
- Authy: https://authy.com
- 1Password (built-in TOTP): https://support.1password.com/one-time-passwords/

### Security Keys (hardware 2FA)
- YubiKey: https://www.yubico.com
- Google Titan Security Key: https://store.google.com/product/titan_security_key

---

**Document Owner:** Brady
**Next Review Date:** 2025-12-12
**Compliance Verified:** ☐ Yes ☐ No ☐ N/A
