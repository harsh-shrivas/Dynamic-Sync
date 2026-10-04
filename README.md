# Dynamic Sync

A zero-footprint, real-time folder synchronization and live mirroring engine for Windows.

Unlike heavy background sync utilities that constantly poll storage drives and waste CPU cycles, **Dynamic Sync** interfaces directly with Windows kernel filesystem notifications via native `robocopy` parameters. It stays completely idle at **0% CPU usage** until an actual change occurs on disk, then executes instantaneous incremental mirrors.

---

## Key Highlights

- **0% Idle CPU Overhead:** Uses OS-level change event listeners (`/MON:1` / `/MOT:1`) instead of aggressive timer-based looping.
- **Zero Dependencies:** Pure native Windows implementation — no Python, Node.js, PowerShell overhead, or third-party background daemons required.
- **Headless Background Execution:** Includes a standalone VBScript launcher to run silently in the background with zero terminal clutter.
- **Robust Differential Mirroring:** Protects network/cloud sync drives with FAT/NTFS timestamp tolerances (`/FFT`), excludes older destination files (`/XO`), and mirrors structure accurately (`/MIR`).
- **Flexible Pattern Matching:** Supports subfolder globbing and project-specific prefix filters.

---

## File Structure

    Dynamic-Sync/
    ├── dynamic_sync.bat    # Core real-time monitoring and sync engine
    ├── run_silent.vbs      # Headless launcher (runs engine without console window)
    └── README.md

---

## Quick Setup

### 1. Configure Target Paths
Open `dynamic_sync.bat` in any text editor and adjust the top configuration block:

    :: =========================================================
    :: CONFIGURATION - SET YOUR SOURCE, TARGET & FILTER HERE
    :: =========================================================
    set "SOURCE=%~dp0"
    set "TARGET=Path\To\Destination\Folder"
    set "FILTER=*"

- **`SOURCE`**: Defaults to the folder where the script lives (`%~dp0`), but can be set to any absolute path.
- **`TARGET`**: Set this to your destination drive, shared network volume, or local cloud sync directory (Google Drive, Dropbox, OneDrive, NAS).
- **`FILTER`**: Filter folders by prefix (e.g., `Project - *`) or keep `*` to mirror all subfolders.

### 2. Execution Modes

- **Interactive Mode (Diagnostic View):** Double-click `dynamic_sync.bat`. A terminal window will open, display the initial batch mirror, and show live sync logs as files change.
- **Silent Background Mode:** Double-click `run_silent.vbs`. The script runs completely headless in the background without opening a terminal window.

### 3. Stopping the Background Engine
To terminate a silently running sync engine, open **Task Manager** and end the `robocopy.exe` / `cmd.exe` background process, or run:

    taskkill /F /IM robocopy.exe

---

## How It Works (Robocopy Flag Breakdown)

| Flag | Purpose |
| :--- | :--- |
| `/MIR` | **Mirror:** Replicates directory tree; purges destination files that no longer exist in source. |
| `/XO` | **Exclude Older:** Skips files in the destination that are newer than the source to prevent regressions. |
| `/FFT` | **FAT File Times:** Assumes 2-second timestamp granularity to prevent false re-syncs across cloud drives. |
| `/MON:1` | **Monitor Changes:** Suspends execution until at least **1 file modification** is reported by the OS. |
| `/MOT:1` | **Monitor Time:** Enforces a minimum cooldown of **1 minute** before committing subsequent changes. |
| `/R:1 /W:1` | **Retry Policy:** Limits retries to 1 with a 1-second wait to prevent stalls on locked files. |
| `/NDL /NFL /NJH /NJS` | **Logging Hygiene:** Strips extra headers and file lists to optimize I/O performance. |

---

## License

MIT License. Free to use, adapt, and deploy across local workstations, render nodes, and automated pipeline environments.
