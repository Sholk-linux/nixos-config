import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import ".."

Item {
    id: root
    implicitHeight: Theme.rowHeight
    implicitWidth:  inner.visible ? Math.min(340, inner.implicitWidth) : 0

    readonly property var    toplevel: Hyprland.activeToplevel
    readonly property string title:    toplevel?.title ?? ""
    readonly property string appClass: {
        if (!toplevel) return ""
        const ipc = toplevel.lastIpcObject
        return (ipc?.class ?? ipc?.initialClass ?? "").toLowerCase()
    }

    readonly property var    desktopEntry: DesktopEntries.heuristicLookup(root.appClass)
    readonly property string iconName:     desktopEntry?.icon ?? ""

    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }

    Row {
        id: inner
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 8
        visible: root.title.length > 0
        scale: hover.hovered ? 1.02 : 1.0

        Behavior on scale { NumberAnimation { duration: Theme.normal; easing.type: Theme.easeOut } }

        // Плавная смена контента
        opacity: 1
        onVisibleChanged: fadeAnim.restart()

        SequentialAnimation {
            id: fadeAnim
            NumberAnimation { target: inner; property: "opacity"; from: 0; to: 1; duration: Theme.normal; easing.type: Theme.easeOut }
        }

        Item {
            anchors.verticalCenter: parent.verticalCenter
            width: 18; height: 18

            IconImage {
                anchors.fill: parent
                source: root.iconName ? Quickshell.iconPath(root.iconName) : ""
                visible: status === Image.Ready

                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: hover.hovered ? 0.75 : 1.0
                    colorizationColor: hover.hovered ? Theme.active : Theme.filled
                    Behavior on colorization      { NumberAnimation { duration: Theme.normal } }
                    Behavior on colorizationColor { ColorAnimation  { duration: Theme.normal } }
                }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.title
            color: hover.hovered ? Theme.active : Theme.text
            font.family: Theme.mono
            font.pixelSize: 12
            elide: Text.ElideRight
            width: Math.min(implicitWidth, 280)
            Behavior on color { ColorAnimation { duration: Theme.fast } }
        }
    }
}
