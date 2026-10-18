import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import ".."

Item {
    id: root
    implicitWidth:  inner.implicitWidth
    implicitHeight: Theme.rowHeight

    HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }

    Connections {
        target: Hyprland
        function onActiveToplevelChanged() {
            if (centerPopup.visible) centerPopup.visible = false
        }
    }

    property int lastCount: 1
    onLastCountChanged: {
        if (Notifications.history.length > lastCount) pulse.restart()
        lastCount = Notifications.history.length
    }
    Component.onCompleted: lastCount = Notifications.history.length

    Row {
        id: inner
        anchors.centerIn: parent
        spacing: 5
        scale: hover.hovered ? 1.08 : 1.0
        Behavior on scale { NumberAnimation { duration: Theme.normal; easing.type: Theme.easeBack } }

        Item {
            width: 16; height: 16
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: bell
                anchors.centerIn: parent
                text: Notifications.dnd ? "\uf09b" : "\uf0f3"
                color: hover.hovered
                    ? Theme.active
                    : (Notifications.history.length > 0 ? Theme.filled : Theme.text)
                font.family: Theme.mono
                font.pixelSize: 15
                Behavior on color { ColorAnimation { duration: Theme.fast } }

                SequentialAnimation {
                    id: pulse
                    NumberAnimation { target: bell; property: "scale"; to: 1.35; duration: 120; easing.type: Easing.OutCubic }
                    NumberAnimation { target: bell; property: "scale"; to: 1.0;  duration: 220; easing.type: Easing.OutBack }
                }
            }
        }

        Text {
            id: counter
            visible: Notifications.history.length > 0
            anchors.verticalCenter: parent.verticalCenter
            text: Notifications.history.length > 99 ? "99+" : Notifications.history.length
            color: hover.hovered ? Theme.active : Theme.text
            font.family: Theme.mono
            font.pixelSize: 11
            font.bold: true
            Behavior on color { ColorAnimation { duration: Theme.fast } }

            onTextChanged: counterAnim.restart()

            SequentialAnimation {
                id: counterAnim
                NumberAnimation { target: counter; property: "scale"; to: 1.35; duration: 90 }
                NumberAnimation { target: counter; property: "scale"; to: 1.0;  duration: 180; easing.type: Easing.OutBack }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: 100
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: centerPopup.visible = !centerPopup.visible
    }

    PopupWindow {
        id: centerPopup
        visible: false
        color: "transparent"

        readonly property int contentHeight:
            Notifications.history.length === 0
                ? 96
                : Math.min(500, 88 + Notifications.history.length * 78)

        implicitWidth:  380
        implicitHeight: contentHeight

        Behavior on implicitHeight { NumberAnimation { duration: Theme.slow; easing.type: Theme.easeOut } }

        anchor.window: root.QsWindow.window
        anchor.rect.x: root.QsWindow.window.width - width - 14
        anchor.rect.y: root.height

        PopupSurface {
            id: card
            anchors.fill: parent

            opacity: centerPopup.visible ? 1.0 : 0.0
            scale:   centerPopup.visible ? 1.0 : 0.94
            transformOrigin: Item.TopRight

            Behavior on opacity { NumberAnimation { duration: Theme.normal; easing.type: Theme.easeOut } }
            Behavior on scale   { NumberAnimation { duration: Theme.normal; easing.type: Theme.easeBack } }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: "Уведомления"
                        color: Theme.text
                        font.family: Theme.mono
                        font.pixelSize: 14
                        font.bold: true
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        width:  82
                        height: 26
                        radius: 6
                        color: Notifications.dnd ? Theme.urgent : Theme.empty
                        Behavior on color { ColorAnimation { duration: Theme.slow } }

                        Text {
                            anchors.centerIn: parent
                            text: Notifications.dnd ? "DND ON" : "DND OFF"
                            color: Notifications.dnd ? Theme.textActive : Theme.text
                            font.family: Theme.mono
                            font.pixelSize: 10
                            font.bold: true
                            Behavior on color { ColorAnimation { duration: Theme.slow } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Notifications.toggleDnd()
                        }
                    }

                    Rectangle {
                        width:  60
                        height: 26
                        radius: 6
                        color: clearHover.hovered ? Theme.surface2 : Theme.empty
                        visible: Notifications.history.length > 0
                        Behavior on color { ColorAnimation { duration: Theme.fast } }

                        Text {
                            anchors.centerIn: parent
                            text: "Clear"
                            color: Theme.text
                            font.family: Theme.mono
                            font.pixelSize: 10
                            font.bold: true
                        }

                        HoverHandler { id: clearHover; cursorShape: Qt.PointingHandCursor }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: Notifications.clearHistory()
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.divider
                    visible: Notifications.history.length > 0
                }

                Item {
                    Layout.fillWidth: true
                    Layout.topMargin: 12
                    Layout.preferredHeight: 24
                    visible: Notifications.history.length === 0

                    Text {
                        anchors.centerIn: parent
                        text: Notifications.dnd
                            ? "Режим 'Не беспокоить' включён"
                            : "Нет уведомлений"
                        color: Qt.rgba(0.8, 0.9, 1, 0.4)
                        font.family: Theme.mono
                        font.pixelSize: 12

                        opacity: visible ? 1.0 : 0.0
                        Behavior on opacity {
                            NumberAnimation { duration: Theme.slow; easing.type: Theme.easeOut }
                        }
                    }
                }

                ListView {
                    id: notifList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: Notifications.history.length > 0
                    clip: true
                    spacing: 6
                    model: Notifications.history

                    add: Transition {
                        NumberAnimation { properties: "opacity,scale"; from: 0; to: 1; duration: Theme.slow; easing.type: Theme.easeOut }
                    }
                    remove: Transition {
                        NumberAnimation { property: "opacity"; to: 0; duration: Theme.normal }
                        NumberAnimation { property: "scale";   to: 0.9; duration: Theme.normal }
                    }
                    displaced: Transition {
                        NumberAnimation { properties: "x,y"; duration: Theme.normal; easing.type: Theme.easeOut }
                    }

                    delegate: Rectangle {
                        id: itemRect
                        required property int index
                        required property var modelData

                        width: notifList.width
                        height: itemContent.implicitHeight + 16
                        radius: Theme.radiusSm

                        readonly property bool isUrgent: modelData.urgency === 2

                        color: isUrgent
                            ? Qt.rgba(0.94, 0.64, 0.67, 0.12)
                            : itemHover.hovered ? Theme.surface2 : Theme.surface1
                        border.width: isUrgent ? 2 : 0
                        border.color: Theme.urgent

                        Behavior on color { ColorAnimation { duration: Theme.fast } }

                        HoverHandler { id: itemHover }

                        RowLayout {
                            id: itemContent
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8

                            Item {
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24

                                readonly property string resolvedIcon: {
                                    if (modelData.appIcon && modelData.appIcon.length > 0)
                                        return modelData.appIcon
                                    if (modelData.appName && modelData.appName.length > 0) {
                                        const e = DesktopEntries.heuristicLookup(
                                            modelData.appName.toLowerCase()
                                        )
                                        if (e && e.icon) return e.icon
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
                                spacing: 2

                                Text {
                                    Layout.fillWidth: true
                                    text: modelData.summary
                                    color: itemRect.isUrgent ? Theme.urgent : Theme.text
                                    font.family: Theme.mono
                                    font.pixelSize: 12
                                    font.bold: true
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
                                }

                                Text {
                                    Layout.fillWidth: true
                                    visible: (modelData.body || "").length > 0
                                    text: modelData.body
                                    color: Qt.rgba(0.8, 0.9, 1, 0.7)
                                    font.family: Theme.mono
                                    font.pixelSize: 10
                                    wrapMode: Text.Wrap
                                    elide: Text.ElideRight
                                    maximumLineCount: 3
                                }

                                Text {
                                    text: Qt.formatDateTime(modelData.time, "hh:mm")
                                    color: Qt.rgba(0.8, 0.9, 1, 0.4)
                                    font.family: Theme.mono
                                    font.pixelSize: 9
                                }
                            }

                            Item {
                                Layout.preferredWidth: 22
                                Layout.preferredHeight: 22

                                Rectangle {
                                    anchors.fill: parent
                                    radius: 4
                                    scale: delHover.hovered ? 1.15 : 1.0
                                    color: delHover.hovered
                                        ? Qt.rgba(0.94, 0.64, 0.67, 0.25)
                                        : "transparent"
                                    Behavior on color { ColorAnimation { duration: Theme.fast } }
                                    Behavior on scale { NumberAnimation { duration: Theme.fast; easing.type: Theme.easeBack } }

                                    Text {
                                        anchors.centerIn: parent
                                        text: "✕"
                                        color: delHover.hovered
                                            ? Theme.urgent
                                            : Qt.rgba(0.8, 0.9, 1, 0.5)
                                        font.family: Theme.mono
                                        font.pixelSize: 12
                                        Behavior on color { ColorAnimation { duration: Theme.fast } }
                                    }
                                }

                                HoverHandler { id: delHover; cursorShape: Qt.PointingHandCursor }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: Notifications.removeByIndex(itemRect.index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
