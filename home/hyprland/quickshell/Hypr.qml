pragma Singleton
import QtQuick
import Quickshell

QtObject {
    function focusWorkspace(id) {
        const cmd = 'hl.dsp.focus({ workspace = "' + id + '" })'
        Quickshell.execDetached(["hyprctl", "dispatch", cmd])
    }

    function moveWindowToWorkspace(id) {
        const cmd = 'hl.dsp.window.move({ workspace = "' + id + '" })'
        Quickshell.execDetached(["hyprctl", "dispatch", cmd])
    }

    // ─── Фокус на окно по классу ─────────────────────────────
    // Использует старый синтаксис dispatch (без Lua), т.к. focuswindow
    // принимает обычный аргумент "class:firefox"
    function focusWindowByClass(cls) {
    	const cmd = 'hl.dsp.focus({ window = "class:' + cls + '" })'
    	Quickshell.execDetached(["hyprctl", "dispatch", cmd])
	}

    function switchLayout() {
        Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", "next"])
    }

    function spawn(cmd) {
        Quickshell.execDetached(["sh", "-c", cmd])
    }
}
