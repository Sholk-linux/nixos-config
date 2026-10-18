import QtQuick
import Quickshell
import ".."

Item {
    id: root
    implicitWidth:  col.implicitWidth
    implicitHeight: col.implicitHeight
    scale: ma.containsMouse ? 1.04 : 0.95
    Behavior on scale { NumberAnimation { duration: Theme.normal; easing.type: Theme.easeBack } }

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Column {
        id: col
        anchors.centerIn: parent
        spacing: -4

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            // ─── Часы (анимация смены) ───
            Item {
                width:  h.implicitWidth
                height: h.implicitHeight
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: h
                    anchors.centerIn: parent
                    text: clock.hours.toString().padStart(2, "0")
                    color: ma.containsMouse ? Theme.active : Theme.text
                    font.family: Theme.mono
                    font.pixelSize: 26
                    font.bold: true
                    Behavior on color { ColorAnimation { duration: Theme.fast } }

                    // Смена часа — лёгкий подскок
                    onTextChanged: hourAnim.restart()
                }
                SequentialAnimation {
                    id: hourAnim
                    NumberAnimation { target: h; property: "scale"; to: 1.15; duration: 90 }
                    NumberAnimation { target: h; property: "scale"; to: 1.0;  duration: 180; easing.type: Easing.OutBack }
                }
            }

            Text {
                text: ":"
                color: Theme.active
                font.family: Theme.mono
                font.pixelSize: 26
                font.bold: true
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.25; duration: 600; easing.type: Theme.easeSoft }
                    NumberAnimation { to: 1.00; duration: 600; easing.type: Theme.easeSoft }
                }
            }

            // ─── Минуты (анимация смены) ───
            Item {
                width:  m.implicitWidth
                height: m.implicitHeight
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: m
                    anchors.centerIn: parent
                    text: clock.minutes.toString().padStart(2, "0")
                    color: ma.containsMouse ? Theme.active : Theme.text
                    font.family: Theme.mono
                    font.pixelSize: 26
                    font.bold: true
                    Behavior on color { ColorAnimation { duration: Theme.fast } }

                    onTextChanged: minAnim.restart()
                }
                SequentialAnimation {
                    id: minAnim
                    NumberAnimation { target: m; property: "scale"; to: 1.15; duration: 90 }
                    NumberAnimation { target: m; property: "scale"; to: 1.0;  duration: 180; easing.type: Easing.OutBack }
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(clock.date, "ddd, d MMM")
            color: Theme.filled
            font.family: Theme.mono
            font.pixelSize: 11
            font.letterSpacing: 1
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.scale = 1.14
            root.scale = ma.containsMouse ? 1.06 : 1.0
        }
    }
}
