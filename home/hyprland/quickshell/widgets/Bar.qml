import QtQuick
import Quickshell
import Quickshell.Wayland
import ".."

PanelWindow {
    id: root
    anchors { top: true; left: true; right: true }
    margins { top: 8; left: 8; right: 8 }
    implicitHeight: 44
	color: "transparent"
    Rectangle {
        anchors.fill: parent
        color: Theme.bg
        radius: 12
        border.width: 1
        border.color: Qt.rgba(0.5, 0.8, 1, 0.06)
    }

    Item {
        anchors.fill: parent

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Workspaces {}
            Separator {}
            ActiveWindow {}
        }

        Clock {
            anchors.centerIn: parent
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            spacing: 16

			KeyboardLayout {}
			Separator {}
			AudioMixer {}
			NotificationCenter {}
			Separator {}
            CpuUsage {}
            MemoryUsage {}
			NetworkStatus {}
			Separator {}
			PowerMenu {}
        }
    }
}
