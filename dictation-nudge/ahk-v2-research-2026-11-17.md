# AutoHotkey v2 research (2026-11-17)

Three search-lane runs (Perplexity + ChatGPT) from the dictation-nudge v2 port. Outcome: v2 installed as a portable ZIP beside v1; only dictation-nudge.ahk uses it.


## 1. Installing v2 safely beside v1 (ZIP vs installer)

**Question:** On Windows with AutoHotkey v1.1 installed in C:\Program Files\AutoHotkey (v1 scripts launched by shortcuts pointing at C:\Program Files\AutoHotkey\AutoHotkey.exe), what is the safest way to add AutoHotkey v2 for one new script without breaking v1? Does the v2 installer move or replace the root AutoHotkey.exe, change .ahk file associations, or break existing shortcuts? Is using the official portable ahk-v2.zip in a separate folder a clean side-by-side option?

---

Run: `20261117-072610-on-windows-with-autohotkey-v1-1` - lanes: pplx-api, codex

---

# pplx-api

**Safest for one new script:** leave the v1 installation and its shortcuts alone, extract the official v2 ZIP into a separate folder, and launch the new script explicitly with the v2 executable from that folder. Add `#Requires AutoHotkey v2.0` at the top of the script. AutoHotkey’s docs describe ZIP installation and the `#Requires` directive; they also say that the v2 launcher uses the directive to select a compatible interpreter. https://www.autohotkey.com/docs/v2/howto/Install.htm · https://www.autohotkey.com/docs/v2/lib/_Requires.htm

For example, set the new script’s shortcut target to the extracted v2 executable, with the script path as its argument. That avoids depending on the `.ahk` double-click association. **I could not verify the exact executable filename inside the current ZIP from the official pages retrieved**, so use the executable actually present in the archive rather than assuming a name.

- **Will the v2 installer replace or move the root `AutoHotkey.exe`?** The official docs say the installer supports coexistence and installs versions in separate subdirectories. But that does not guarantee that every existing file or shortcut remains untouched in every starting setup. A v2 forum answer says the installer tries to keep the latest v1 in the installation root and latest v2 under `v2`, moving files that would otherwise be overwritten; that is forum guidance, not a blanket guarantee for your particular installation. https://www.autohotkey.com/docs/v2/Program.htm · https://www.autohotkey.com/boards/viewtopic.php?style=19&t=120896

- **Will it change `.ahk` associations?** Installing v2 can register its launcher for `.ahk` files. The launcher is designed to choose v1 or v2, and `#Requires AutoHotkey v2.0` makes the intended version explicit. So an association change is possible; do not assume that double-clicking will continue to invoke the exact v1 executable it does today. https://www.autohotkey.com/docs/v2/Program.htm · https://www.autohotkey.com/docs/v2/lib/_Requires.htm

- **Will existing shortcuts break?** A shortcut that explicitly targets `C:\Program Files\AutoHotkey\AutoHotkey.exe` depends on that path continuing to exist and refer to the same executable. The official docs retrieved do not promise that a pre-existing v1 shortcut will be preserved unchanged, so back up or verify the file and shortcuts before installing. If you want to minimize risk, use the extracted ZIP and a separate v2-targeted shortcut.

**Bottom line:** yes, a separate-folder ZIP is the cleanest low-impact side-by-side option for this one script, provided you explicitly launch it with the extracted v2 binary. The official project publishes a ZIP download, and its install documentation says AutoHotkey can be installed from ZIP. https://www.autohotkey.com/download/ · https://www.autohotkey.com/docs/v2/howto/Install.htm

---
Sources (5):
- [20] https://www.autohotkey.com/docs/v2/howto/Install.htm - How to Install AutoHotkey
- [17] https://www.autohotkey.com/docs/v2/lib/_Requires.htm - #Requires (2024-01-01)
- [19] https://www.autohotkey.com/docs/v2/Program.htm - Using the Program
- [5] https://www.autohotkey.com/boards/viewtopic.php?style=19&t=120896 - Why did v2 exe stop searching the documents folder for a script to run? (2023-08-30)
- https://www.autohotkey.com/download/
Search queries (9): AutoHotkey v2 installer AutoHotkey.exe file association v1 v2 installation behavior ; AutoHotkey official download ahk-v2.zip portable install side by side ; AutoHotkey v2 installer change file associations existing v1 shortcuts ; site:autohotkey.com/docs/v2/Program.htm AutoHotkey v2 root AutoHotkey.exe v1 launcher files zip ; site:autohotkey.com/download AutoHotkey v2 zip download portable archive ; site:autohotkey.com/docs/v2/Program.htm AutoHotkey v2 installer v1 root directory overwritten files ; AutoHotkey v2 official zip AutoHotkey64.exe AutoHotkey32.exe download ZIP ; AutoHotkey v2 #Requires AutoHotkey v2 official documentation ; AutoHotkey v1 shortcut AutoHotkey.exe root v2 installation preserve root executable
lane: pplx-api (PAID, low / openai/gpt-6-luna) | status: ok | searches: 3 | elapsed: 13.5s | cost: $0.0052 (month so far $12.17 of $200.00) | 2026-11-17 07:26 ET

---

# codex

**Safest for one new v2 script:** use the official ZIP, extract it to a separate folder, and point that script’s shortcut directly at the v2 executable inside the extracted folder, with the script path as its argument. That keeps the new script’s runtime choice explicit and avoids relying on the shared `.ahk` file association. The official release page lists both the setup installer and ZIP; the current release shown there is v2.0.31, released October 25, 2026: https://github.com/AutoHotkey/AutoHotkey/releases

Yes, the ZIP is a clean side-by-side option for this use: it can run the v2 script without installing v2 or changing registry associations, provided you launch the ZIP’s executable directly. Its release page identifies the ZIP as an asset, but I could not verify from an official source that the ZIP itself is formally documented as “portable” in the broader sense.

If you prefer the installer, the v2 documentation says that installing v2 after v1 leaves v1’s files in the installation directory’s root specifically to avoid breaking tools and shortcuts that depend on those paths. So, for the stated install order, the installer is not intended to move or replace the root v1 `AutoHotkey.exe`; existing shortcuts targeting it should continue to point to v1. The installer does register the v2 launcher and `.ahk` file handling, however, so the default action for double-clicking `.ahk` files can change. See the installation documentation: https://doggy8088.github.io/AutoHotkeyDocs/docs/Program.htm

In short: **use the ZIP and a shortcut targeting its v2 executable** to minimize changes. If you install v2, v1 shortcuts should remain intact, but don’t assume `.ahk` double-click behavior will stay the same.

---
Sources cited (2):
- https://github.com/AutoHotkey/AutoHotkey/releases - Releases · AutoHotkey/AutoHotkey · GitHub
- https://doggy8088.github.io/AutoHotkeyDocs/docs/Program.htm - Using the Program | AutoHotkey v2
Search queries (2): AutoHotkey v2 installer coexist v1 AutoHotkey.exe replace file association ... ; site:autohotkey.com/docs/v2/Program.htm "Installing AutoHotkey v1 and v2 Together" ...
lane: codex (default) | status: ok | searches: 3 | elapsed: 24.0s | tokens in/out: 106235/679 | thread: 01a1e978-d225-7f72-a7c0-4d4ea432c0f7 | 2026-11-17 07:26 ET


## 2. Running v1 and v2 scripts at the same time

**Question:** Is it problematic to run AutoHotkey v1.1 scripts and AutoHotkey v2 scripts at the same time on one Windows PC (separate processes, each with its own keyboard hook)? What problems do people actually report on the AutoHotkey forums, Reddit or GitHub: hotkey conflicts, keyboard hook ordering, SendInput falling back to SendEvent when another script has a hook, stuck modifier keys, performance? Is it any different from running several v1 scripts at once?

---

Run: `20261117-072634-is-it-problematic-to-run-autohotkey` - lanes: pplx-api, codex

---

# pplx-api

**Short answer:** It is generally fine to run an AutoHotkey v1.1 process and a v2 process at the same time. The version difference is not itself the problem; the practical issues are shared hotkeys, interaction between keyboard hooks, and whether `SendInput` can use its normal fast path. The same considerations apply when running several v1 scripts. https://www.autohotkey.com/boards/viewtopic.php?t=134116 https://www.autohotkey.com/board/topic/57040-multiple-autohotkey-script-running-at-the-same-time/

- **Hotkey conflicts:** Two scripts can define the same hotkey. The result can depend on how the hotkey is implemented and which script or hook takes precedence; don’t assume both actions will run. AutoHotkey’s `Hotkey` documentation describes when a script can override a hotkey in another script, and notes that precedence depends on factors including hook use and startup order. https://www.autohotkey.com/docs/v2/lib/Hotkey.htm The multi-script forum discussion identifies duplicate hotkeys as a potential issue, not a general bar to running separate scripts. https://www.autohotkey.com/board/topic/57040-multiple-autohotkey-script-running-at-the-same-time/

- **Hook ordering:** Low-level hooks can affect one another’s behavior. AutoHotkey documents that reinstalling its keyboard hook can give it precedence over hooks installed earlier. https://www.autohotkey.com/docs/v2/lib/InstallKeybdHook.htm The v2 changelog also records a fix for a modifier-state race involving another keyboard hook installed more recently than the script’s own hook. That is evidence that ordering-related glitches can occur, but not that ordinary simultaneous v1/v2 use routinely causes them. https://www.autohotkey.com/docs/v2/ChangeLog.htm

- **`SendInput` fallback:** This is a real, documented consequence of another script’s keyboard hook. If a different script has a low-level keyboard hook installed, AutoHotkey’s `SendInput` reverts to `SendEvent` (or `SendPlay` for the relevant mode), because the external hook removes the advantages of `SendInput`. So a script may behave differently when another hook-using script is running; that is not specific to v1 versus v2. https://www.autohotkey.com/docs/v2/lib/Send.htm The v1 documentation describes the same behavior. https://www.autohotkey.com/docs/v1/lib/Send.htm

- **Stuck modifiers:** There is a documented ordering-sensitive modifier-state bug in the v2 changelog, as noted above. AutoHotkey’s `Send` documentation also explains a separate way modifiers can appear stuck: the modifier-restoration timeout can be unsuitable for how long the user holds the hotkey. https://www.autohotkey.com/docs/v2/ChangeLog.htm https://www.autohotkey.com/docs/v2/lib/A_HotkeyModifierTimeout.htm I found documented edge cases, not evidence that running v1 and v2 together commonly causes stuck modifiers.

- **Performance:** `SendInput` is generally faster and more reliable than `SendEvent`; when an external hook forces fallback, the sending method changes. https://www.autohotkey.com/docs/v2/lib/Send.htm The docs say hooks are not installed unconditionally partly because they consume memory, but I found no source establishing a meaningful general performance penalty from running one v1 and one v2 script concurrently. https://www.autohotkey.com/docs/v2/lib/InstallKeybdHook.htm

**Bottom line:** Treat this much like running multiple v1 scripts. Check for duplicate hotkeys and test any script whose timing or modifier behavior depends on `SendInput`; don’t expect separate processes to have isolated keyboard hooks. I found forum reports confirming users run v1 and v2 side by side, and documentation of specific hook-related behavior, but I could not verify a broad pattern of reports that mixed v1/v2 versions cause routine performance problems or stuck keys. https://www.autohotkey.com/boards/viewtopic.php?t=59171 https://www.autohotkey.com/docs/v2/lib/Send.htm https://www.autohotkey.com/docs/v2/ChangeLog.htm

---
Sources (9):
- [21] https://www.autohotkey.com/boards/viewtopic.php?t=134116 - Can you run v1 and v2 Scripts together in the same computer? Will they cause any conflict? Topic is solved (2024-12-08)
- [29] https://www.autohotkey.com/board/topic/57040-multiple-autohotkey-script-running-at-the-same-time/ - Multiple AutoHotKey Script running at the same time - Ask for Help
- [10] https://www.autohotkey.com/docs/v2/lib/Hotkey.htm - Hotkey
- [2] https://www.autohotkey.com/docs/v2/lib/InstallKeybdHook.htm - InstallKeybdHook
- [4] https://www.autohotkey.com/docs/v2/ChangeLog.htm - Changes & New Features
- [30] https://www.autohotkey.com/docs/v2/lib/Send.htm - Send / SendText / SendInput / SendPlay / SendEvent (2024-10-01)
- [17] https://www.autohotkey.com/docs/v1/lib/Send.htm - Send / SendRaw / SendInput / SendPlay / SendEvent
- [14] https://www.autohotkey.com/docs/v2/lib/A_HotkeyModifierTimeout.htm - A_HotkeyModifierTimeout
- [16] https://www.autohotkey.com/boards/viewtopic.php?t=59171 - Library Functions with "ahk2" Extension (2025-01-13)
Search queries (9): site:autohotkey.com/docs/v2 InstallKeybdHook SendInput hook other script ; site:autohotkey.com/boards v1 v2 running simultaneously keyboard hook SendInput ; AutoHotkey SendInput fallback another script keyboard hook Reddit stuck modifier ; AutoHotkey v1 and v2 run at same time forum scripts hooks ; site:reddit.com/r/AutoHotkey multiple scripts keyboard hook SendInput ; site:github.com/AutoHotkey SendInput external hook detected fallback ; site:autohotkey.com/docs/v2/lib/Send.htm external hook SendInput revert SendEvent ; site:autohotkey.com/docs/v2/lib/InstallKeybdHook.htm precedence hooks most recently installed ; AutoHotkey forum hook ordering stuck modifier other keyboard hook changelog
lane: pplx-api (PAID, low / openai/gpt-6-luna) | status: ok | searches: 3 | elapsed: 16.3s | cost: $0.0061 (month so far $12.17 of $200.00) | 2026-11-17 07:26 ET

---

# codex

**Yes, they can run at the same time, but two scripts with keyboard hooks can affect each other. The relevant factor is the hooks, not whether one script is v1 and the other v2.** Reports and documentation point to specific interactions—especially competing hotkeys and changes to `SendInput` behavior—rather than a general performance problem.

- **`SendInput` can switch modes.** AutoHotkey’s `SendInput` documentation says it falls back to `SendEvent` when it detects another script’s low-level keyboard hook. That can change timing and behavior; it’s especially noticeable with v2, whose default send mode is `Input`, compared with v1’s `Event` default. [AutoHotkey `SendInput` documentation](https://www.autohotkey.com/docs/v2/lib/Send.htm) · [v2 changes](https://www.autohotkey.com/docs/v2/v2-changes.htm)

- **Hook ordering can matter for hotkeys.** A recent Reddit discussion describes `#HotIf` hotkeys in separate scripts being evaluated according to hook order, and users report same-key bindings triggering in both scripts. Those are conflicts between scripts’ hotkey definitions and conditions, not a v1/v2 incompatibility. [Reddit: hotkey conflict between two scripts with different `#HotIf`s](https://old.reddit.com/r/AutoHotkey/comments/1nm9il2/) · [Reddit: duplicate hotkey triggers and script priority](https://old.reddit.com/r/AutoHotkey/comments/bxte43/)

- **Modifier and key-state glitches have been reported, but they’re specific cases.** The v1 changelog documents fixes for hotkeys misreading modifiers when another keyboard hook had been installed more recently, and for `SendInput` failing to release Ctrl in an Alt-related case. This supports the possibility of hook-order and modifier-state edge cases; it doesn’t establish that running two scripts routinely causes stuck modifiers. [AutoHotkey v1 changelog](https://github.com/AutoHotkey/AutoHotkeyDocs/blob/v1/docs/AHKL_ChangeLog.htm)

- **Performance is not a commonly demonstrated problem in the reports I found.** The documented consequence is primarily a send-mode change, not a broad slowdown. Multiple hooks may matter for input behavior, but the sources I found don’t provide evidence of a general performance penalty from running one v1 and one v2 script.

**Compared with several v1 scripts:** the same hook interactions can occur whenever scripts install low-level keyboard hooks. The v1/v2 mix adds a practical wrinkle because their default send modes differ, so a v2 script may behave differently when another hooked script is running. If both versions work alone but a remap or `InputHook` changes when both are running, check the actual send mode and overlapping hotkeys first. [AutoHotkey `SendInput` documentation](https://www.autohotkey.com/docs/v2/lib/Send.htm) · [Reddit: `InputHook` behavior changes with another hooked script](https://old.reddit.com/r/AutoHotkey/comments/1ccji6m/)

---
Sources cited (6):
- https://www.autohotkey.com/docs/v2/lib/Send.htm  [not among search results]
- https://www.autohotkey.com/docs/v2/v2-changes.htm  [not among search results]
- https://old.reddit.com/r/AutoHotkey/comments/1nm9il2/ - Hotkey conflict between 2 different scripts with different HotIfs
- https://old.reddit.com/r/AutoHotkey/comments/bxte43/ - How to set the priority of scripts?
- https://github.com/AutoHotkey/AutoHotkeyDocs/blob/v1/docs/AHKL_ChangeLog.htm - AutoHotkeyDocs/docs/AHKL_ChangeLog.htm at v1 · AutoHotkey/AutoHotkeyDocs · GitHub
- https://old.reddit.com/r/AutoHotkey/comments/1ccji6m/ - Inputhook not working correcly with v2.0.13
Search queries (3): site:autohotkey.com/boards v1 v2 scripts at same time keyboard hook SendInput ... ; site:autohotkey.com/boards "another keyboard hook" SendInput ordering modifiers ... ; site:autohotkey.com/boards/topic multiple AutoHotkey scripts same hotkey both run conflict ...
lane: codex (default) | status: ok | searches: 3 | elapsed: 26.1s | tokens in/out: 101169/964 | thread: 01a1e979-3199-73a1-a449-17a97f51f286 | 2026-11-17 07:26 ET


## 3. What a non-power user gives up moving to v2

**Question:** For an ordinary (non-power) AutoHotkey user whose scripts are mostly key remaps, hotstrings, small popups/tooltips, timers and a few GUI windows, what do they actually give up or get hit by when moving from AutoHotkey v1.1 to v2? Only practical things people really report: stability, speed, features deliberately removed in v2, missing community libraries/scripts that are v1-only, things that got harder. Not a full syntax-change list.

---

Run: `20261117-073255-for-an-ordinary-non-power-autohotkey` - lanes: pplx-api, codex

---

# pplx-api

For that kind of user, the main cost is **compatibility and conversion work**, not a reported everyday slowdown or instability.

- **Your existing v1 scripts do not become v2 scripts just because v2 is installed.** They need conversion, and you generally run each script under its matching version. The v2 installer’s launcher can help select the interpreter; both versions can coexist. https://www.autohotkey.com/v2/ (official overview); https://www.autohotkey.com/boards/viewtopic.php?f=24&t=112989 (official v2 release announcement, 2024-10-22)

- **The community back-catalog is the practical loss.** Forum posts, snippets, libraries and tools are much more numerous for v1, and v1 libraries cannot simply be included in a v2 script. Forum users report some libraries may never be ported; if a small script depends on one, that can turn a quick copy-and-adapt into finding a replacement or doing the port yourself. The forum’s category counts illustrate the imbalance, though they are not a census of usable code. https://www.autohotkey.com/boards/index.php (forum counts, accessed 2026-11-17); https://www.autohotkey.com/boards/viewtopic.php?t=106207&start=40 (community discussion, updated 2025-11-03); https://www.autohotkey.com/boards/viewtopic.php?t=64188 (migration discussion, updated 2024-12-03)

- **The differences most likely to matter for your listed uses are GUIs and older control flow.** v2 replaces GUI event labels with explicit event registration, and replaces the old menu/GUI command interfaces with objects and methods. `Gosub` and labels used as `SetTimer`/`Hotkey` callbacks are removed. A small popup or timer may be straightforward to rewrite, but a GUI built around g-labels takes more deliberate work. https://www.autohotkey.com/docs/v2/v2-changes.htm (official changes documentation, updated 2026-01-15); https://www.autohotkey.com/boards/viewtopic.php?t=64188

- **Some v1 conveniences and commands are gone rather than merely renamed.** The official changes list includes `SplashTextOn/Off`, `SplashImage`, and `Progress` (use a GUI instead), as well as `Input` (use `InputHook`) and several legacy directives and commands. For someone using tooltips or small popups, the splash/progress removals may be noticeable; they do not mean ordinary tooltips are unavailable. https://www.autohotkey.com/docs/v2/v2-changes.htm

- **Stability: I could not verify a general user-reported stability penalty for released v2.** A forum discussion describes v2 as relatively stable, while also noting that library availability can block a switch. Individual bugs are reported, as with software generally, but the sources found do not establish that ordinary remap/hotstring/timer scripts are broadly less stable in v2. https://www.autohotkey.com/boards/viewtopic.php?t=106207&start=40

- **Speed: I could not verify a meaningful speed advantage or disadvantage for this workload.** The official documentation describes particular optimizations, including `#HotIf` handling, but that is not evidence that simple remaps, hotstrings, tooltips or timers feel faster overall. Community benchmark posts use particular tests and reach different results; they do not establish a general comparison for ordinary scripts. https://raw.githubusercontent.com/AutoHotkey/AutoHotkeyDocs/v2/docs/v2-changes.htm (updated 2026-10-18); https://www.autohotkey.com/boards/viewtopic.php?t=95000; https://www.autohotkey.com/boards/viewtopic.php?t=126092

**Bottom line:** If the scripts are self-contained and simple, the practical hit is a one-time conversion and learning the v2 GUI/event model—not an established loss of reliability or responsiveness. If you frequently borrow v1 snippets or rely on a v1-only library or GUI tool, keeping v1 available is useful; v1 and v2 can coexist. https://www.autohotkey.com/boards/viewtopic.php?f=24&t=112989

---
Sources (9):
- [11] https://www.autohotkey.com/v2/ - AutoHotkey v2
- [19] https://www.autohotkey.com/boards/viewtopic.php?f=24&t=112989 - AutoHotkey v2 Official Release Announcement
- [16] https://www.autohotkey.com/boards/index.php - AutoHotkey Community
- https://www.autohotkey.com/boards/viewtopic.php?t=106207&start=40
- [10] https://www.autohotkey.com/boards/viewtopic.php?t=64188 - Is it a good idea to upgrade to AutoHotkey v2 now? Topic is solved (2025-01-14)
- [1] https://www.autohotkey.com/docs/v2/v2-changes.htm - Changes from v1.1 to v2.0
- [2] https://raw.githubusercontent.com/AutoHotkey/AutoHotkeyDocs/v2/docs/v2-changes.htm - Changes from v1.1 to v2.0 | AutoHotkey v2
- [29] https://www.autohotkey.com/boards/viewtopic.php?t=95000 - Does AutoHotkey v2 perform better than v1? Topic is solved (2025-01-12)
- [22] https://www.autohotkey.com/boards/viewtopic.php?t=126092 - Combining lines for Expressions isn't faster in v2; with caveats.
Search queries (6): AutoHotkey v2 migration practical drawbacks removed features community libraries v1 only ; AutoHotkey v2 performance stability compared v1.1 user reports ; AutoHotkey v2 removed features GUI menu commands migration ; site:autohotkey.com/boards v2 stability speed v1 migration library compatibility ; AutoHotkey v2 library compatibility v1 scripts community libraries forum 2024 ; AutoHotkey v2 faster performance benchmark compared v1 official
lane: pplx-api (PAID, low / openai/gpt-6-luna) | status: ok | searches: 2 | elapsed: 13.0s | cost: $0.0041 (month so far $12.18 of $200.00) | 2026-11-17 07:32 ET

---

# codex

For the scripts you describe, the practical answer is: **the hotkey, hotstring, tooltip and timer basics still exist in v2.** What you give up most is easy compatibility with old scripts and the surrounding v1 ecosystem. [AutoHotkey v2 README](https://github.com/AutoHotkey/AutoHotkey-v2/blob/main/README.md) (updated for v2.0.28 on September 12, 2026)

- **Your existing v1 scripts won’t run unchanged.** v2 is a different language version, and its launcher can run v1 scripts only when the v1 runtime is also installed. Small remap scripts may be straightforward to convert; the time adds up across multiple scripts or when they use GUI code and libraries. [AutoHotkey v2 README](https://github.com/AutoHotkey/AutoHotkey-v2/blob/main/README.md), [v1-to-v2 changes](https://doggy8088.github.io/AutoHotkeyDocs/docs/v2-changes.htm)

- **Old examples and libraries can be the bigger day-to-day loss.** A v1 library generally cannot be dropped into a v2 script as-is; you need a v2 version, a port, or a replacement. The official changes document also says the old function-library auto-include mechanism was removed. Community advice still points to v1’s larger stock of scripts, tutorials and answers as a migration drawback. [v1-to-v2 changes](https://doggy8088.github.io/AutoHotkeyDocs/docs/v2-changes.htm), [AutoHotkey version guide](https://autohotkey.wiki/versions), [community discussion](https://old.reddit.com/r/AutoHotkey/comments/10a80hy/)

- **GUIs take adjustment.** A small popup is still possible, but v2 replaces v1’s command-and-label GUI model with GUI and control objects, and event handlers must be registered. That can make translating an old GUI example less direct. Once learned, some users find the new model easier to manage, especially for more involved GUIs. [v1-to-v2 GUI changes](https://doggy8088.github.io/AutoHotkeyDocs/docs/v2-changes.htm), [AutoHotkey version guide](https://autohotkey.wiki/versions)

- **A few deliberate removals matter for particular scripts.** `SetBatchLines` is gone: v2 always runs at maximum speed, so you can’t use that v1 setting to make a tight loop yield periodically; add an explicit wait where needed. `Progress` was removed in favor of a GUI. Other removed commands mainly affect scripts using those specific features, rather than ordinary remaps and hotstrings. [v1-to-v2 changes](https://doggy8088.github.io/AutoHotkeyDocs/docs/v2-changes.htm)

- **Don’t expect a noticeable speed or stability upgrade for simple everyday scripts.** The sources I found don’t establish a general speed win for remaps, hotstrings, tooltips or timers. v2 has stricter and more consistent error handling, and its release guide describes compatibility expectations for v2 releases, but that doesn’t mean every script becomes more reliable simply by converting it. [AutoHotkey version guide](https://autohotkey.wiki/versions), [v1-to-v2 changes](https://doggy8088.github.io/AutoHotkeyDocs/docs/v2-changes.htm)

**In practice:** if your scripts are small and self-contained, the main cost is conversion and relearning. If they depend on older community code or GUI examples, check those dependencies first; that is where migration is most likely to become work. v1 and v2 can be installed side by side. [AutoHotkey version guide](https://autohotkey.wiki/versions)

---
Sources cited (4):
- https://github.com/AutoHotkey/AutoHotkey-v2/blob/main/README.md  [not among search results]
- https://doggy8088.github.io/AutoHotkeyDocs/docs/v2-changes.htm - Changes from v1.1 to v2.0 | AutoHotkey v2
- https://autohotkey.wiki/versions - Should I choose v1 or v2? [AutoHotkey Wiki]
- https://old.reddit.com/r/AutoHotkey/comments/10a80hy/ - AHK V1.1 or V2: a noob looking for advice
Search queries (3): AutoHotkey v2 what changed removed features v1 compatibility official docs ... ; site:autohotkey.com/docs/v2 AutoHotkey v2 removed SetBatchLines deprecated performance ... ; site:autohotkey.com/docs/v2/ "SetBatchLines" removed v2 ...
lane: codex (default) | status: ok | searches: 3 | elapsed: 32.2s | tokens in/out: 105451/1107 | thread: 01a1e97f-0004-71a2-a80b-fe3d644e5543 | 2026-11-17 07:32 ET

