# Dictation nudge - "use Ctrl+D in Claude, not SuperWhisper"

Andrew wants to switch from SuperWhisper to Claude Desktop's built-in dictation (Ctrl+D), which works better. SuperWhisper's only advantage is that it shows the words as you speak. His habit of reaching for the SuperWhisper hotkey is hardwired, so the reminder fires at the moment the habit fires, not on a calendar.

## What it does

`dictation-nudge.ahk` (AutoHotkey **v2**, run by the portable exe `C:\Program Files\AutoHotkey-v2\AutoHotkey64.exe`) watches for the SuperWhisper hotkeys **only while Claude Desktop is the active window**:

- Ctrl+Space (SuperWhisper toggle) and Alt+Space (push-to-talk) -> shows a large banner, "Ctrl+D = Claude dictation", for about 3.5 s. The key still passes through, so SuperWhisper still records. It is a nudge, not a block.
- Ctrl+D in Claude -> logged only, no banner.

The banner sits just under SuperWhisper's recording card, placed from SuperWhisper's window position each time it shows. If that window can't be found, it goes to the bottom center. It is pushed back on top every 200 ms while it shows, because SuperWhisper's always-on-top window would otherwise cover it.

Every press the script catches goes into `nudge_log.csv` (timestamp, kind, key). `superwhisper_nobanner` means a press within 4 s of the last banner, which was logged but got no banner. A press the script never caught leaves no row, so to check for misses, compare the log with the folder times in `%LOCALAPPDATA%\com.superwhisper.app\recordings\`. Test the banner without pressing anything: `"C:\Program Files\AutoHotkey-v2\AutoHotkey64.exe" dictation-nudge.ahk --test` (it replaces the running copy, then relaunches a normal one itself before exiting). If the banner ever stops entirely, first check that an `AutoHotkey64.exe` process running `dictation-nudge.ahk` exists; if not, open the Startup shortcut `dictation-nudge.lnk`.

The script never shows an AutoHotkey error box: any runtime error goes to `nudge_errors.log` (message, line, stack) and that press is skipped. Two known traps, both handled in the script: Dropbox briefly locks `nudge_log.csv` while syncing (log writes retry, then drop the row), and SuperWhisper (elevated) swallows Ctrl+Space when it starts AFTER this script, so the script reinstalls its keyboard hook whenever SuperWhisper's process ID changes (`hook_reinstalled` row). No Ctrl+Space rows while SuperWhisper is running = suspect hook order first. Turning SuperWhisper off/on: `_task-managment/ahk-watchdog/superwhisper_toggle.ps1`.

The log is there so the switch can be counted later ("how often did I use SuperWhisper vs Ctrl+D in Claude this week").

## Running

- Runs on AutoHotkey v2 from the official ZIP (no installer), extracted to `C:\Program Files\AutoHotkey-v2`. Your other AutoHotkey scripts stay on v1, and double-clicking an `.ahk` still opens v1. Running v1 and v2 side by side is fine: the only clashes people report come from two scripts using the same key, whatever their versions.
- Rollback to v1: point the Startup shortcut at `C:\Program Files\AutoHotkey\AutoHotkey.exe` with `dictation-nudge-v1.ahk` (same behavior, frozen at the 2026-11-17 port).
- Starts at login from the Startup shortcut `dictation-nudge.lnk` (`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`), non-elevated.
- Turn it off: right-click its green "H" tray icon -> Exit. To disable it for good, delete the Startup shortcut.
- If SuperWhisper's hotkeys change (`%LOCALAPPDATA%\com.superwhisper.app\preferences.json`, `toggleRecordingShortcut` / `pushToTalkShortcut`), update the two hotkey lines in the script.

## Ideas if the habit sticks around

- Read `nudge_log.csv` for the ratio over time.
- Combined dictation (SuperWhisper as live preview + Claude Ctrl+D), tabled 2026-11-17: `COMBINED-DICTATION-IDEAS.md`.
- Turn it into a block in Claude (remove the `~`, so the SuperWhisper hotkey does nothing in Claude) once the live-words feature no longer matters.
