import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: root
    implicitWidth:  inner.implicitWidth
    implicitHeight: Theme.rowHeight

    property real used:  0
    property real total: 1
    readonly property real ratio: root.total > 0 ? root.used / root.total : 0

    Process {
        id: proc
        command: ["cat", "/proc/meminfo"]
        running: false
        stdout: StdioCollector {
            id: out
            onStreamFinished: {
                const t = /MemTotal:\s+(\d+)/.exec(out.text)
                const a = /MemAvailable:\s+(\d+)/.exec(out.text)
                if (t && a) {
                    root.total = +t[1] / 1048576
                    root.used  = (+t[1] - +a[1]) / 1048576
                }
            }
        }
    }

    Timer {
        interval: 2000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: proc.running = true
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            pop.restart()
            Hypr.spawn("kitty -e btop || foot btop || alacritty -e btop")
        }
    }

    Row {
        id: inner
        anchors.centerIn: parent
        spacing: 6
        scale: ma.containsMouse ? 1.08 : 1.0
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: ""
            color: ma.containsMouse ? Theme.active : Theme.filled
            font.family: Theme.mono
            font.pixelSize: 15
            Behavior on color { ColorAnimation { duration: 140 } }
        }
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                text: root.used.toFixed(1) + "G"
                color: Theme.text
                font.family: Theme.mono
                font.pixelSize: 11
                font.bold: true
            }
            Rectangle {
                width: 44; height: 3; radius: 1.5
                color: Qt.rgba(1, 1, 1, 0.08)
                Rectangle {
                    width: parent.width * Math.min(1, root.ratio)
                    height: parent.height
                    radius: parent.radius
                    color: root.ratio > 0.85 ? Theme.urgent
                         : root.ratio > 0.60 ? Theme.filled
                         : Theme.active
                    Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation  { duration: 250 } }
                }
            }
        }
    }

    SequentialAnimation {
        id: pop
        NumberAnimation { target: inner; property: "scale"; to: 1.18; duration: 70 }
        NumberAnimation {
            target: inner; property: "scale"
            to: ma.containsMouse ? 1.08 : 1.0
            duration: 160
            easing.type: Easing.OutBack
        }
    }
}
