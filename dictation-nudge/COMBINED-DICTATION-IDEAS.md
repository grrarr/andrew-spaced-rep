# Combined dictation: SuperWhisper as live preview + Claude Ctrl+D as the real transcript

Status: TABLED 2026-11-17 by Andrew ("table this for another day"). Nothing here is built yet.

## The discovery (2026-11-17)

Andrew started a SuperWhisper recording and then pressed Ctrl+D in Claude Desktop. Both ran at once on the same mic:

- SuperWhisper showed the words live as he spoke (its one advantage).
- Claude's own dictation produced the text that actually reached Claude (better quality).

Problem: SuperWhisper **sometimes auto-pastes its own copy and sometimes does not**, so the result is intermittently duplicated text in the Claude input box. Goal: get "live words + Claude's transcript" with one keypress and never a duplicate.

## Facts gathered (2026-11-17, SuperWhisper 1.6.x on Windows)

- Hotkeys, from `%LOCALAPPDATA%\com.superwhisper.app\preferences.json`: `toggleRecordingShortcut` = Ctrl+Space, `pushToTalkShortcut` = Alt+Space, `cancelRecordingShortcut` = Escape, `modeSelectShortcut` = Alt+Shift+M, `activeMode` = default.
- Global paste switches in the same file: `autoPasteEnabled` = true, `enablePasteResult` = true, `clipboardBehaviour` = default, `restoreClipboardTimeDelay` = 1.
- Modes live in `%LOCALAPPDATA%\com.superwhisper.app\modes\*.json`. `default.json`: Nova-3 (`sw-deepgram-nova-3`), `realtimeOutput` = true (this is the live words), `autoPaste` = None (probably "inherit global"; unverified). `super.json` (named "Slack") has `realtimeOutput` = false.
- SuperWhisper runs ELEVATED (by design, see memory `project_superwhisper_must_run_elevated`). Its recording window is an always-on-top, mostly see-through window titled "Superwhisper"; at 150% scaling it spans 425,48-906,720 logical px, and the visible card is the top ~21% of it, centered.
- The dictation nudge (`dictation-nudge.ahk`) already sees Ctrl+Space / Alt+Space / Ctrl+D inside Claude, and logs them to `nudge_log.csv`.
- **Hazard:** Escape in Claude Desktop can interrupt a running Claude turn. Anything that sends Escape (SuperWhisper's cancel) while Claude is focused must first be proven not to reach Claude.

## Options

### A. A dedicated SuperWhisper "Preview" mode with auto-paste off (recommended)

One-time setup in SuperWhisper's UI: copy Default to a new mode "Preview", same voice model, live output on, auto-paste OFF. (Do it in the UI, not by hand-editing JSON, unless the per-mode `autoPaste` values are first confirmed; a SuperWhisper update can also rewrite these files.)

Then one AHK hotkey inside Claude (e.g. reuse Ctrl+D itself, or a new key):
1. Switch SuperWhisper to Preview (Alt+Shift+M opens the mode picker; needs testing: can it be driven by keys, is there a per-mode hotkey, or a CLI/URL scheme?).
2. Start SuperWhisper recording (Ctrl+Space) and Claude dictation (Ctrl+D).
3. On the second press: stop Claude dictation (Ctrl+D) and stop SuperWhisper (Ctrl+Space). Preview never pastes, so nothing to cancel.
4. Switch SuperWhisper back to Default, so outside Claude it pastes as usual.

Pros: no Escape, no duplicate cleanup, deterministic. Cons: mode switching may be fiddly or slow; if step 4 fails, SuperWhisper is left in a no-paste mode everywhere (needs a guard, e.g. always switch back on a timer or on Claude losing focus).

Variant A2: if SuperWhisper ever offers app-specific modes (auto-select a mode by active app), set Claude -> Preview and skip the AHK mode switching entirely. Check its settings and changelog for this.

### B. Start both, cancel SuperWhisper with Escape at the end

The hotkey starts both; the second press stops Ctrl+D, then sends Escape to cancel SuperWhisper before it pastes.

Must prove first: does SuperWhisper (elevated, global hotkey) swallow the Escape, or does Claude also receive it and stop the turn? Test with Claude idle first. Possible mitigations: send the Escape only while SuperWhisper's own window is the foreground window (UIPI: a non-elevated AHK may not be able to activate or send to an elevated window; run the cancel from a script that can), or rebind SuperWhisper's cancel to a key Claude ignores (e.g. Ctrl+Alt+F12) and send that instead. **Rebinding cancel removes the Escape hazard completely**, which makes B much more attractive.

Pros: no mode switching. Cons: timing (cancel must land before SuperWhisper finishes transcribing and pastes); relies on SuperWhisper's cancel being reliable.

### C. Start both, then delete SuperWhisper's duplicate if it pastes

Let SuperWhisper paste or not; afterwards detect a duplicate in the Claude input and remove it.

Weak: Claude's input box is in an Electron/web view, so reading its contents from AHK is unreliable (would need UI Automation); SuperWhisper's paste is intermittent and its timing varies; risk of deleting the wrong text. Only worth it if A and B both fail.

### D. Turn SuperWhisper's global auto-paste off entirely

Set `autoPasteEnabled` / `enablePasteResult` off (in the UI). SuperWhisper becomes preview-only everywhere; Claude's Ctrl+D does the work in Claude, and outside Claude he would paste SuperWhisper's result himself (it stays on the clipboard if `clipboardBehaviour` allows) or use other dictation.

Pros: trivial, no AHK. Cons: loses SuperWhisper's auto-paste in every other app.

### E. A separate live-preview tool instead of SuperWhisper

Use Windows Voice Typing (Win+H) or another engine purely as a preview window. Probably worse than A: Win+H types into the focused field (duplication again).

## Open questions to settle first, next time

1. What did Andrew's "degradation" mean when both ran? (Accuracy, lag, or just the duplicate?)
2. Does running both on one mic degrade either transcript? Compare a few side by side.
3. Can SuperWhisper's mode be switched by a direct hotkey or CLI rather than the Alt+Shift+M picker?
4. Can SuperWhisper's cancel be rebound away from Escape? (Unblocks B safely.)
5. Is per-mode `autoPaste: None` "inherit global" or "never"? (If "never", the Default mode may already not paste, and the intermittent paste comes from somewhere else.)

## Where it would be built

Inside `dictation-nudge.ahk` (AutoHotkey v2 since 2026-11-17), as a hotkey under the existing `#HotIf WinActive("ahk_exe claude.exe")` block, so it only acts in Claude.
