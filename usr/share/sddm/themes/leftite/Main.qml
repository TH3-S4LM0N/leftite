import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import "Components"

Pane{
    id: root

    padding: config.ScreenPadding || root.padding

    LayoutMirroring.enabled: config.ForceRightToLeft == "true" ? true : Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

	//Settings of color of text, highlights and buttons:
    palette.button: "transparent"
    palette.highlight: config.ThemeColor
    palette.text: config.ThemeColor
    palette.buttonText: config.ThemeColor

	Rectangle
	{
		//Image background for input forms
		anchors.fill: parent
        Image 
        {
            source: "Assets/Card-Background/background.png"
            fillMode: config.ScaleImageCropped == "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
        }
           	
	}
	
	//Settings of general fonts:
    font.family: config.Font
    font.pointSize: config.FontSize !== "" ? config.FontSize : parseInt(height / 80)
    focus: true    

    RowLayout {
        anchors.fill: parent
        spacing: 0

        LoginForm {
            Layout.minimumHeight: parent.height
            Layout.maximumWidth: parent.width / 2.5
        }

		//Wallpaper side:
        Item {
            id: image
            Layout.fillWidth: true
            Layout.fillHeight: true
            Image {
                source: config.background || config.Background
                anchors.fill: parent
                asynchronous: true
                cache: true
                fillMode: config.ScaleImageCropped == "true" ? Image.PreserveAspectCrop : Image.PreserveAspectFit
                clip: true
                mipmap: true
            }
            MouseArea {
                anchors.fill: parent
                onClicked: parent.forceActiveFocus()
            }

        }
    }

}
