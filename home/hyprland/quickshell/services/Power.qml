pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // ─── Поддерживает ли система гибернацию ──────────────────
    property bool hibernateAvailable: false

    Process {
        id: hibernateCheck
        command: ["sh", "-c",
            "grep -q disk /sys/power/state 2>/dev/null && echo yes || echo no"]
        running: true
        stdout: StdioCollector {
            id: hibernateOut
            onStreamFinished: {
                root.hibernateAvailable = hibernateOut.text.trim() === "yes"
            }
        }
    }

    // ─── Действия ────────────────────────────────────────────
    function lock() {
        // Пробуем hyprlock, потом swaylock, потом loginctl
        Quickshell.execDetached(["sh", "-c",
            "hyprlock || swaylock || loginctl lock-session"])
    }

    function suspend() {
        Quickshell.execDetached(["systemctl", "suspend"])
    }

    function hibernate() {
        if (!root.hibernateAvailable) return
        Quickshell.execDetached(["systemctl", "hibernate"])
    }

    function logout() {
        Quickshell.execDetached(["hyprctl", "dispatch", "exit"])
    }

    function reboot() {
        Quickshell.execDetached(["systemctl", "reboot"])
    }

    function shutdown() {
        Quickshell.execDetached(["systemctl", "poweroff"])
    }
}
