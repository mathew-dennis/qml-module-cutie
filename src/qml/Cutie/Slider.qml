import QtQuick
import QtQuick.Controls
import Cutie

Slider {
    id: root

    leftPadding: 10
    rightPadding: 10
    topPadding: 10
    bottomPadding: 10
    implicitWidth: orientation === Qt.Horizontal ? 200 : 40
    implicitHeight: orientation === Qt.Horizontal ? 40 : 200

    readonly property bool isHorizontal: orientation === Qt.Horizontal

    property real backgroundWidth: isHorizontal ? availableWidth - rightPadding - leftPadding : 3
    property real backgroundHeight: isHorizontal ? 3 : availableHeight - topPadding - bottomPadding
    property real handleX: isHorizontal ? leftPadding + visualPosition * (availableWidth - 20) : topPadding + 5
    property real handleY: isHorizontal ? topPadding + 5 : topPadding + (visualPosition) * (availableHeight - 20)

    background: Rectangle {
        x: root.isHorizontal ? 25 : 19
        y: root.isHorizontal ? 19 : 25
        width: root.backgroundWidth
        height: root.backgroundHeight
        radius: 20
        color: Atmosphere.primaryAlphaColor
    }

    handle: Rectangle {
        x: root.handleX
        y: root.handleY
        width: 20
        height: 20
        radius: width / 2
        color: Atmosphere.textColor
    }
}
