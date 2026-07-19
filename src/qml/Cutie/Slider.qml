import QtQuick
import QtQuick.Controls
import Cutie

Slider {
    id: root

    leftPadding: 10
    rightPadding: 10
    topPadding: 5
    bottomPadding: 5
    implicitWidth: orientation === Qt.Horizontal ? 200 : 40
    implicitHeight: orientation === Qt.Horizontal ? 40 : 200

    property real backgroundWidth: orientation === Qt.Horizontal ? availableWidth - rightPadding - leftPadding : 3
    property real backgroundHeight: orientation === Qt.Horizontal ? 3 : availableHeight - topPadding - bottomPadding
    property real handleX: orientation === Qt.Horizontal ? leftPadding + visualPosition * (availableWidth - 20) : (availableWidth - 20) / 2
    property real handleY: orientation === Qt.Horizontal ? topPadding + 5 : topPadding + (visualPosition) * (availableHeight - 20)

    background: Rectangle {
        x: root.orientation === Qt.Horizontal ? 25 : 19
        y: root.orientation === Qt.Horizontal ? 19 : 25
        width: root.backgroundWidth
        height: root.backgroundHeight
        radius: (root.orientation === Qt.Horizontal ? height : width) / 2
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
