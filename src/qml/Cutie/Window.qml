import QtQuick
import QtQuick.Window
import Cutie

Window {
    visible: true
    readonly property bool isFullScreen: visibility === Window.FullScreen
    readonly property bool isMaximized: visibility === Window.Maximized
    readonly property bool isWindowed: visibility === Window.Windowed

    color: isWindowed ?  "white" : "transparent" 

    property Item initialPage: null
    readonly property CutiePageStack pageStack: _pageStack

    Component.onCompleted: {
        console.log("Initial window visibility state:", visibility)
        _pageStack.push(initialPage)
    }

    property CutieToastHandler toastHandler: toastHandler

    CutieToastHandler {
        id: toastHandler
    }

    CutiePageStack {
        id: _pageStack
	    anchors.fill: parent
    }
}
