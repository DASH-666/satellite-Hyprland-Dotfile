import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property var targetScreen: null

    property bool menuVisible: false
    property bool windowVisible: false

    property int displayedYear: 0
    property int displayedMonth: 0
    property int selectedButton: -1

    property string localTime: "--:--:--"
    property string utcTime: "--:--:--"
    property string timeZoneName: "LOCAL"
    property string timeZoneOffset: "UTC+00:00"

    readonly property int menuWidth: 340

    function updateCalendarDate() {
        displayedYear = clock.date.getFullYear()
        displayedMonth = clock.date.getMonth()
    }

    function toggle() {
        if (menuVisible)
            close()
        else
            open()
    }

    function open() {
        updateCalendarDate()
        updateTimeZone()

        selectedButton = -1
        windowVisible = true
        menuVisible = true

        Qt.callLater(function() {
            calendarArea.forceActiveFocus()
        })
    }

    function close() {
        menuVisible = false
        selectedButton = -1
    }

    function previousMonth() {
        if (displayedMonth === 0) {
            displayedMonth = 11
            displayedYear--
        } else {
            displayedMonth--
        }
    }

    function nextMonth() {
        if (displayedMonth === 11) {
            displayedMonth = 0
            displayedYear++
        } else {
            displayedMonth++
        }
    }

    function activateSelectedButton() {
        if (selectedButton === 0)
            previousMonth()
        else if (selectedButton === 1)
            nextMonth()
    }

    function daysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate()
    }

    function firstDayOfMonth(year, month) {
        return new Date(year, month, 1).getDay()
    }

    function dayNumber(index) {
        return index
            - firstDayOfMonth(displayedYear, displayedMonth)
            + 1
    }

    function isCurrentMonth(index) {
        var day = dayNumber(index)

        return day >= 1 &&
               day <= daysInMonth(
                   displayedYear,
                   displayedMonth
               )
    }

    function isToday(index) {
        if (!isCurrentMonth(index))
            return false

        var day = dayNumber(index)

        return day === clock.date.getDate() &&
               displayedMonth === clock.date.getMonth() &&
               displayedYear === clock.date.getFullYear()
    }

    function monthName() {
        return Qt.formatDateTime(
            new Date(
                displayedYear,
                displayedMonth,
                1
            ),
            "MMMM"
        )
    }

    function dateTitle() {
        return Qt.formatDateTime(
            clock.date,
            "dd/MM/yyyy"
        )
    }

    function updateTimeZone() {
        localTimeProcess.running = false
        localTimeProcess.running = true

        utcTimeProcess.running = false
        utcTimeProcess.running = true
    }

    SystemClock {
        id: clock

        precision: SystemClock.Seconds

        onDateChanged: {
            if (root.menuVisible)
                root.updateTimeZone()
        }
    }

    Timer {
        interval: 1000

        running: root.windowVisible

        repeat: true

        onTriggered: {
            root.updateTimeZone()
        }
    }

    Process {
        id: localTimeProcess

        command: [
            "date",
            "+%H:%M:%S|%Z|%:z"
        ]

        stdout: SplitParser {
            onRead: function(line) {
                var parts = line.trim().split("|")

                if (parts.length < 3)
                    return

                root.localTime = parts[0]
                root.timeZoneName = parts[1]
                root.timeZoneOffset =
                    "UTC" + parts[2]
            }
        }
    }

    Process {
        id: utcTimeProcess

        command: [
            "date",
            "-u",
            "+%H:%M:%S"
        ]

        stdout: SplitParser {
            onRead: function(line) {
                root.utcTime = line.trim()
            }
        }
    }

    PanelWindow {
        id: calendarWindow

        screen: root.targetScreen

        visible: root.windowVisible

        focusable: root.windowVisible

        WlrLayershell.keyboardFocus:
            root.windowVisible
                ? WlrKeyboardFocus.Exclusive
                : WlrKeyboardFocus.None

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        color: "#00000000"

        exclusionMode: ExclusionMode.Ignore

        MouseArea {
            id: backgroundArea

            anchors.fill: parent

            z: 0

            acceptedButtons: Qt.LeftButton

            cursorShape: Qt.ArrowCursor

            onClicked: {
                root.close()
            }
        }

        Item {
            id: calendarArea

            width: root.menuWidth
            height: calendarContainer.height

            anchors.horizontalCenter:
                parent.horizontalCenter

            z: 1

            y: root.menuVisible
                ? (parent.height - height) / 2
                : -height

            focus: root.menuVisible

            Behavior on y {
                NumberAnimation {
                    id: calendarAnimation

                    duration: 300

                    easing.type: Easing.OutCubic
                }
            }

            onYChanged: {
                if (!root.menuVisible &&
                    !calendarAnimation.running &&
                    y <= -height + 1) {

                    root.windowVisible = false
                }
            }

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Escape) {
                    root.close()
                    event.accepted = true
                    return
                }

                if (event.key === Qt.Key_Left ||
                    event.key === Qt.Key_H ||
                    event.key === Qt.Key_Up ||
                    event.key === Qt.Key_K) {

                    root.previousMonth()
                    event.accepted = true
                    return
                }

                if (event.key === Qt.Key_Right ||
                    event.key === Qt.Key_L ||
                    event.key === Qt.Key_Down ||
                    event.key === Qt.Key_J) {

                    root.nextMonth()
                    event.accepted = true
                    return
                }

                if (event.key === Qt.Key_Tab) {
                    if (
                        event.modifiers
                        & Qt.ShiftModifier
                    ) {
                        root.selectedButton =
                            root.selectedButton <= 0
                            ? 1
                            : 0
                    } else {
                        root.selectedButton =
                            root.selectedButton === 1
                            ? 0
                            : 1
                    }

                    event.accepted = true
                    return
                }

                if (event.key === Qt.Key_Return ||
                    event.key === Qt.Key_Enter) {

                    root.activateSelectedButton()

                    event.accepted = true
                    return
                }
            }

            Rectangle {
                id: calendarContainer

                width: root.menuWidth

                height:
                    calendarContent.implicitHeight
                    + 24

                anchors.horizontalCenter:
                    parent.horizontalCenter

                color: "#B3000000"

                // BORDER اصلی منو
                border.width: 1
                border.color: "#ffffffff"

                radius: 0

                ColumnLayout {
                    id: calendarContent

                    width: parent.width - 24

                    anchors.horizontalCenter:
                        parent.horizontalCenter

                    anchors.top:
                        parent.top

                    anchors.topMargin: 12

                    spacing: 10

                    // TIME ZONE
                    ColumnLayout {
                        Layout.fillWidth: true

                        spacing: 5

                        // LOCAL TIME
                        RowLayout {
                            Layout.fillWidth: true

                            spacing: 10

                            ColumnLayout {
                                Layout.fillWidth: true

                                spacing: 0

                                Text {
                                    text: "LOCAL"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 9
                                    font.weight: 600

                                    color: "#99ffffff"
                                }

                                Text {
                                    text: root.localTime

                                    font.family: "OCRA"

                                    font.pixelSize: 17
                                    font.weight: 700

                                    color: "#ffffff"
                                }
                            }

                            ColumnLayout {
                                Layout.alignment:
                                    Qt.AlignRight

                                spacing: 0

                                Text {
                                    Layout.alignment:
                                        Qt.AlignRight

                                    text:
                                        root.timeZoneName

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 10
                                    font.weight: 600

                                    color: "#ffffff"
                                }

                                Text {
                                    Layout.alignment:
                                        Qt.AlignRight

                                    text:
                                        root.timeZoneOffset

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 9
                                    font.weight: 500

                                    color: "#99ffffff"
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true

                            height: 1

                            color: "#66ffffff"
                        }

                        // UTC TIME
                        RowLayout {
                            Layout.fillWidth: true

                            spacing: 10

                            ColumnLayout {
                                Layout.fillWidth: true

                                spacing: 0

                                Text {
                                    text: "UTC"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 9
                                    font.weight: 600

                                    color: "#99ffffff"
                                }

                                Text {
                                    text: root.utcTime

                                    font.family: "OCRA"

                                    font.pixelSize: 17
                                    font.weight: 700

                                    color: "#ffffff"
                                }
                            }

                            Text {
                                Layout.alignment:
                                    Qt.AlignRight

                                text: "UNIVERSAL TIME"

                                font.family:
                                    "FiraCode Nerd Font Propo"

                                font.pixelSize: 9
                                font.weight: 500

                                color: "#99ffffff"
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true

                        height: 1

                        color: "#66ffffff"
                    }

                    // CALENDAR HEADER
                    RowLayout {
                        Layout.fillWidth: true

                        spacing: 0

                        // LEFT: MONTH
                        Item {
                            Layout.fillWidth: true

                            Layout.preferredWidth: 110

                            Layout.alignment:
                                Qt.AlignVCenter

                            Text {
                                anchors.left: parent.left

                                anchors.verticalCenter:
                                    parent.verticalCenter

                                text: root.monthName()

                                font.family:
                                    "FiraCode Nerd Font Propo"

                                font.pixelSize: 16
                                font.weight: 600

                                color: "#ffffff"
                            }
                        }

                        // CENTER: MONTH BUTTONS
                        Row {
                            Layout.preferredWidth: 66

                            Layout.alignment:
                                Qt.AlignHCenter |
                                Qt.AlignVCenter

                            spacing: 6

                            CalendarButton {
                                glyph: "‹"

                                selected:
                                    root.selectedButton === 0

                                onClicked: {
                                    root.previousMonth()
                                }
                            }

                            CalendarButton {
                                glyph: "›"

                                selected:
                                    root.selectedButton === 1

                                onClicked: {
                                    root.nextMonth()
                                }
                            }
                        }

                        // RIGHT: FULL NUMERIC DATE
                        Item {
                            Layout.fillWidth: true

                            Layout.preferredWidth: 110

                            Layout.alignment:
                                Qt.AlignVCenter

                            Text {
                                anchors.right:
                                    parent.right

                                anchors.verticalCenter:
                                    parent.verticalCenter

                                text: root.dateTitle()

                                font.family: "OCRA"

                                font.pixelSize: 13
                                font.weight: 700

                                color: "#ffffff"

                                horizontalAlignment:
                                    Text.AlignRight
                            }
                        }
                    }

                    // WEEKDAYS
                    GridLayout {
                        Layout.fillWidth: true

                        columns: 7

                        rowSpacing: 0
                        columnSpacing: 0

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

                            delegate: Item {
                                Layout.fillWidth: true

                                Layout.preferredHeight: 20

                                Text {
                                    anchors.centerIn: parent

                                    text: modelData

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 9
                                    font.weight: 600

                                    color: "#99ffffff"
                                }
                            }
                        }
                    }

                    // DAYS
                    Item {
                        Layout.fillWidth: true

                        Layout.preferredHeight:
                            6 * 28 + 8

                        // فقط خطوط داخلی جدول
                        Item {
                            id: daysGrid

                            anchors {
                                left: parent.left
                                right: parent.right
                                top: parent.top
                                bottom: parent.bottom

                                leftMargin: 5
                                rightMargin: 5

                                topMargin: 4
                                bottomMargin: 4
                            }

                            // خطوط عمودی داخلی
                            Repeater {
                                model: 6

                                Rectangle {
                                    x: daysGrid.width
                                        * (index + 1) / 7

                                    y: 0

                                    width: 1
                                    height: daysGrid.height

                                    color: "#33ffffff"
                                }
                            }

                            // خطوط افقی داخلی
                            Repeater {
                                model: 5

                                Rectangle {
                                    x: 0

                                    y: daysGrid.height
                                        * (index + 1) / 6

                                    width: daysGrid.width
                                    height: 1

                                    color: "#33ffffff"
                                }
                            }

                            GridLayout {
                                anchors.fill: parent

                                columns: 7

                                rowSpacing: 0
                                columnSpacing: 0

                                Repeater {
                                    model: 42

                                    delegate: Item {
                                        Layout.fillWidth: true

                                        Layout.preferredHeight: 28

                                        Text {
                                            anchors.centerIn:
                                                parent

                                            visible:
                                                root.isCurrentMonth(
                                                    index
                                                )

                                            text:
                                                root.dayNumber(
                                                    index
                                                )

                                            font.family: "OCRA"

                                            font.pixelSize: 12
                                            font.weight: 700

                                            color:
                                                root.isToday(index)
                                                ? "#ff0000"
                                                : "#ffffff"
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

    Timer {
        id: calendarAnimationTimer

        interval: 300

        onTriggered: {
            if (!root.menuVisible)
                root.windowVisible = false
        }
    }

    component CalendarButton: Item {
        id: button

        property string glyph: ""
        property bool selected: false

        signal clicked()

        width: 30
        height: 24

        Rectangle {
            anchors.fill: parent

            color: "#ffffff"

            border.width: 1
            border.color: "#ffffff"

            radius: 0
        }

        Text {
            anchors.centerIn: parent

            text: button.glyph

            font.family:
                "FiraCode Nerd Font Propo"

            font.pixelSize: 16
            font.weight: 700

            color: "#000000"
        }

        MouseArea {
            id: buttonMouseArea

            anchors.fill: parent

            acceptedButtons: Qt.LeftButton

            cursorShape:
                Qt.PointingHandCursor

            onClicked: {
                button.clicked()
            }
        }
    }

    onMenuVisibleChanged: {
        if (menuVisible) {
            windowVisible = true

            updateCalendarDate()
            updateTimeZone()

            Qt.callLater(function() {
                calendarArea.forceActiveFocus()
            })
        } else {
            calendarAnimationTimer.restart()
        }
    }
}
