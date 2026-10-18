import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: root
    implicitWidth:  inner.implicitWidth
    implicitHeight: Theme.rowHeight

    property string iface: ""
    property string state: "down"
    property int    speed: 0

    Process {
        id: devProc
        command: ["sh", "-c",
            "for n in /sys/class/net/*; do " +
            "b=$(basename $n); " +
            "[ \"$b\" = lo ] && continue; " +
            "case $b in wl*|ww*) continue;; esac; " +
            "echo $b; break; done"]
        running: false
        stdout: StdioCollector {
            id: devOut
            onStreamFinished: root.iface = devOut.text.trim()
        }
    }

    Process {
        id: infoProc
        command: ["sh", "-c",
            "[ -z \"$IFACE\" ] && exit; " +
            "echo -n \"$(cat /sys/class/net/$IFACE/operstate) \"; " +
            "cat /sys/class/net/$IFACE/speed 2>/dev/null || echo 0"]
        running: false
        environment: ({ IFACE: root.iface })
        stdout: StdioCollector {
            id: infoOut
            onStreamFinished: {
                const p = infoOut.text.trim().split(/\s+/)
                root.state = p[0] || "down"
                root.speed = parseInt(p[1]) || 0
            }
        }
    }

    Timer {
        interval: 3000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            if (root.iface === "") devProc.running = true
            else infoProc.running = true
        }
    }

    readonly property bool up: root.state === "up" || root.state === "unknown"
    readonly property string label: {
        if (!root.iface)        return "no"
        if (!root.up)           return "down"
        if (root.speed >= 1000) return (root.speed / 1000).toFixed(root.speed % 1000 === 0 ? 0 : 1) + "G"
        if (root.speed > 0)     return root.speed + "M"
        return "up"
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            pop.restart()
            Hypr.spawn("nm-connection-editor || kitty -e nmtui")
        }
    }

    Row {
        id: inner
        anchors.centerIn: parent
        spacing: 5
        scale: ma.containsMouse ? 1.08 : 1.0
        Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.up ? "" : ""
            color: root.up
                ? (ma.containsMouse ? Theme.filled : Theme.active)
                : Theme.urgent
            font.family: Theme.mono
            font.pixelSize: 15
            Behavior on color { ColorAnimation { duration: 200 } }
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            color: ma.containsMouse ? Theme.active : Theme.text
            font.family: Theme.mono
            font.pixelSize: 11
            font.bold: true
            Behavior on color { ColorAnimation { duration: 140 } }
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
