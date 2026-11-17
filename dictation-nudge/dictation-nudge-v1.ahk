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
global BannerHwnd := 0
global LogFile := A_ScriptDir . "\nudge_log.csv"
if !FileExist(LogFile)
    FileAppend, timestamp`,kind`,key`n, %LogFile%

; Self-test: `AutoHotkey.exe dictation-nudge.ahk --test` shows the banner once and exits
; (SingleInstance Force means it replaces the running copy - relaunch normally after).
if (A_Args[1] = "--test") {
    ShowBanner()
    Sleep, 4000
    ExitApp
}

#IfWinActive ahk_exe claude.exe
~^Space::Nudge("ctrl+space")
~!Space::Nudge("alt+space")
~^d::LogRow("ctrl_d", "ctrl+d")
#IfWinActive

Nudge(key) {
    ; Log EVERY press before the debounce, so the log is a complete count of what the
    ; hook saw (debounced presses are marked, not dropped). A press the hook never saw
    ; still leaves no row - cross-check against SuperWhisper's recordings folder.
    ; debounce: push-to-talk auto-repeats while held
    if (A_TickCount - LastNudge < 4000) {
        LogRow("superwhisper_nobanner", key)
        return
    }
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
    ; Bottom-center of the work area, NOT the top: SuperWhisper's always-on-top
    ; recording window (elevated) sits at top-center and covered the banner there
    ; (2026-11-17). Show hidden first to measure, then place.
    DetectHiddenWindows, On   ; else WinGetPos sees nothing on the hidden window -> blank x/y
    Gui, Nudge:Show, NoActivate AutoSize Hide
    Gui, Nudge:+LastFound
    BannerHwnd := WinExist()
    WinGetPos, , , bw, bh, ahk_id %BannerHwnd%
    ; Anchor just UNDER SuperWhisper's recording card, where his eyes already go.
    ; The card is the top ~21% of SuperWhisper's mostly see-through window
    ; (measured 2026-11-17 at 150% scaling: window 425,48-906,720 logical; card
    ; bottom ~ y187). Fallback if that window is not found: bottom-center.
    WinGetPos, sx, sy, sw, sh, Superwhisper ahk_exe Superwhisper.exe
    if (sw > 100 && sh > 100) {
        bx := sx + (sw - bw) // 2
        by := sy + Round(sh * 0.21) + 10
    } else {
        SysGet, wa, MonitorWorkArea
        bx := waLeft + (waRight - waLeft - bw) // 2
        by := waBottom - bh - 140
    }
    Gui, Nudge:Show, NoActivate x%bx% y%by%
    SetTimer, KeepOnTop, 200
    SetTimer, HideBanner, -3500
}

; Re-assert topmost while visible, in case SuperWhisper's window is raised after ours.
KeepOnTop:
    if WinExist("ahk_id " . BannerHwnd)
        DllCall("SetWindowPos", "Ptr", BannerHwnd, "Ptr", -1, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", 0x13)
return

HideBanner:
    SetTimer, KeepOnTop, Off
    Gui, Nudge:Destroy
return
