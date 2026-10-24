import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Cutie
import Cutie.Feedback

Button {
	id: root
	width: parent.width
	property string subText: ""
	property bool iconOverlay: true
	
	// Clean fallback defaults avoid all null-pointer checks
	property int itemIconWidth: root.icon && root.icon.width ? root.icon.width : 20
	property int itemIconHeight: root.icon && root.icon.height ? root.icon.height : 20
    
	property int wrapMode: Text.Wrap
	property int elide: Text.ElideNone
	property int maximumLineCount: -1
    
	property CutieMenu menu
	padding: 15
	bottomPadding: 10

    onIconChanged: {
        if (icon && icon.name) {
            iconImage.usingTheme = true;
            iconImage.source = "image://icon/" + icon.name;
        } else if (icon && icon.source) {
            iconImage.usingTheme = false;
            iconImage.source = icon.source;
        }
    }

	onPressAndHold: {
		if (menu) {
        	CutieFeedback.trigger(Application.name, "button-pressed", {}, -1);
			menu.open();
		}
	}

    onClicked: {
        CutieFeedback.trigger(Application.name, "button-pressed", {}, -1);
    }

	background: CutieTile {
		anchors.fill: parent
		anchors.topMargin: 5
		anchors.leftMargin: 10
		anchors.rightMargin: 10
		opacity: highlighted || pressed ? 1.0 : 0.0
	}

	contentItem: RowLayout {
		spacing: 15
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.leftMargin: 20
		anchors.rightMargin: 30
		height: Math.max(iconItem.height, textCol.height)

		Item {
			id: iconItem
			width: root.itemIconWidth
			height: root.itemIconHeight

			Image {
				id: iconImage
				width: parent.width
				height: parent.height
				source: root.icon ? root.icon.source : ""
				fillMode: Image.PreserveAspectFit
				sourceSize.width: width
				sourceSize.height: height
				visible: false
                property bool usingTheme: false

                onStatusChanged: {
                    if (status == Image.Error && usingTheme && root.icon) {
                        usingTheme = false;
                        source = root.icon.source;
                    }
                }
			}

			MultiEffect {
				id: fastTint
				source: iconImage
				anchors.fill: iconImage
				colorization: 1.0
				colorizationColor: root.icon && root.icon.color ? root.icon.color : Atmosphere.textColor
				visible: root.iconOverlay || (root.icon && root.icon.color)
			}
		}

		ColumnLayout {
			id: textCol
        	Layout.fillWidth: true
			spacing: subTextItem.visible ? 5 : 0

			CutieLabel {
				id: mainTextItem
				text: root.text
				font.pixelSize: 15
        		Layout.fillWidth: true
				wrapMode: root.wrapMode
				elide: root.elide
				maximumLineCount: root.maximumLineCount
			}

			CutieLabel {
				id: subTextItem
				text: root.subText
				visible: root.subText !== ""
				font.pixelSize: 10
        		Layout.fillWidth: true
				wrapMode: root.wrapMode
				elide: root.elide
				maximumLineCount: root.maximumLineCount
			}
		}
	}
}
