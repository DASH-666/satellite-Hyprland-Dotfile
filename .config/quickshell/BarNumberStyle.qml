// BarNumberStyle.qml

import QtQuick

Item {
    id: root

    property alias text: numberText.text
    property color textColor: "#ffffff"

    implicitWidth: numberText.implicitWidth
    implicitHeight: numberText.implicitHeight + 3

    Text {
        id: numberText

        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        font.family: "OCRA"
        font.pixelSize: 12
        font.weight: 700
        color: root.textColor

        style: Text.Raised
        styleColor: "#ffffff"
    }

    Rectangle {
        anchors.top: numberText.bottom
        anchors.topMargin: 2
        anchors.left: numberText.left
        anchors.leftMargin: -3
        anchors.right: numberText.right
        anchors.rightMargin: -3

        height: 1
        color: "#ffffffff"
    }
}
