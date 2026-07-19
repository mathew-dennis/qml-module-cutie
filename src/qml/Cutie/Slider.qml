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

    background: Rectangle {
        x: root.orientation === Qt.Horizontal ? 25 : root.availableWidth / 2 - 1.5
        y: root.orientation === Qt.Horizontal ? 19 : root.topPadding
        width: root.orientation === Qt.Horizontal ? root.availableWidth - root.rightPadding - root.leftPadding : 3
        height: root.orientation === Qt.Horizontal ? 3 : root.availableHeight - root.topPadding - root.bottomPadding
        radius: (root.orientation === Qt.Horizontal ? height : width) / 2
        color: Atmosphere.primaryAlphaColor
    }

    handle: Rectangle {
        x: root.orientation === Qt.Horizontal ? root.leftPadding + root.visualPosition * (root.availableWidth - width) : root.leftPadding + (root.availableWidth - width) / 2
        y: root.orientation === Qt.Horizontal ? root.topPadding + 5 : root.topPadding + (1 - root.visualPosition) * (root.availableHeight - height)
        width: 20
        height: 20
        radius: width / 2
        color: Atmosphere.textColor
    }

}
