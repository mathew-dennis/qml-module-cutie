import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Cutie

Window {
    visible: true
    readonly property bool isFullScreen: visibility === Window.FullScreen
    readonly property bool isMaximized: visibility === Window.Maximized
    readonly property bool isWindowed: visibility === Window.Windowed

    color: isWindowed ?  "black" : "transparent" 

    property Item initialPage: null
    property Item firstChildPage: null
    property int wideLayoutBreakpoint: 800
    readonly property bool wideLayout: width >= wideLayoutBreakpoint
    readonly property CutiePageStack pageStack: _pageStack

    Component.onCompleted: {
        console.log("Initial window visibility state:", visibility)
        _pageStack.push(initialPage)
        if (firstChildPage) {
            firstChildPage.parent = _placeholder
            firstChildPage.anchors.fill = _placeholder
        }
        _syncRootPage()
    }

    onWideLayoutChanged: _syncRootPage()

    // Only the root page changes pane: left of the divider when wide,
    // index 0 of the stack when compact.
    function _syncRootPage() {
        if (wideLayout && _pageStack.itemAt(0) === initialPage) {
            _sidebar.addItem(_pageStack.takeItem(0))
            // apps may bind the root page's size to the window; pin it to the sidebar
            initialPage.width = Qt.binding(() => _sidebar.width)
            initialPage.height = Qt.binding(() => _sidebar.height)
        }
        else if (!wideLayout && _sidebar.count > 0)
            _pageStack.insertItem(0, _sidebar.takeItem(0))
    }

    property CutieToastHandler toastHandler: toastHandler

    CutieToastHandler {
        id: toastHandler
    }

    SwipeView {
        id: _sidebar
        interactive: false
        visible: wideLayout
        width: Math.min(360, Math.max(280, parent.width * 0.34))
        anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
    }

    Rectangle {
        x: _sidebar.width
        width: 1
        height: parent.height
        visible: wideLayout
        color: Atmosphere.secondaryAlphaColor
    }

    // Shown in the right pane while the stack is empty.
    Item {
        id: _placeholder
        anchors.fill: _pageStack
        visible: wideLayout && _pageStack.count === 0
    }

    CutiePageStack {
        id: _pageStack
        anchors.fill: parent
        clip: true   // keep the neighbouring page from drawing over the sidebar
        anchors.leftMargin: wideLayout ? _sidebar.width + 1 : 0
    }
}
