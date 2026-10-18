import Quickshell.Hyprland
import QtQuick
import Quickshell
import "widgets"

ShellRoot {
    id: shell

    // ─── Панель ──────────────────────────────────────────────
    Bar {}

    // ─── Всплывающие уведомления ─────────────────────────────
    NotificationPopup {
        id: popupManager
    }

    // ─── Связка: синглтон → popup ────────────────────────────
    Connections {
        target: Notifications
        function onPopupRequested(entry) {
            popupManager.show(entry)
        }
	}
	Connections {
        target: Hyprland
        function onActiveToplevelChanged() {
            if (centerPopup.visible) centerPopup.visible = false
        }
    }
}
