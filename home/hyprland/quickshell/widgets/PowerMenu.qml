import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import ".."

Item {
    id: root
    implicitWidth:  inner.implicitWidth
    implicitHeight: Theme.rowHeight

    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }

    Row {
        id: inner
        anchors.centerIn: parent
        spacing: 4
        scale: hover.hovered ? 1.08 : 1.0
        Behavior on scale { NumberAnimation { duration: Theme.normal; easing.type: Theme.easeBack } }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "\uf011"
            color: hover.hovered ? Theme.urgent : Theme.text
            font.family: Theme.mono
            font.pixelSize: 15
            Behavior on color { ColorAnimation { duration: Theme.fast } }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: 100
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: powerPopup.visible = !powerPopup.visible
    }

    PopupWindow {
        id: powerPopup
        visible: false
        color: "transparent"
        implicitWidth:  240
        implicitHeight: 260

        anchor.window: root.QsWindow.window
        anchor.rect.x: root.QsWindow.window.width - width - 14
        anchor.rect.y: root.height

        PopupSurface {
            anchors.fill: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 4

                Text {
                    Layout.leftMargin: 6
                    Layout.topMargin: 2
                    Layout.bottomMargin: 4
                    text: "Питание"
                    color: Theme.textFaint
                    font.family: Theme.mono
                    font.pixelSize: 10
                    font.bold: true
                    font.letterSpacing: 1
                }

                PowerButton {
                    Layout.fillWidth: true
                    icon:    "\uf28b"
                    label:   "Гибернация"
                    accent:  Theme.filled
                    enabled: Power.hibernateAvailable
                    onClicked: { powerPopup.visible = false; Power.hibernate() }
                }

                PowerButton {
                    Layout.fillWidth: true
                    icon:    "\uf186"
                    label:   "Спящий режим"
                    accent:  Theme.filled
                    onClicked: { powerPopup.visible = false; Power.suspend() }
                }

                PowerButton {
                    Layout.fillWidth: true
                    icon:    "\uf021"
                    label:   "Перезагрузить"
                    accent:  Theme.urgent
                    onClicked: { powerPopup.visible = false; Power.reboot() }
                }

                PowerButton {
                    Layout.fillWidth: true
                    icon:    "\uf011"
                    label:   "Выключить"
                    accent:  Theme.urgent
                    onClicked: { powerPopup.visible = false; Power.shutdown() }
                }

                PowerButton {
                    Layout.fillWidth: true
                    icon:    "\uf023"
                    label:   "Заблокировать"
                    accent:  Theme.active
                    onClicked: { powerPopup.visible = false; Power.lock() }
                }

                PowerButton {
                    Layout.fillWidth: true
                    icon:    "\uf08b"
                    label:   "Выйти"
                    accent:  Theme.filled
                    onClicked: { powerPopup.visible = false; Power.logout() }
                }
            }
        }
    }

    component PowerButton: Rectangle {
        id: btn

        property string icon:    ""
        property string label:   ""
        property color  accent:  Theme.filled
        property bool   enabled: true

        signal clicked()

        implicitHeight: 32
        radius: 6
        color: !btn.enabled
            ? "transparent"
            : btnHover.hovered
                ? Qt.rgba(1, 1, 1, 0.08)
                : "transparent"
        opacity: btn.enabled ? 1.0 : 0.35

        Behavior on color { ColorAnimation { duration: Theme.fast } }

        HoverHandler {
            id: btnHover
            cursorShape: btn.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        }

        MouseArea {
            anchors.fill: parent
            enabled: btn.enabled
            onClicked: btn.clicked()
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 10

            Text {
                text: btn.icon
                color: btn.enabled ? btn.accent : Theme.textFaint
                font.family: Theme.mono
                font.pixelSize: 15
            }

            Text {
                Layout.fillWidth: true
                text: btn.label
                color: btn.enabled ? Theme.text : Theme.textFaint
                font.family: Theme.mono
                font.pixelSize: 12
                elide: Text.ElideRight
            }
        }
    }
}
