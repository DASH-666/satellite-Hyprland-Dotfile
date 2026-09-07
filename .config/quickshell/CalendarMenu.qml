import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property var targetScreen: null
    property bool menuVisible: false
    property bool windowVisible: false

    property int displayedYear: clock.date.getFullYear()
    property int displayedMonth: clock.date.getMonth()

    implicitWidth: 0
    implicitHeight: 0

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    function toggle() {
        if (root.menuVisible) {
            root.close()
            return
        }

        root.displayedYear = clock.date.getFullYear()
        root.displayedMonth = clock.date.getMonth()

        root.windowVisible = true
        root.menuVisible = true
    }

    function close() {
        root.menuVisible = false
    }

    function previousMonth() {
        if (root.displayedMonth === 0) {
            root.displayedMonth = 11
            root.displayedYear--
        } else {
            root.displayedMonth--
        }
    }

    function nextMonth() {
        if (root.displayedMonth === 11) {
            root.displayedMonth = 0
            root.displayedYear++
        } else {
            root.displayedMonth++
        }
    }

    function daysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate()
    }

    function firstDayOfMonth(year, month) {
        return new Date(year, month, 1).getDay()
    }

    function dayNumber(index) {
        var firstDay = root.firstDayOfMonth(
            root.displayedYear,
            root.displayedMonth
        )

        var daysCurrent = root.daysInMonth(
            root.displayedYear,
            root.displayedMonth
        )

        var previousMonth =
            root.displayedMonth === 0
                ? 11
                : root.displayedMonth - 1

        var previousYear =
            root.displayedMonth === 0
                ? root.displayedYear - 1
                : root.displayedYear

        var daysPrevious = root.daysInMonth(
            previousYear,
            previousMonth
        )

        if (index < firstDay)
            return daysPrevious - firstDay + index + 1

        if (index >= firstDay + daysCurrent)
            return index - firstDay - daysCurrent + 1

        return index - firstDay + 1
    }

    function isCurrentMonth(index) {
        var firstDay = root.firstDayOfMonth(
            root.displayedYear,
            root.displayedMonth
        )

        var daysCurrent = root.daysInMonth(
            root.displayedYear,
            root.displayedMonth
        )

        return (
            index >= firstDay
            && index < firstDay + daysCurrent
        )
    }

    function isToday(index) {
        return (
            root.isCurrentMonth(index)
            && root.dayNumber(index) === clock.date.getDate()
            && root.displayedMonth === clock.date.getMonth()
            && root.displayedYear === clock.date.getFullYear()
        )
    }

    function shortMonthName() {
        return Qt.formatDateTime(
            new Date(
                root.displayedYear,
                root.displayedMonth,
                1
            ),
            "MMM"
        )
    }

    function dateTitle() {
        var day = clock.date.getDate()
        var month = clock.date.getMonth() + 1
        var year = clock.date.getFullYear()

        return (
            String(day).padStart(2, "0")
            + "/"
            + String(month).padStart(2, "0")
            + "/"
            + year
        )
    }

    PanelWindow {
        id: calendarWindow

        screen: root.targetScreen

        visible: root.windowVisible

        color: "#00000000"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        exclusionMode: ExclusionMode.Ignore

        Item {
            anchors.fill: parent

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton

                onClicked: {
                    if (
                        mouseX < calendarContainer.x
                        || mouseX > calendarContainer.x + calendarContainer.width
                        || mouseY < calendarContainer.y
                        || mouseY > calendarContainer.y + calendarContainer.height
                    ) {
                        root.close()
                    }
                }
            }

            Item {
                id: calendarContainer

                width: 340
                height: calendarContent.implicitHeight + 24

                anchors.horizontalCenter: parent.horizontalCenter

                y: root.menuVisible
                    ? (parent.height - height) / 2
                    : -height

                Behavior on y {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic

                        onRunningChanged: {
                            if (
                                !running
                                && !root.menuVisible
                            ) {
                                root.windowVisible = false
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent

                    color: "#B3000000"

                    border.width: 1
                    border.color: "#ffffff"

                    radius: 0
                }

                Item {
                    id: calendarContent

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: 12
                    }

                    implicitHeight: mainLayout.implicitHeight

                    ColumnLayout {
                        id: mainLayout

                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                        }

                        spacing: 10

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                Layout.preferredWidth: 45

                                text: root.shortMonthName()

                                font.family: "OCRA"
                                font.pixelSize: 14
                                font.weight: 700

                                color: "#ffffff"
                            }

                            Item {
                                Layout.fillWidth: true

                                implicitHeight: 26

                                Text {
                                    anchors.centerIn: parent

                                    text: root.dateTitle()

                                    font.family: "OCRA"
                                    font.pixelSize: 14
                                    font.weight: 700

                                    color: "#ffffff"
                                }
                            }

                            Row {
                                spacing: 6

                                CalendarButton {
                                    text: "‹"

                                    onClicked: {
                                        root.previousMonth()
                                    }
                                }

                                CalendarButton {
                                    text: "›"

                                    onClicked: {
                                        root.nextMonth()
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true

                            height: 1

                            color: "#ffffff"
                        }

                        GridLayout {
                            Layout.fillWidth: true

                            columns: 7

                            columnSpacing: 0
                            rowSpacing: 6

                            Repeater {
                                model: [
                                    "SUN",
                                    "MON",
                                    "TUE",
                                    "WED",
                                    "THU",
                                    "FRI",
                                    "SAT"
                                ]

                                Text {
                                    Layout.fillWidth: true

                                    horizontalAlignment:
                                        Text.AlignHCenter

                                    text: modelData

                                    font.family: "OCRA"
                                    font.pixelSize: 9
                                    font.weight: 700

                                    color: "#ffffff"
                                }
                            }

                            Repeater {
                                model: 42

                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 30

                                    Text {
                                        anchors.centerIn: parent

                                        text: root.dayNumber(index)

                                        font.family: "OCRA"
                                        font.pixelSize: 11
                                        font.weight: 700

                                        color: {
                                            if (root.isToday(index))
                                                return "#ff0000"

                                            if (root.isCurrentMonth(index))
                                                return "#ffffff"

                                            return "#66ffffff"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    component CalendarButton: Item {
        id: button

        property string text: ""

        signal clicked()

        implicitWidth: 28
        implicitHeight: 26

        Rectangle {
            anchors.fill: parent

            color: "#00000000"

            border.width: 1
            border.color: "#ffffff"

            radius: 0
        }

        Text {
            anchors.centerIn: parent

            text: button.text

            font.family: "OCRA"
            font.pixelSize: 12
            font.weight: 700

            color: "#ffffff"
        }

        MouseArea {
            anchors.fill: parent

            cursorShape: Qt.PointingHandCursor

            onClicked: {
                button.clicked()
            }
        }
    }
}
