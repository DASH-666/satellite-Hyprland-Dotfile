import Quickshell
import QtQuick

Item {
    id: root

    property var targetScreen: null

    implicitWidth: clockRow.implicitWidth
    implicitHeight: clockRow.implicitHeight

    Row {
        id: clockRow

        anchors.fill: parent

        BarTextStyle {
            text: " "
        }

        BarNumberStyle {
            text: Qt.formatDateTime(
                clock.date,
                "hh:mm:ss"
            )
        }
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton

        cursorShape: Qt.PointingHandCursor

        onClicked: {
            calendarMenu.toggle()
        }
    }

    CalendarMenu {
        id: calendarMenu

        targetScreen: root.targetScreen
    }
}
