import QtQuick

Item {
    id: root

    implicitWidth: calculatorIcon.implicitWidth
    implicitHeight: calculatorIcon.implicitHeight

    BarTextStyle {
        id: calculatorIcon

        anchors.centerIn: parent

        text: ""
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton

        cursorShape: Qt.PointingHandCursor

        onClicked: {
            calculatorMenu.toggle()
        }
    }

    CalculatorMenu {
        id: calculatorMenu
    }
}
