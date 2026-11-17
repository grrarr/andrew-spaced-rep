#Requires AutoHotkey v2.0
; dictation-nudge.ahk  (AutoHotkey v2 - PORTABLE exe at C:\Program Files\AutoHotkey-v2\AutoHotkey64.exe)
; ============================================================================
; ORIENTATION (for the next LLM reader)
; Purpose: break Andrew's habit of reaching for SuperWhisper inside Claude Desktop.
;   When Claude Desktop (ahk_exe claude.exe) is the active window and he presses a
;   SuperWhisper hotkey, flash a banner "Ctrl+D = Claude dictation" just under
;   SuperWhisper's recording card.
;   SuperWhisper hotkeys come from %LOCALAPPDATA%\com.superwhisper.app\preferences.json:
;     toggleRecordingShortcut = Control+Space   pushToTalkShortcut = Alt+Space
;   If he rebinds them there, update the two hotkeys below.
; Runtime: this is the ONLY v2 script on the machine. The v2 runtime is the official
;   ZIP extracted to C:\Program Files\AutoHotkey-v2 (no installer, no .ahk association;
;   double-clicking an .ahk still opens v1). Run it with that exe explicitly - the v1
;   exe cannot parse this file. Rollback: dictation-nudge-v1.ahk (same behavior, v1),
;   point the Startup shortcut back at C:\Program Files\AutoHotkey\AutoHotkey.exe.
; Load-bearing invariants:
;   - Hotkeys use the ~ prefix: the key PASSES THROUGH, SuperWhisper still records.
;     This is a nudge, never a block (he sometimes wants SuperWhisper's live words).
;   - The banner is shown NoActivate + click-through (+E0x20): it must never steal
;     focus, or SuperWhisper would paste into the banner instead of Claude.
;   - SuperWhisper's recording window is ELEVATED + always-on-top and covers the
;     banner unless KeepOnTop re-asserts HWND_TOPMOST every 200 ms while it shows.
;   - Separate script on purpose: never merge into the v1 7300 remaps/widgets scripts.
;     Launched non-elevated by the Startup shortcut "dictation-nudge.lnk"; never from
;     an elevated task (breaks keyboard hooks).
; Errors: OnError writes every runtime error to nudge_errors.log and suppresses the
;   dialog (Andrew 2026-11-17: an error dialog kept popping on the first press).
; Log: nudge_log.csv beside this file, one row per press the hook SAW (superwhisper,
;   superwhisper_nobanner = debounced, ctrl_d). A press the hook never saw leaves no
;   row; cross-check against %LOCALAPPDATA%\com.superwhisper.app\recordings\ folder times.
; Self-test: AutoHotkey64.exe dictation-nudge.ahk --test  (shows the banner once and
;   exits; #SingleInstance Force replaces the running copy - relaunch normally after).
; Docs: README.md, COMBINED-DICTATION-IDEAS.md beside this file.
; ============================================================================
#SingleInstance Force
InstallKeybdHook
SetWorkingDir A_ScriptDir
A_IconTip := "Dictation nudge (Ctrl+D in Claude)"

global LastNudge := 0
global Banner := 0
global LogFile := A_ScriptDir "\nudge_log.csv"
if !FileExist(LogFile)
    FileAppend "timestamp,kind,key`n", LogFile

; Never show an AHK error dialog: a nudge that pops a modal on the first press is
; worse than no nudge. Any runtime error is written to nudge_errors.log beside this
; file (message, line, stack) and swallowed. Read that log to find the real cause.
OnError LogError
LogError(e, mode) {
    try FileAppend FormatTime(, "yyyy-MM-dd HH:mm:ss") " [" mode "] " Type(e) ": " e.Message
        . " | extra=" e.Extra " | line " e.Line " | " e.What "`n" e.Stack "`n---`n"
        , A_ScriptDir "\nudge_errors.log"
    return 1   ; 1 = handled: suppress the dialog, abort just this thread
}

; Hook-order trap (found 2026-11-17): low-level keyboard hooks run newest-first, and
; SuperWhisper (elevated) swallows Ctrl+Space. If SuperWhisper starts AFTER this script
; (watchdog relaunch after wake, a resume), its hook sits in front and our hotkeys never
; fire - no log row at all. So whenever SuperWhisper's PID changes, force-reinstall our
; hook to put it back in front.
global SwPid := ProcessExist("Superwhisper.exe")
SetTimer WatchSuperWhisper, 3000
WatchSuperWhisper() {
    global SwPid
    pid := ProcessExist("Superwhisper.exe")
    if (pid != SwPid) {
        SwPid := pid
        if pid {
            Sleep 3000   ; let SuperWhisper install its own hook first
            InstallKeybdHook true, true
            LogRow("hook_reinstalled", "pid " pid)
        }
    }
}

if (A_Args.Length && A_Args[1] = "--test") {
    ShowBanner()
    Sleep 4000
    ExitApp
}

#HotIf WinActive("ahk_exe claude.exe")
~^Space::Nudge("ctrl+space")
~!Space::Nudge("alt+space")
~^d::LogRow("ctrl_d", "ctrl+d")
#HotIf

Nudge(key) {
    global LastNudge
    ; Log every press before the debounce (push-to-talk auto-repeats while held).
    if (A_TickCount - LastNudge < 4000) {
        LogRow("superwhisper_nobanner", key)
        return
    }
    LastNudge := A_TickCount
    LogRow("superwhisper", key)
    ShowBanner()
}

LogRow(kind, key) {
    FileAppend FormatTime(, "yyyy-MM-dd HH:mm:ss") "," kind "," key "`n", LogFile
}

ShowBanner() {
    global Banner
    HideBanner()
    g := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    g.BackColor := "1F3A5F"
    g.MarginX := 24, g.MarginY := 14
    g.SetFont("s20 bold cFFFFFF", "Segoe UI")
    g.Add("Text", , "Ctrl+D = Claude dictation")
    g.SetFont("s11 norm cD0D8E0", "Segoe UI")
    g.Add("Text", , "Faster and better. SuperWhisper only when you need live words.")
    g.Show("NoActivate AutoSize Hide")
    WinSetTransparent 235, g.Hwnd
    DetectHiddenWindows True
    WinGetPos , , &bw, &bh, g.Hwnd
    ; Anchor just under SuperWhisper's card: the card is the top ~21% of its mostly
    ; see-through window (measured 2026-11-17, 150% scaling). Fallback: bottom-center.
    ; v2 trap: when WinGetPos throws (no SuperWhisper window), it leaves its output
    ; vars UNSET even if pre-assigned, so test them only inside the try.
    found := false
    try {
        WinGetPos &sx, &sy, &sw, &sh, "Superwhisper ahk_exe Superwhisper.exe"
        found := (sw > 100 && sh > 100)
    }
    if found {
        bx := sx + (sw - bw) // 2
        by := sy + Round(sh * 0.21) + 10
    } else {
        MonitorGetWorkArea( , &wl, &wt, &wr, &wb)
        bx := wl + (wr - wl - bw) // 2
        by := wb - bh - 140
    }
    g.Show("NoActivate x" bx " y" by)
    Banner := g
    SetTimer KeepOnTop, 200
    SetTimer HideBanner, -3500
}

KeepOnTop() {
    if Banner
        DllCall("SetWindowPos", "Ptr", Banner.Hwnd, "Ptr", -1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x13)
}

HideBanner() {
    global Banner
    SetTimer KeepOnTop, 0
    if Banner {
        Banner.Destroy()
        Banner := 0
    }
}
