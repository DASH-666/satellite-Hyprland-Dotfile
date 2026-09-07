// BarIconStyle.qml

import QtQuick

Item {
    id: root

    property alias text: iconText.text
    property color textColor: "#ffffff"
    property int fontSize: 12

    implicitWidth: iconText.implicitWidth
    implicitHeight: iconText.implicitHeight + 3

    Text {
        id: iconText

        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.horizontalCenter: parent.horizontalCenter

        font.family: "FiraCode Nerd Font Propo"
        font.pixelSize: root.fontSize
        font.weight: 700
        color: root.textColor

        style: Text.Raised
        styleColor: "#ffffff"
    }

    Rectangle {
        anchors.top: iconText.bottom
        anchors.topMargin: 2
        anchors.left: iconText.left
        anchors.leftMargin: -3
        anchors.right: iconText.right
        anchors.rightMargin: -3

        height: 1
        color: "#ffffffff"
    }
}
