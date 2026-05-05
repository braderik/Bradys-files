# AGENTS.md

## Overview

This repository ("Bradys-files") is a **documentation and shell-script toolkit** for setting up Chrome Remote Desktop on macOS to access ChatGPT and Claude web interfaces from a Windows PC.

**Contents:**
- `scripts/setup-mac-host.sh` — One-time macOS host configuration (power management, LaunchAgent)
- `scripts/launch-ai-desktop.sh` — Opens ChatGPT and Claude browser tabs on macOS
- `docs/` — Markdown documentation (SOP, test plan, security checklist, parity notes)
- `README-REMOTE-DESKTOP.md` — Quick-start guide

There is no application to build or run. There are no package managers, dependencies, or build systems.

## Cursor Cloud specific instructions

### Environment constraints

- Both shell scripts are macOS-only (`/Applications/...`, `pmset`, `launchctl`, `open -a`). They will exit with an error on Linux (the Cloud Agent environment) because macOS paths and commands do not exist. This is expected behavior, not a bug.
- There is no build step, no test suite, no dev server, and no package manager.

### Linting

- Use `shellcheck` to lint the bash scripts: `shellcheck scripts/setup-mac-host.sh scripts/launch-ai-desktop.sh`
- Use `bash -n <script>` for quick syntax validation.
- `shellcheck` is installed via `apt-get install shellcheck` (included in the update script).

### What "testing" means for this repo

Since there is no runnable application or test framework, validation consists of:
1. `bash -n` syntax checks on both scripts (must pass).
2. `shellcheck` linting (info-level findings are acceptable; errors/warnings are not).
3. Reviewing markdown for correctness (manual).

### Gotchas

- `setup-mac-host.sh` contains an interactive `read -p` prompt (line 54). In non-interactive contexts, pipe input or skip that code path.
- `setup-mac-host.sh` calls `sudo pmset` and `sudo launchctl`, which require root on macOS and will fail on Linux.
