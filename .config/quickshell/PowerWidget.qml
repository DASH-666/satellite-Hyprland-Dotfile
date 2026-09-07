import QtQuick

Item {
    id: root

    implicitWidth: powerIcon.implicitWidth
    implicitHeight: powerIcon.implicitHeight

    BarTextStyle {
        id: powerIcon

        anchors.centerIn: parent

        text: "⏻"
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            powerMenu.toggle()
        }
    }

    PowerMenu {
        id: powerMenu
    }
}
