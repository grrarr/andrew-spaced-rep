; dictation-nudge.ahk  (AutoHotkey v1 - same AutoHotkey.exe as the 7300 remaps/widgets scripts)
; ============================================================================
; ORIENTATION (for the next LLM reader)
; Purpose: break Andrew's habit of reaching for SuperWhisper inside Claude Desktop.
;   When Claude Desktop (ahk_exe claude.exe) is the active window and he presses a
;   SuperWhisper hotkey, flash a large banner: "Ctrl+D = Claude dictation".
;   SuperWhisper hotkeys come from %LOCALAPPDATA%\com.superwhisper.app\preferences.json:
;     toggleRecordingShortcut = Control+Space   pushToTalkShortcut = Alt+Space
;   If he rebinds them there, update the two hotkeys below.
; Load-bearing invariants:
;   - Hotkeys use the ~ prefix: the key PASSES THROUGH, SuperWhisper still records.
;     This is a nudge, never a block (he sometimes wants SuperWhisper's live words).
;   - The banner is shown NoActivate + click-through: it must never steal focus,
;     or SuperWhisper would paste into the banner instead of Claude.
;   - Separate script on purpose: do NOT merge into AutoHotkey-7300-remaps.ahk
;     (kept lean) or -widgets.ahk. Launched non-elevated by a Startup shortcut
;     ("dictation-nudge.lnk"); never launch AHK from an elevated task (breaks hooks).
; Log: nudge_log.csv beside this file - one row per SuperWhisper press in Claude
;   (kind=superwhisper) and per Ctrl+D in Claude (kind=ctrl_d), so the habit shift
;   can be counted later. Timestamps are local (ET) wall time.
; Docs: README.md beside this file.
; ============================================================================
#NoEnv
#SingleInstance Force
#Persistent
#InstallKeybdHook
SetWorkingDir %A_ScriptDir%
Menu, Tray, Tip, Dictation nudge (Ctrl+D in Claude)

global LastNudge := 0
global LogFile := A_ScriptDir . "\nudge_log.csv"
if !FileExist(LogFile)
    FileAppend, timestamp`,kind`,key`n, %LogFile%

#IfWinActive ahk_exe claude.exe
~^Space::Nudge("ctrl+space")
~!Space::Nudge("alt+space")
~^d::LogRow("ctrl_d", "ctrl+d")
#IfWinActive

Nudge(key) {
    ; debounce: push-to-talk auto-repeats while held
    if (A_TickCount - LastNudge < 4000)
        return
    LastNudge := A_TickCount
    LogRow("superwhisper", key)
    ShowBanner()
}

LogRow(kind, key) {
    global LogFile
    FormatTime, ts, , yyyy-MM-dd HH:mm:ss
    FileAppend, %ts%`,%kind%`,%key%`n, %LogFile%
}

ShowBanner() {
    Gui, Nudge:Destroy
    Gui, Nudge:+AlwaysOnTop -Caption +ToolWindow +E0x20 +LastFound
    Gui, Nudge:Color, 1F3A5F
    Gui, Nudge:Margin, 24, 14
    Gui, Nudge:Font, s20 bold cFFFFFF, Segoe UI
    Gui, Nudge:Add, Text, , Ctrl+D = Claude dictation
    Gui, Nudge:Font, s11 norm cD0D8E0, Segoe UI
    Gui, Nudge:Add, Text, , Faster and better. SuperWhisper only when you need live words.
    WinSet, Transparent, 235
    Gui, Nudge:Show, NoActivate AutoSize xCenter y80
    SetTimer, HideBanner, -3500
}

HideBanner:
    Gui, Nudge:Destroy
return
