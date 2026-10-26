import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Cutie
import Cutie.Feedback

Button {
	id: root
	width: parent.width
	property string subText: ""
	property bool iconOverlay: true
	property int wrapMode: Text.Wrap
	property int elide: Text.ElideNone
	property int maximumLineCount: -1
	property CutieMenu menu
	property string failedThemeIconName: ""
	readonly property bool hasIcon: !!icon.name || !!icon.source
	// icon.color defaults to transparent (an object, so it is always truthy in JS)
	readonly property bool hasIconColor: icon.color.a > 0
	// only theme/file icons named "*-symbolic" are recoloured by default
	readonly property bool isSymbolicIcon: {
		const src = iconImage.source.toString();
		return src.substring(src.lastIndexOf("/") + 1).indexOf("-symbolic") !== -1;
	}
	readonly property bool recolorIcon: hasIconColor || (iconOverlay && isSymbolicIcon)
	readonly property real resolvedIconWidth: icon.width > 0 ? icon.width : 32
	readonly property real resolvedIconHeight: icon.height > 0 ? icon.height : 32

	padding: 15
	bottomPadding: 10
	leftPadding: 0
	rightPadding: 0

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

	contentItem: Item {
		implicitWidth: 20 + iconItem.width + (iconItem.visible ? 15 : 0)
			+ textCol.implicitWidth + 20
		implicitHeight: Math.max(iconItem.height, textCol.implicitHeight)

		Item {
			id: iconItem
			visible: root.hasIcon
			width: visible ? root.resolvedIconWidth : 0
			height: visible ? root.resolvedIconHeight : 0
			anchors.left: parent.left
			anchors.leftMargin: 20
			anchors.verticalCenter: parent.verticalCenter

			Image {
				id: iconImage
				anchors.fill: parent
				property string themeIconUrl: root.icon.name
					? "image://icon/" + root.icon.name : ""
				source: themeIconUrl && root.failedThemeIconName !== root.icon.name
					? themeIconUrl : root.icon.source
				fillMode: Image.PreserveAspectFit
				sourceSize: Qt.size(width, height)
				asynchronous: true
				cache: root.icon.cache
				visible: !iconEffect.visible

				onStatusChanged: {
					if (status === Image.Error && themeIconUrl
							&& source.toString() === themeIconUrl) {
						root.failedThemeIconName = root.icon.name;
					}
				}
			}

			MultiEffect {
				id: iconEffect
				anchors.fill: iconImage
				source: iconImage
				colorization: 1.0
				colorizationColor: root.hasIconColor ? root.icon.color : Atmosphere.textColor
				brightness: 1.0
				visible: root.recolorIcon
			}
		}

		Column {
			id: textCol
			anchors.left: iconItem.right
			anchors.leftMargin: iconItem.visible ? 15 : 0
			anchors.right: parent.right
			anchors.rightMargin: 20
			anchors.verticalCenter: parent.verticalCenter
			spacing: subTextItem.visible ? 5 : 0

			CutieLabel {
				id: mainTextItem
				text: root.text
				font.pixelSize: 15
				width: textCol.width
				wrapMode: root.wrapMode
				elide: root.elide
				maximumLineCount: root.maximumLineCount
			}

			CutieLabel {
				id: subTextItem
				text: root.subText
				visible: root.subText !== ""
				font.pixelSize: 10
				width: textCol.width
				wrapMode: root.wrapMode
				elide: root.elide
				maximumLineCount: root.maximumLineCount
			}
		}
	}
}
