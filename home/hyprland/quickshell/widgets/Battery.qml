import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Item {
    id: root
    implicitWidth: inner.implicitWidth
    implicitHeight: Theme.rowHeight

    property int percentage: 0
    property bool isCharging: false
    readonly property real ratio: root.percentage / 100.0

    // Процесс чтения процента заряда
    Process {
        id: capProc
        command: ["cat", "/sys/class/power_supply/BAT0/capacity"]
        running: false
        stdout: StdioCollector {
            id: capOut
            onStreamFinished: {
                const p = parseInt(capOut.text.trim());
                if (!isNaN(p))
                    root.percentage = p;
            }
        }
    }

    // Процесс чтения статуса (заряжается или нет)
    Process {
        id: statusProc
        command: ["cat", "/sys/class/power_supply/BAT0/status"]
        running: false
        stdout: StdioCollector {
            id: statusOut
            onStreamFinished: {
                root.isCharging = (statusOut.text.trim() === "Charging");
            }
        }
    }

    // Обновляем данные раз в 10 секунд (батарея не так быстро меняется, как ОЗУ)
    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            capProc.running = true;
            statusProc.running = true;
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            pop.restart();
            // Можно заменить на upower -d или любую другую утилиту диагностики питания
            Hypr.spawn("kitty -e upower -d || foot upower -d || alacritty -e upower -d");
        }
    }

    Row {
        id: inner
        anchors.centerIn: parent
        spacing: 6
        scale: ma.containsMouse ? 1.08 : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutBack
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            // Иконка меняется в зависимости от статуса зарядки
            text: root.isCharging ? "󰂄" : "󰁹"
            color: ma.containsMouse ? Theme.active : Theme.filled
            font.family: Theme.mono
            font.pixelSize: 15
            Behavior on color {
                ColorAnimation {
                    duration: 140
                }
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                // Текст меняется на "Заряд" при подключении питания, либо просто процент
                text: root.percentage + "%"
                color: Theme.text
                font.family: Theme.mono
                font.pixelSize: 11
                font.bold: true
            }

            Rectangle {
                width: 44
                height: 3
                radius: 1.5
                color: Qt.rgba(1, 1, 1, 0.08)

                Rectangle {
                    width: parent.width * Math.min(1, root.ratio)
                    height: parent.height
                    radius: parent.radius

                    // Логика цвета:
                    // Заряжается -> Зеленый (Theme.active)
                    // Меньше 20% -> Красный (Theme.urgent)
                    // В остальных случаях -> Твой основной цвет (Theme.filled)
                    color: root.isCharging ? Theme.active : root.ratio < 0.20 ? Theme.urgent : Theme.filled

                    Behavior on width {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutCubic
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: 250
                        }
                    }
                }
            }
        }
    }

    SequentialAnimation {
        id: pop
        NumberAnimation {
            target: inner
            property: "scale"
            to: 1.18
            duration: 70
        }
        NumberAnimation {
            target: inner
            property: "scale"
            to: ma.containsMouse ? 1.08 : 1.0
            duration: 160
            easing.type: Easing.OutBack
        }
    }
}
