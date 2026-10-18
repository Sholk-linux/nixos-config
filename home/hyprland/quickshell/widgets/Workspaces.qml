import QtQuick
import Quickshell.Hyprland
import ".."

Row {
    id: root
    spacing: 6

    readonly property int total: 9
    readonly property int focusedWs: Hyprland.focusedWorkspace?.id ?? -1
    readonly property var wsMap: {
        const m = new Map()
        for (const w of Hyprland.workspaces.values) m.set(w.id, w)
        return m
    }

    Repeater {
        model: root.total

        delegate: Item {
            id: cell
            required property int index

            readonly property int  wsId:     index + 1
            readonly property var  ws:       root.wsMap.get(wsId) ?? null
            readonly property bool isActive: root.focusedWs === wsId
            readonly property bool hasWin:   ws !== null && ws.toplevels.values.length > 0
            readonly property bool isUrgent: ws !== null && ws.urgent
            readonly property bool isLight:  isActive || isUrgent || hasWin

            width:  Theme.pillSize
            height: Theme.pillSize

            // ─── Ripple при клике ─────────────────────────────
            Rectangle {
                id: ripple
                anchors.centerIn: parent
                width:  Theme.pillSize
                height: Theme.pillSize
                radius: Theme.radiusSm
                color: Theme.active
                opacity: 0
                scale: 0.4

                ParallelAnimation {
                    id: rippleAnim
                    NumberAnimation { target: ripple; property: "scale";   from: 0.4; to: 2.2; duration: 380; easing.type: Easing.OutCubic }
                    NumberAnimation { target: ripple; property: "opacity"; from: 0.45; to: 0;  duration: 380; easing.type: Easing.OutCubic }
                }
            }

            // ─── Пилюля ───────────────────────────────────────
            Rectangle {
                id: pill
                anchors.fill: parent
                radius: Theme.radiusSm
                scale: ma.containsMouse ? 1.12 : 1.0

                color: cell.isUrgent ? Theme.urgent
                     : cell.isActive ? Theme.active
                     : cell.hasWin   ? Theme.filled
                     : Theme.empty

                border.width: cell.isActive ? 1.5 : 0
                border.color: Theme.text

                Behavior on color        { ColorAnimation  { duration: Theme.fast;   easing.type: Theme.easeOut } }
                Behavior on scale        { NumberAnimation { duration: Theme.normal; easing.type: Theme.easeBack } }
                Behavior on border.width { NumberAnimation { duration: Theme.fast } }

                // Точка-индикатор активного стола снизу
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -5
                    width:  cell.isActive ? 14 : 0
                    height: 2
                    radius: 1
                    color: Theme.active
                    Behavior on width { NumberAnimation { duration: Theme.normal; easing.type: Theme.easeOut } }
                }

                Text {
                    anchors.centerIn: parent
                    text: cell.wsId
                    color: cell.isLight ? Theme.textActive : Theme.text
                    font.family: Theme.mono
                    font.pixelSize: 13
                    font.bold: true
                    Behavior on color { ColorAnimation { duration: Theme.fast } }
                }
            }

            MouseArea {
                id: ma
                anchors.fill: parent
                z: 100
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: (e) => {
                    rippleAnim.restart()
                    pill.scale = 1.28
                    pill.scale = ma.containsMouse ? 1.12 : 1.0
                    if (e.button === Qt.LeftButton)
                        Hypr.focusWorkspace(cell.wsId)
                    else
                        Hypr.moveWindowToWorkspace(cell.wsId)
                }

                onWheel: (e) => {
                    const dir  = e.angleDelta.y > 0 ? -1 : 1
                    const next = ((cell.wsId - 1 + dir + root.total) % root.total) + 1
                    Hypr.focusWorkspace(next)
                }
            }
        }
    }
}
