# Dictation nudge - "use Ctrl+D in Claude, not SuperWhisper"

Andrew wants to switch from SuperWhisper to Claude Desktop's built-in dictation (Ctrl+D), which works better. SuperWhisper's only advantage is that it shows the words as you speak. His habit of reaching for the SuperWhisper hotkey is hardwired, so the reminder fires at the moment the habit fires, not on a calendar.

## What it does

`dictation-nudge.ahk` (AutoHotkey v1) watches for the SuperWhisper hotkeys **only while Claude Desktop is the active window**:

- Ctrl+Space (SuperWhisper toggle) and Alt+Space (push-to-talk) -> shows a large banner, "Ctrl+D = Claude dictation", near the top of the screen for about 3.5 s. The key still passes through, so SuperWhisper still records. It is a nudge, not a block.
- Ctrl+D in Claude -> logged only, no banner.

Every press goes into `nudge_log.csv` (timestamp, kind, key), so the switch can be counted later ("how often did I use SuperWhisper vs Ctrl+D in Claude this week").

## Running

- Starts at login from the Startup shortcut `dictation-nudge.lnk` (`%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup`), non-elevated.
- Turn it off: right-click its green "H" tray icon -> Exit. To disable it for good, delete the Startup shortcut.
- If SuperWhisper's hotkeys change (`%LOCALAPPDATA%\com.superwhisper.app\preferences.json`, `toggleRecordingShortcut` / `pushToTalkShortcut`), update the two hotkey lines in the script.

## Ideas if the habit sticks around

- Read `nudge_log.csv` for the ratio over time.
- Turn it into a block in Claude (remove the `~`, so the SuperWhisper hotkey does nothing in Claude) once the live-words feature no longer matters.
