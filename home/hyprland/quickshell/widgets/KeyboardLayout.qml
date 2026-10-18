import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import ".."

Item {
    id: root
    implicitWidth:  inner.implicitWidth
    implicitHeight: Theme.rowHeight

    property string layout: "?"
    property string deviceName: ""

    Process {
        id: initProc
        command: ["hyprctl", "-j", "devices"]
        running: true
        stdout: StdioCollector {
            id: out
            onStreamFinished: {
                try {
                    const d = JSON.parse(out.text)
                    const kb = d.keyboards.find(k => k.main === true) || d.keyboards[0]
                    if (kb) {
                        root.deviceName = kb.name || ""
                        if (kb.active_keymap)
                            root.layout = kb.active_keymap.slice(0, 2).toLowerCase()
                    }
                } catch (e) { console.warn("kb parse:", e) }
            }
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout") {
                const parts = (event.data || "").split(",")
                if (parts.length >= 2)
                    root.layout = parts[1].trim().slice(0, 2).toLowerCase()
            }
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        z: 100
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            kbPop.restart()
            if (root.deviceName !== "")
                Quickshell.execDetached(["hyprctl", "switchxkblayout", root.deviceName, "next"])
            else
                Quickshell.execDetached(["hyprctl", "switchxkblayout", "all", "next"])
        }
    }

    Row {
        id: inner
        anchors.centerIn: parent
        spacing: 5
        scale: ma.containsMouse ? 1.5 : 1.4
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: ""
            color: ma.containsMouse ? Theme.active : Theme.filled
            font.family: Theme.mono
            font.pixelSize: 15
            Behavior on color { ColorAnimation { duration: 140 } }
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.layout.toUpperCase()
            color: ma.containsMouse ? Theme.active : Theme.text
            font.family: Theme.mono
            font.pixelSize: 11
            font.bold: true
            Behavior on color { ColorAnimation { duration: 140 } }
        }
    }

    SequentialAnimation {
        id: kbPop
        NumberAnimation { target: inner; property: "scale"; to: 1.18; duration: 70 }
        NumberAnimation {
            target: inner; property: "scale"
            to: ma.containsMouse ? 1.5 : 1.4
            duration: 160; easing.type: Easing.OutBack
        }
    }
}
