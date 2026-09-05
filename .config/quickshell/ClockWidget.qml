// CloclWidget.qml
import Quickshell
import QtQuick

Row {
    BarIconStyle {
        text: " "
    }

    BarNumberStyle {
        text: Qt.formatDateTime(clock.date, "hh:mm:ss")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
