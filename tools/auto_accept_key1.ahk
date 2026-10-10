#Requires AutoHotkey v2.0
; ==============================================================================
; Script: auto_accept_key1.ahk
; Purpose: Automatically send '1' when Antigravity is active
; Toggle key: F8
; ==============================================================================

TrayTip("Antigravity Auto-Accept", "Press F8 to toggle auto-accept", 3)

F8:: {
    static toggle := false
    toggle := !toggle
    SoundBeep(toggle ? 1000 : 500, 100)
    SetTimer(AutoPress, toggle ? 800 : 0)
}

AutoPress() {
    if WinActive("ahk_exe Antigravity.exe") {
        Send("1")
    }
}
