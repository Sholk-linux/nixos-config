import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import ".."

Scope {
    id: root

    property var queue: []
    property var active: null

    function show(entry) {
        queue.push(entry)
        if (!active) _next()
    }

    function _next() {
        if (queue.length === 0) {
            active = null
            popupWindow.visible = false
            return
        }
        active = queue.shift()
        popupWindow.entry = active
        popupWindow.visible = true
        dismissTimer.restart()
    }

    // ─── Открыть приложение по клику ─────────────────────────
    function openSource(entry) {
        if (!entry) return

        const cls = (entry.appName || "").toLowerCase().trim()
        if (cls.length === 0) return

        // 1. Пробуем сфокусировать существующее окно
        Hypr.focusWindowByClass(cls)

        // 2. Через 150мс проверяем — если фокус не сменился,
        //    значит окна нет, запускаем приложение
        Qt.callLater(() => {
            const focused = Hyprland.activeToplevel?.lastIpcObject?.class?.toLowerCase() ?? ""
            if (!focused.includes(cls)) {
                // Ищем .desktop-файл
                const de = DesktopEntries.heuristicLookup(cls)
                if (de) {
                    de.execute()
                } else {
                    // fallback — пробуем запустить по имени
                    Hypr.spawn(cls)
                }
            }
        })
    }

    PanelWindow {
        id: popupWindow
        visible: false
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "quickshell-notification"

        anchors.top: true
        anchors.left: true
        anchors.right: true
        margins.top: 70

        implicitHeight: card.implicitHeight + 8

        property var  entry: null
        readonly property bool isUrgent: (entry?.urgency ?? 0) === 2

        property real animY:       visible ? 0   : -20
        property real animOpacity: visible ? 1.0 : 0.0
        Behavior on animY       { NumberAnimation { duration: Theme.slow; easing.type: Theme.easeOut } }
        Behavior on animOpacity { NumberAnimation { duration: Theme.normal; easing.type: Theme.easeOut } }

        Rectangle {
            id: card
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            y: popupWindow.animY
            opacity: popupWindow.animOpacity
            width: 380
            implicitHeight: content.implicitHeight + 24

            color: Theme.bg
            radius: Theme.radius
            border.width: popupWindow.isUrgent ? 2 : 1
            border.color: popupWindow.isUrgent
                ? Theme.urgent
                : Theme.borderSoft

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                visible: popupWindow.isUrgent
                color: Qt.rgba(0.94, 0.64, 0.67, 0.10)
            }

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowBlur: 0.75
                shadowColor: Theme.shadow
                shadowVerticalOffset: 8
            }

            RowLayout {
                id: content
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Item {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32

                    readonly property string resolvedIcon: {
                        const e = popupWindow.entry
                        if (!e) return ""
                        if (e.appIcon && e.appIcon.length > 0) return e.appIcon
                        if (e.appName && e.appName.length > 0) {
                            const d = DesktopEntries.heuristicLookup(e.appName.toLowerCase())
                            if (d && d.icon) return d.icon
                        }
                        return ""
                    }

                    IconImage {
                        anchors.fill: parent
                        source: parent.resolvedIcon
                            ? Quickshell.iconPath(parent.resolvedIcon)
                            : ""
                        visible: status === Image.Ready
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        Layout.fillWidth: true
                        text: popupWindow.entry?.summary ?? ""
                        color: popupWindow.isUrgent ? Theme.urgent : Theme.text
                        font.family: Theme.mono
                        font.pixelSize: 13
                        font.bold: true
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }

                    Text {
                        Layout.fillWidth: true
                        visible: (popupWindow.entry?.body ?? "").length > 0
                        text: popupWindow.entry?.body ?? ""
                        color: Qt.rgba(0.8, 0.9, 1, 0.7)
                        font.family: Theme.mono
                        font.pixelSize: 11
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        maximumLineCount: 2
                    }
                }
            }

            // ─── Клик → открыть приложение-источник ──────────
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onClicked: {
                    dismissTimer.stop()
                    root.openSource(popupWindow.entry)
                    popupWindow.visible = false
                    root._next()
                }
            }

            // ─── Hover-подсветка карточки ────────────────────
            HoverHandler {
                onHoveredChanged: card.border.color = hovered
                    ? Theme.active
                    : (popupWindow.isUrgent ? Theme.urgent : Theme.borderSoft)
            }
        }

        Timer {
            id: dismissTimer
            interval: Theme.popup
            onTriggered: {
                popupWindow.visible = false
                root._next()
            }
        }
    }
}
