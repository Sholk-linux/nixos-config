import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: root
    implicitWidth:  inner.implicitWidth
    implicitHeight: Theme.rowHeight

    property real cpu: 0
    property var  prev: null

    Process {
        id: proc
        command: ["cat", "/proc/stat"]
        running: false
        stdout: StdioCollector {
            id: out
            onStreamFinished: {
                const l = out.text.split("\n")[0].split(/\s+/)
                const u = +l[1], n = +l[2], s = +l[3], i = +l[4]
                const w = +l[5] || 0, ir = +l[6] || 0, si = +l[7] || 0
                const busy  = u + n + s + ir + si
                const total = busy + i + w
                const p = root.prev
                if (p && total > p.total)
                    root.cpu = Math.max(0, Math.min(100, (busy - p.busy) / (total - p.total) * 100))
                root.prev = { busy, total }
            }
        }
    }

    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
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
            color: ma.containsMouse ? Theme.filled : Theme.active
            font.family: Theme.mono
            font.pixelSize: 15
            Behavior on color { ColorAnimation { duration: 140 } }
        }
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                text: root.cpu.toFixed(0) + "%"
                color: Theme.text
                font.family: Theme.mono
                font.pixelSize: 11
                font.bold: true
            }
            Rectangle {
                width: 44; height: 3; radius: 1.5
                color: Qt.rgba(1, 1, 1, 0.08)
                Rectangle {
                    width: parent.width * Math.min(1, root.cpu / 100)
                    height: parent.height
                    radius: parent.radius
                    color: root.cpu > 80 ? Theme.urgent
                         : root.cpu > 50 ? Theme.filled
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
