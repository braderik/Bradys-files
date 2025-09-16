# Bradys-files

This repository contains scripts for remote execution. The included
`remote_script.py` starts a simple HTTP server that can be triggered from
an iPhone.

## Usage

1. On the machine you want to control, run:
   ```bash
   python3 remote_script.py
   ```
2. From your iPhone, open Safari and navigate to:
   ```
   http://<server-ip>:8000/run
   ```
   Replace `<server-ip>` with the public IP or hostname of your machine.
3. The page will display the message returned by the server, confirming
   the remote action ran successfully.

Feel free to customize `perform_action` in `remote_script.py` to execute
other commands.

## SSH Remote Runner

Use `run-remote.sh` to execute commands on a remote Mac over SSH. It relies on an SSH
config entry named `mac-home` and runs `bash -lc ~/scripts/backup.sh` by default.

Examples:

```bash
./run-remote.sh
REMOTE_CMD='bash -lc "uptime && ~/scripts/backup.sh"' ./run-remote.sh
```

A `.codex-workflow.json` is provided so you can trigger the same action via Codex by
running the "Remote Runner" workflow.
