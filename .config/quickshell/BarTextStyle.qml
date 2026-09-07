// BarTextStyle.qml

import QtQuick

Item {
    id: root

    property alias text: barText.text
    property color textColor: "#ffffff"
    property int fontSize: 12

    implicitWidth: barText.implicitWidth
    implicitHeight: barText.implicitHeight + 4

    Text {
        id: barText

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
        anchors.top: barText.bottom
        anchors.topMargin: 2
        anchors.left: barText.left
        anchors.leftMargin: -3
        anchors.right: barText.right
        anchors.rightMargin: -3

        height: 1
        color: "#ffffffff"
    }
}
