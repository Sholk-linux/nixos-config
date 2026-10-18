import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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
        spacing: 5
        scale: hover.hovered ? 1.08 : 1.0
        Behavior on scale { NumberAnimation { duration: Theme.normal; easing.type: Theme.easeBack } }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: {
                if (Audio.masterMuted) return "\uf026"
                const v = Audio.masterVolume
                if (v < 0.34) return "\uf027"
                return "\uf028"
            }
            color: Audio.masterMuted
                ? Theme.urgent
                : (hover.hovered ? Theme.active : Theme.filled)
            font.family: Theme.mono
            font.pixelSize: 15
            Behavior on color { ColorAnimation { duration: Theme.fast } }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(Audio.masterVolume * 100) + "%"
            color: hover.hovered ? Theme.active : Theme.text
            font.family: Theme.mono
            font.pixelSize: 11
            font.bold: true
            Behavior on color { ColorAnimation { duration: Theme.fast } }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: 100
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            mixerPopup.visible = !mixerPopup.visible
            Audio.mixerOpen = mixerPopup.visible
        }
    }

    PopupWindow {
        id: mixerPopup
        visible: false
        color: "transparent"

        readonly property int streamCount: Audio.streams.length
        implicitWidth:  360
        implicitHeight: Math.min(560, 170 + streamCount * 80)

        anchor.window: root.QsWindow.window
        anchor.rect.x: root.QsWindow.window.width - width - 14
        anchor.rect.y: root.height

        PopupSurface {
            anchors.fill: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 10

                Text {
                    text: "Звук"
                    color: Theme.text
                    font.family: Theme.mono
                    font.pixelSize: 14
                    font.bold: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.divider
                }

                Text {
                    text: "Общая громкость"
                    color: Theme.textFaint
                    font.family: Theme.mono
                    font.pixelSize: 10
                    font.bold: true
                    font.letterSpacing: 1
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Item {
                        Layout.preferredWidth: 24
                        Layout.preferredHeight: 24

                        Rectangle {
                            anchors.fill: parent
                            radius: 6
                            color: masterMuteHover.hovered ? Theme.surface2 : "transparent"
                            Behavior on color { ColorAnimation { duration: Theme.fast } }
                        }

                        Text {
                            anchors.centerIn: parent
                            text: Audio.masterMuted ? "\uf026" : "\uf028"
                            color: Audio.masterMuted
                                ? Theme.urgent
                                : masterMuteHover.hovered ? Theme.active : Theme.filled
                            font.family: Theme.mono
                            font.pixelSize: 16
                            Behavior on color { ColorAnimation { duration: Theme.fast } }
                        }

                        HoverHandler { id: masterMuteHover; cursorShape: Qt.PointingHandCursor }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Audio.toggleMasterMute()
                        }
                    }

                    Slider {
                        id: masterSlider
                        Layout.fillWidth: true
                        from: 0
                        to: 1.5
                        value: Audio.masterVolume
                        onMoved: Audio.setMasterVolume(value)
                        onPressedChanged: Audio.sliderActive = pressed

                        background: Rectangle {
                            x: masterSlider.leftPadding
                            y: masterSlider.topPadding + masterSlider.availableHeight / 2 - height / 2
                            implicitHeight: 5
                            width: masterSlider.availableWidth
                            height: implicitHeight
                            radius: 2.5
                            color: Theme.surface2

                            Rectangle {
                                width: Math.min(masterSlider.visualPosition,
                                                1.0 / masterSlider.to) * parent.width
                                height: parent.height
                                radius: 2.5
                                color: Audio.masterMuted ? Theme.empty : Theme.active
                                Behavior on width { NumberAnimation { duration: Theme.fast } }
                                Behavior on color { ColorAnimation { duration: Theme.fast } }
                            }

                            Rectangle {
                                visible: Audio.masterVolume > 1.0
                                x: parent.width * (1.0 / masterSlider.to)
                                width: parent.width
                                     * (Math.min(Audio.masterVolume, 1.5) - 1.0)
                                     / masterSlider.to
                                height: parent.height
                                radius: 2.5
                                color: Theme.urgent
                            }
                        }

                        handle: Rectangle {
                            x: masterSlider.leftPadding + masterSlider.visualPosition
                               * (masterSlider.availableWidth - width)
                            y: masterSlider.topPadding + masterSlider.availableHeight / 2 - height / 2
                            implicitWidth: 14
                            implicitHeight: 14
                            radius: 7
                            color: masterSlider.pressed
                                ? Theme.filled
                                : masterSlider.hovered ? Theme.filled : Theme.active
                            Behavior on color { ColorAnimation { duration: Theme.fast } }
                        }
                    }

                    Text {
                        Layout.preferredWidth: 42
                        text: Math.round(Audio.masterVolume * 100) + "%"
                        color: Theme.text
                        font.family: Theme.mono
                        font.pixelSize: 11
                        font.bold: true
                        horizontalAlignment: Text.AlignRight
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Theme.divider
                }

                RowLayout {
                    Layout.fillWidth: true
                    visible: Audio.streams.length > 0
                    spacing: 6

                    Text {
                        Layout.fillWidth: true
                        text: "Приложения"
                        color: Theme.textFaint
                        font.family: Theme.mono
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 1
                    }

                    Text {
                        text: Audio.streams.length
                        color: Theme.textFaint
                        font.family: Theme.mono
                        font.pixelSize: 10
                        font.bold: true
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    visible: Audio.streams.length === 0

                    Text {
                        anchors.centerIn: parent
                        text: "Нет активных приложений"
                        color: Theme.textFaint
                        font.family: Theme.mono
                        font.pixelSize: 12
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    visible: Audio.streams.length > 0

                    Repeater {
                        model: Audio.streams

                        delegate: ColumnLayout {
                            id: streamItem
                            required property var modelData

                            Layout.fillWidth: true
                            spacing: 6

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Item {
                                    Layout.preferredWidth: 20
                                    Layout.preferredHeight: 20

                                    IconImage {
                                        id: appIconImg
                                        anchors.fill: parent
                                        source: {
                                            const p = modelData.properties
                                            const iconName = p
                                                ? (p["application.icon-name"] || "")
                                                : ""
                                            return iconName
                                                ? Quickshell.iconPath(iconName)
                                                : ""
                                        }
                                        visible: status === Image.Ready
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        visible: !appIconImg.visible
                                        text: "\uf001"
                                        color: Theme.filled
                                        font.family: Theme.mono
                                        font.pixelSize: 14
                                    }
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: {
                                        const p = modelData.properties
                                        if (p && p["application.name"])
                                            return p["application.name"]
                                        return modelData.name || "Неизвестно"
                                    }
                                    color: Theme.text
                                    font.family: Theme.mono
                                    font.pixelSize: 12
                                    font.bold: true
                                    elide: Text.ElideRight
                                    maximumLineCount: 1
                                }

                                Text {
                                    text: {
                                        if (!modelData.audio) return "—"
                                        return Math.round(modelData.audio.volume * 100) + "%"
                                    }
                                    color: Theme.textFaint
                                    font.family: Theme.mono
                                    font.pixelSize: 10
                                    Layout.preferredWidth: 36
                                    horizontalAlignment: Text.AlignRight
                                }

                                Item {
                                    Layout.preferredWidth: 22
                                    Layout.preferredHeight: 22

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 5
                                        color: streamMuteHover.hovered
                                            ? Theme.surface2
                                            : "transparent"
                                        Behavior on color { ColorAnimation { duration: Theme.fast } }
                                    }

                                    Text {
                                        anchors.centerIn: parent
                                        text: (modelData.audio && modelData.audio.muted)
                                            ? "\uf026"
                                            : "\uf028"
                                        color: (modelData.audio && modelData.audio.muted)
                                            ? Theme.urgent
                                            : streamMuteHover.hovered ? Theme.active : Theme.filled
                                        font.family: Theme.mono
                                        font.pixelSize: 14
                                        Behavior on color { ColorAnimation { duration: Theme.fast } }
                                    }

                                    HoverHandler { id: streamMuteHover; cursorShape: Qt.PointingHandCursor }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: Audio.toggleStreamMute(modelData)
                                    }
                                }
                            }

                            Slider {
                                id: streamSlider
                                Layout.fillWidth: true
                                from: 0
                                to: 1.5
                                value: modelData.audio ? modelData.audio.volume : 0
                                enabled: modelData.bound && modelData.audio
                                onMoved: Audio.setStreamVolume(modelData, value)
                                onPressedChanged: Audio.sliderActive = pressed

                                background: Rectangle {
                                    x: streamSlider.leftPadding
                                    y: streamSlider.topPadding + streamSlider.availableHeight / 2 - height / 2
                                    implicitHeight: 4
                                    width: streamSlider.availableWidth
                                    height: implicitHeight
                                    radius: 2
                                    color: Theme.surface2

                                    Rectangle {
                                        width: Math.min(streamSlider.visualPosition,
                                                        1.0 / streamSlider.to) * parent.width
                                        height: parent.height
                                        radius: 2
                                        color: (modelData.audio && modelData.audio.muted)
                                            ? Theme.empty
                                            : Theme.filled
                                        Behavior on width { NumberAnimation { duration: Theme.fast } }
                                        Behavior on color { ColorAnimation { duration: Theme.fast } }
                                    }

                                    Rectangle {
                                        visible: modelData.audio && modelData.audio.volume > 1.0
                                        x: parent.width * (1.0 / streamSlider.to)
                                        width: parent.width
                                             * (Math.min(modelData.audio ? modelData.audio.volume : 0, 1.5) - 1.0)
                                             / streamSlider.to
                                        height: parent.height
                                        radius: 2
                                        color: Theme.urgent
                                    }
                                }

                                handle: Rectangle {
                                    x: streamSlider.leftPadding + streamSlider.visualPosition
                                       * (streamSlider.availableWidth - width)
                                    y: streamSlider.topPadding + streamSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 12
                                    implicitHeight: 12
                                    radius: 6
                                    color: streamSlider.pressed
                                        ? Theme.active
                                        : streamSlider.hovered ? Theme.active : Theme.filled
                                    Behavior on color { ColorAnimation { duration: Theme.fast } }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
