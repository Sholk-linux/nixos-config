import QtQuick
import QtQuick.Effects
import ".."

Rectangle {
    id: root

    color: Theme.bg
    radius: Theme.radius

    // Лёгкая тень только снизу и по бокам
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowBlur: 0.9
        shadowColor: Qt.rgba(0, 0, 0, 0.35)
        shadowVerticalOffset: 10
        shadowHorizontalOffset: 0
    }

    // Маска сверху: перекрывает верхние скругления,
    // чтобы попап «вырастал» из панели без шва.
    // Дети, добавленные после — рендерятся поверх.
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.radius
        color: Theme.bg
    }
}
