# Chrome Remote Desktop - Test Plan

**Version:** 1.0
**System:** macOS (host) → Windows PC (client) → ChatGPT + Claude web UI
**Test Date:** ___________
**Tester:** ___________

---

## Purpose

Validate that Chrome Remote Desktop provides reliable, secure, and performant access to ChatGPT and Claude web interfaces from a work Windows PC to a personal Mac.

---

## Pre-Test Checklist

Before running tests, verify setup completion:

- [ ] Mac has Chrome Remote Desktop installed and configured
- [ ] Mac appears in https://remotedesktop.google.com/access (from any device)
- [ ] Google Account has 2-Step Verification enabled
- [ ] PIN is set and stored securely
- [ ] `setup-mac-host.sh` has been run successfully
- [ ] `launch-ai-desktop.sh` is executable and tested locally
- [ ] Mac is powered on and connected to internet
- [ ] Windows PC has access to https://remotedesktop.google.com

---

## Test Cases

### T-1: Connectivity

**Objective:** Verify connection establishment from Windows PC to Mac host.

**Steps:**
1. On Windows PC, open browser
2. Navigate to https://remotedesktop.google.com/access
3. Sign in with Google Account (if not already signed in)
4. Locate Mac device in "Remote devices" list
5. Click device name
6. Enter PIN
7. Start timer when "Connect" is clicked
8. Stop timer when Mac desktop is visible and interactive

**Expected Results:**
- [ ] **PASS:** Mac device appears in Remote devices list
- [ ] **PASS:** Connection established in ≤ 15 seconds
- [ ] **PASS:** Mac desktop is visible and fully rendered
- [ ] **PASS:** No error messages or connection failures

**Actual Results:**
- Connection time: _______ seconds
- Status: PASS / FAIL
- Notes: _________________________________________________

---

### T-2: UI Control - ChatGPT

**Objective:** Verify full control of ChatGPT web interface via remote desktop.

**Prerequisites:** T-1 passed, connected to Mac

**Steps:**
1. On remote Mac desktop, locate ChatGPT browser tab (should be auto-launched)
2. Click into the ChatGPT input field
3. Type the prompt: "Write a haiku about remote work"
4. Press Enter or click Send
5. Wait for response to complete
6. Select and copy a portion of the response text (Ctrl+C / Cmd+C)
7. Open a text editor on the Mac
8. Paste the copied text (Ctrl+V / Cmd+V)

**Expected Results:**
- [ ] **PASS:** ChatGPT tab is already open (auto-launch worked)
- [ ] **PASS:** Mouse click accurately selects input field
- [ ] **PASS:** Keyboard input appears correctly in ChatGPT
- [ ] **PASS:** ChatGPT responds normally (same as local usage)
- [ ] **PASS:** Text selection works smoothly
- [ ] **PASS:** Copy/paste works between ChatGPT and Mac text editor
- [ ] **PASS:** Scrolling through conversation history is smooth

**Actual Results:**
- Auto-launch: YES / NO
- Input lag (subjective): None / Slight / Noticeable / Severe
- Response rendering: Normal / Choppy / Delayed
- Copy/paste: Works / Fails
- Status: PASS / FAIL
- Notes: _________________________________________________

---

### T-3: UI Control - Claude

**Objective:** Verify full control of Claude web interface with feature parity to ChatGPT.

**Prerequisites:** T-1 passed, connected to Mac

**Steps:**
1. On remote Mac desktop, locate Claude browser tab (should be auto-launched)
2. Verify sign-in status (should be already signed in)
3. Click into the Claude input field
4. Type the prompt: "Explain the difference between JSON and YAML in one sentence"
5. Press Enter or click Send
6. Wait for response to complete
7. Select and copy the entire response text
8. Paste into a text editor on the Mac

**Expected Results:**
- [ ] **PASS:** Claude tab is already open and user is signed in
- [ ] **PASS:** Mouse and keyboard input work correctly
- [ ] **PASS:** Claude responds normally
- [ ] **PASS:** Text selection and copy/paste work
- [ ] **PASS:** Scrolling is smooth
- [ ] **PASS:** Feature parity with ChatGPT test (no significant UX difference)

**Actual Results:**
- Auto-launch: YES / NO
- Sign-in status: Signed in / Signed out / Error
- Input lag: None / Slight / Noticeable / Severe
- Copy/paste: Works / Fails
- Status: PASS / FAIL
- Notes: _________________________________________________

---

### T-4: Security - 2-Step Verification

**Objective:** Confirm 2-Step Verification protects account access.

**Prerequisites:** Google Account must have 2SV enabled

**Steps:**
1. Open a new incognito/private browser window on Windows PC
2. Navigate to https://remotedesktop.google.com/access
3. Click "Sign in"
4. Enter Google Account email
5. Enter password
6. Observe 2SV challenge (SMS, authenticator app, or security key prompt)
7. Complete 2SV challenge
8. Verify access to Remote Devices list

**Expected Results:**
- [ ] **PASS:** 2SV challenge appears before accessing Remote Devices
- [ ] **PASS:** Cannot bypass 2SV (required step)
- [ ] **PASS:** After successful 2SV, Mac device is visible

**Actual Results:**
- 2SV method used: SMS / Authenticator / Security Key / Other: _______
- Status: PASS / FAIL
- Notes: _________________________________________________

---

### T-5: Security - PIN Challenge

**Objective:** Verify PIN is required for every connection attempt.

**Prerequisites:** T-1 passed at least once

**Steps:**
1. If currently connected, disconnect from Mac (close CRD tab or use Options → Disconnect)
2. Wait 10 seconds
3. Navigate to https://remotedesktop.google.com/access again
4. Click Mac device name
5. Attempt to connect **without entering PIN** (if possible)
6. Enter incorrect PIN (e.g., "000000")
7. Observe error message
8. Enter correct PIN
9. Verify connection succeeds

**Expected Results:**
- [ ] **PASS:** PIN prompt appears every time (not cached)
- [ ] **PASS:** Incorrect PIN is rejected with clear error message
- [ ] **PASS:** Correct PIN allows connection
- [ ] **PASS:** No way to bypass PIN entry

**Actual Results:**
- PIN caching: None (always prompted) / Cached for X minutes
- Incorrect PIN error: Clear / Confusing / No error shown
- Status: PASS / FAIL
- Notes: _________________________________________________

---

### T-6: Security - Session Termination

**Objective:** Verify disconnection immediately ends remote control.

**Prerequisites:** T-1 passed, currently connected

**Steps:**
1. While connected to Mac, open a text editor on the Mac
2. Start typing a sentence
3. On Windows PC, disconnect via:
   - Method A: Close the Chrome Remote Desktop browser tab
   - OR Method B: Click Options (⚙️) → Disconnect
4. Immediately attempt to click or type on the Mac desktop (should not respond)
5. Reconnect and check if the text editor still shows the partial sentence (should be unchanged since disconnect)

**Expected Results:**
- [ ] **PASS:** Disconnect happens instantly (< 2 seconds)
- [ ] **PASS:** No further input is registered after disconnect
- [ ] **PASS:** Mac state is preserved (text editor content unchanged)
- [ ] **PASS:** Reconnection requires PIN re-entry

**Actual Results:**
- Disconnect latency: _______ seconds
- Input after disconnect: Ignored / Still processed (BUG)
- Status: PASS / FAIL
- Notes: _________________________________________________

---

### T-7: Performance - Input Latency

**Objective:** Measure subjective input lag to ensure usability.

**Prerequisites:** T-1 passed, connected with stable network

**Steps:**
1. While connected, open ChatGPT or Claude input field
2. Hold down a single key (e.g., "a") and observe character repetition
3. Release key and note delay before characters stop appearing
4. Perform rapid typing test (type pangram: "The quick brown fox jumps over the lazy dog")
5. Observe whether characters appear smoothly or with noticeable delay

**Expected Results:**
- [ ] **PASS:** Key press → character appearance delay < 200 ms (subjective)
- [ ] **PASS:** Key release lag < 100 ms
- [ ] **PASS:** Rapid typing feels responsive (no "buffering" of characters)
- [ ] **ACCEPTABLE:** Occasional minor lag (< 300 ms), but not constant

**Actual Results:**
- Subjective latency: Excellent (<100ms) / Good (<200ms) / Acceptable (<300ms) / Poor (>300ms)
- Network conditions during test: WiFi / Ethernet / Mobile hotspot
- Status: PASS / FAIL
- Notes: _________________________________________________

---

### T-8: Performance - Frame Rate & Smoothness

**Objective:** Verify visual responsiveness during scrolling and UI interactions.

**Prerequisites:** T-1 passed, connected

**Steps:**
1. Open a long ChatGPT or Claude conversation (or any long webpage)
2. Scroll rapidly up and down using mouse wheel
3. Observe:
   - Frame rate (smooth / choppy / slideshow)
   - Text readability during scroll (clear / blurry / unreadable)
   - Delay between scroll input and screen update
4. Open Chrome Remote Desktop options (⚙️) and check current quality setting
5. If performance is poor, reduce quality slider and re-test

**Expected Results:**
- [ ] **PASS:** Frame rate ≥ 20 fps (smooth enough to read while scrolling)
- [ ] **PASS:** Text is readable at 100% zoom (no need to zoom in)
- [ ] **ACCEPTABLE:** Minor frame drops during rapid scrolling, but usable
- [ ] **PASS:** Adjusting quality slider improves performance if needed

**Actual Results:**
- Subjective frame rate: Smooth (>30fps) / Acceptable (20-30fps) / Choppy (<20fps)
- Text readability: Clear / Slightly blurry / Unreadable
- Quality setting used: Auto / High / Medium / Low
- Status: PASS / FAIL
- Notes: _________________________________________________

---

### T-9: Resilience - Host Reboot

**Objective:** Confirm Mac re-appears in Remote Devices list after reboot without manual intervention.

**Prerequisites:** `setup-mac-host.sh` has been run (configures auto-start)

**Steps:**
1. While connected to Mac via CRD, initiate a reboot:
   - Apple menu → Restart
2. Wait for Mac to fully reboot (2-5 minutes)
3. On Windows PC, refresh https://remotedesktop.google.com/access
4. Check if Mac device re-appears as "Online"
5. Attempt to connect
6. Verify `launch-ai-desktop.sh` auto-launched browser tabs

**Expected Results:**
- [ ] **PASS:** Mac re-appears in Remote Devices list within 5 minutes of reboot
- [ ] **PASS:** Device status shows "Online" (not "Offline")
- [ ] **PASS:** Connection succeeds normally (PIN required)
- [ ] **PASS:** ChatGPT and Claude tabs auto-launch after reboot

**Actual Results:**
- Time to re-appear: _______ minutes
- Auto-launch status: Worked / Failed
- Status: PASS / FAIL
- Notes: _________________________________________________

---

### T-10: Clipboard Sync (Optional)

**Objective:** Verify clipboard synchronization between Windows PC and Mac.

**Prerequisites:** T-1 passed, "Enable clipboard sync" is ON in CRD options

**Steps:**
1. On Windows PC (outside the CRD window), copy text to clipboard (e.g., "Hello from Windows")
2. In the CRD window (Mac side), paste into a text editor (Cmd+V)
3. On Mac side (via CRD), copy different text (e.g., "Hello from Mac")
4. On Windows PC (outside CRD window), paste into Notepad/Word
5. Verify bidirectional sync

**Expected Results:**
- [ ] **PASS:** Text copied on Windows appears on Mac clipboard
- [ ] **PASS:** Text copied on Mac appears on Windows clipboard
- [ ] **PASS:** Clipboard sync works for plain text (rich formatting may not transfer)

**Actual Results:**
- Windows → Mac: Works / Fails
- Mac → Windows: Works / Fails
- Status: PASS / FAIL
- Notes: _________________________________________________

---

## Test Summary

| Test Case | Status | Notes |
|-----------|--------|-------|
| T-1: Connectivity | ☐ Pass ☐ Fail | |
| T-2: ChatGPT UI Control | ☐ Pass ☐ Fail | |
| T-3: Claude UI Control | ☐ Pass ☐ Fail | |
| T-4: 2-Step Verification | ☐ Pass ☐ Fail | |
| T-5: PIN Challenge | ☐ Pass ☐ Fail | |
| T-6: Session Termination | ☐ Pass ☐ Fail | |
| T-7: Input Latency | ☐ Pass ☐ Fail | |
| T-8: Frame Rate | ☐ Pass ☐ Fail | |
| T-9: Host Reboot Resilience | ☐ Pass ☐ Fail | |
| T-10: Clipboard Sync | ☐ Pass ☐ Fail | |

**Overall Result:** ☐ All Pass ☐ Minor Issues ☐ Major Issues

---

## Issues & Observations

**Critical Issues (must fix before production use):**
1. _______________________________________________________________
2. _______________________________________________________________

**Minor Issues (nice to have, but not blocking):**
1. _______________________________________________________________
2. _______________________________________________________________

**Observations:**
- Network speed during tests (Mac upload / Windows download): _______ Mbps
- Mac hardware: _______________________________________________
- Windows PC hardware: ________________________________________
- Time of day (network congestion factor): _____________________

---

## Acceptance Criteria

System is **READY FOR PRODUCTION USE** if:

- [ ] All critical tests (T-1, T-2, T-3, T-4, T-5, T-6) pass
- [ ] Performance tests (T-7, T-8) are "acceptable" or better
- [ ] No security bypasses are possible
- [ ] User reports positive subjective experience

**Approved by:** _______________  **Date:** _______________

---

## Appendix: Network Speed Test Procedure

**On Mac (to test upload speed, critical for CRD hosting):**
1. Open browser on Mac (locally or via CRD)
2. Navigate to https://fast.com
3. Wait for test to complete
4. Record upload speed: _______ Mbps (should be 5+ Mbps for smooth experience)

**On Windows PC (to test download speed):**
1. Open browser on Windows PC (outside CRD)
2. Navigate to https://fast.com
3. Record download speed: _______ Mbps (should be 10+ Mbps)

**If speeds are insufficient:**
- Close bandwidth-heavy apps (streaming, downloads)
- Use Ethernet instead of WiFi if possible
- Test during off-peak hours
- Consider upgrading internet plan
