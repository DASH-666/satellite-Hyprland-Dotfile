import QtQuick

Item {
    id: root

    signal clicked()

    implicitWidth: powerIcon.implicitWidth
    implicitHeight: powerIcon.implicitHeight

    BarIconStyle {
        id: powerIcon

        anchors.centerIn: parent

        text: "⏻"
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            root.clicked()
        }
    }
}
