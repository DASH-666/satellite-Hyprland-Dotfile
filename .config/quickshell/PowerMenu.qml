import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property var targetScreen: null
    property bool menuVisible: false
    property bool menuWindowVisible: false

    property int selectedIndex: -1
    property bool keyboardNavigation: false

    implicitWidth: powerWidget.implicitWidth
    implicitHeight: powerWidget.implicitHeight

    function toggle() {
        if (menuVisible) {
            menuVisible = false
        } else {
            selectedIndex = -1
            keyboardNavigation = false

            menuWindowVisible = true
            menuVisible = true

            Qt.callLater(function() {
                menuArea.forceActiveFocus()
            })
        }
    }

    function close() {
        menuVisible = false
        keyboardNavigation = false
        selectedIndex = -1
    }

    function select(index) {
        if (index < 0 || index >= 7)
            return

        selectedIndex = index
        keyboardNavigation = true
    }

    function moveLeft() {
        if (!keyboardNavigation) {
            select(0)
            return
        }

        if (selectedIndex === 0)
            select(3)
        else if (selectedIndex === 1)
            select(0)
        else if (selectedIndex === 2)
            select(1)
        else if (selectedIndex === 3)
            select(2)
        else if (selectedIndex === 4)
            select(6)
        else if (selectedIndex === 5)
            select(4)
        else if (selectedIndex === 6)
            select(5)
    }

    function moveRight() {
        if (!keyboardNavigation) {
            select(0)
            return
        }

        if (selectedIndex === 0)
            select(1)
        else if (selectedIndex === 1)
            select(2)
        else if (selectedIndex === 2)
            select(3)
        else if (selectedIndex === 3)
            select(0)
        else if (selectedIndex === 4)
            select(5)
        else if (selectedIndex === 5)
            select(6)
        else if (selectedIndex === 6)
            select(4)
    }

    function moveUp() {
        if (!keyboardNavigation) {
            select(0)
            return
        }

        if (selectedIndex >= 0 && selectedIndex <= 3) {
            select(4 + Math.min(selectedIndex, 2))
            return
        }

        if (selectedIndex === 4)
            select(0)
        else if (selectedIndex === 5)
            select(1)
        else if (selectedIndex === 6)
            select(2)
    }

    function moveDown() {
        if (!keyboardNavigation) {
            select(0)
            return
        }

        if (selectedIndex >= 0 && selectedIndex <= 2) {
            select(4 + selectedIndex)
            return
        }

        if (selectedIndex === 3)
            select(6)

        else if (selectedIndex === 4)
            select(0)

        else if (selectedIndex === 5)
            select(1)

        else if (selectedIndex === 6)
            select(2)
    }

    function activateSelected() {
        switch (selectedIndex) {
        case 0:
            root.close()

            shutdownProcess.running = false
            shutdownProcess.running = true
            break

        case 1:
            root.close()

            rebootProcess.running = false
            rebootProcess.running = true
            break

        case 2:
            root.close()

            suspendProcess.running = false
            suspendProcess.running = true
            break

        case 3:
            root.close()

            logoutProcess.running = false
            logoutProcess.running = true
            break

        case 4:
            performanceProcess.running = false
            performanceProcess.running = true
            break

        case 5:
            schedutilProcess.running = false
            schedutilProcess.running = true
            break

        case 6:
            powersaveProcess.running = false
            powersaveProcess.running = true
            break
        }
    }

    PowerWidget {
        id: powerWidget

        anchors.centerIn: parent

        onClicked: {
            root.toggle()
        }
    }

    PanelWindow {
        id: menuWindow

        screen: root.targetScreen

        visible: root.menuWindowVisible

        focusable: root.menuWindowVisible

        WlrLayershell.keyboardFocus:
            root.menuWindowVisible
                ? WlrKeyboardFocus.Exclusive
                : WlrKeyboardFocus.None

        color: "#00000000"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        exclusionMode: ExclusionMode.Ignore

        Item {
            id: menuArea

            anchors.fill: parent

            focus: root.menuVisible

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Escape) {
                    root.close()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Left
                    || event.key === Qt.Key_H
                ) {
                    root.moveLeft()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Right
                    || event.key === Qt.Key_L
                ) {
                    root.moveRight()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Up
                    || event.key === Qt.Key_K
                ) {
                    root.moveUp()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Down
                    || event.key === Qt.Key_J
                ) {
                    root.moveDown()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Return
                    || event.key === Qt.Key_Enter
                ) {
                    if (root.keyboardNavigation) {
                        root.activateSelected()
                        event.accepted = true
                    }

                    return
                }
            }

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton

                onClicked: {
                    if (
                        mouseX < menuContainer.x
                        || mouseX >
                            menuContainer.x
                            + menuContainer.width
                        || mouseY <
                            menuContainer.y
                        || mouseY >
                            menuContainer.y
                            + menuContainer.height
                    ) {
                        root.close()
                    }
                }
            }

            Item {
                id: menuContainer

                width: 320

                height:
                    menuContent.implicitHeight
                    + 24

                anchors.horizontalCenter:
                    parent.horizontalCenter

                y: root.menuVisible
                    ? (parent.height - height) / 2
                    : -height

                Behavior on y {
                    NumberAnimation {
                        duration: 300

                        easing.type:
                            Easing.OutCubic

                        onRunningChanged: {
                            if (
                                !running
                                && !root.menuVisible
                            ) {
                                root.menuWindowVisible = false
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
                    id: menuContent

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: 12
                    }

                    implicitHeight:
                        mainLayout.implicitHeight

                    ColumnLayout {
                        id: mainLayout

                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                        }

                        spacing: 10

                        Text {
                            text: "POWER"

                            font.family: "FiraCode Nerd Font Propo"
                            font.pixelSize: 13
                            font.weight: 700

                            color: "#ffffff"
                        }

                        Rectangle {
                            Layout.fillWidth: true

                            height: 1

                            color: "#ffffff"
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            spacing: 8

                            MenuButton {
                                Layout.fillWidth: true

                                icon: "⏻"
                                label: "Shutdown"

                                selected:
                                    root.keyboardNavigation
                                    && root.selectedIndex === 0

                                onClicked: {
                                    root.close()

                                    shutdownProcess.running = false
                                    shutdownProcess.running = true
                                }
                            }

                            MenuButton {
                                Layout.fillWidth: true

                                icon: "󰜉"
                                label: "Restart"

                                selected:
                                    root.keyboardNavigation
                                    && root.selectedIndex === 1

                                onClicked: {
                                    root.close()

                                    rebootProcess.running = false
                                    rebootProcess.running = true
                                }
                            }

                            MenuButton {
                                Layout.fillWidth: true

                                icon: "󰤄"
                                label: "Suspend"

                                selected:
                                    root.keyboardNavigation
                                    && root.selectedIndex === 2

                                onClicked: {
                                    root.close()

                                    suspendProcess.running = false
                                    suspendProcess.running = true
                                }
                            }

                            MenuButton {
                                Layout.fillWidth: true

                                icon: "󰗼"
                                label: "Logout"

                                selected:
                                    root.keyboardNavigation
                                    && root.selectedIndex === 3

                                onClicked: {
                                    root.close()

                                    logoutProcess.running = false
                                    logoutProcess.running = true
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                            height: 6
                        }

                        Text {
                            text: "CPU POWER MODE"

                            font.family: "FiraCode Nerd Font Propo"
                            font.pixelSize: 13
                            font.weight: 700

                            color: "#ffffff"
                        }

                        Rectangle {
                            Layout.fillWidth: true

                            height: 1

                            color: "#ffffff"
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            spacing: 8

                            MenuButton {
                                Layout.fillWidth: true

                                icon: ""
                                label: "Performance"

                                selected:
                                    root.keyboardNavigation
                                    && root.selectedIndex === 4

                                onClicked: {
                                    performanceProcess.running = false
                                    performanceProcess.running = true
                                }
                            }

                            MenuButton {
                                Layout.fillWidth: true

                                icon: ""
                                label: "Schedutil"

                                selected:
                                    root.keyboardNavigation
                                    && root.selectedIndex === 5

                                onClicked: {
                                    schedutilProcess.running = false
                                    schedutilProcess.running = true
                                }
                            }

                            MenuButton {
                                Layout.fillWidth: true

                                icon: ""
                                label: "Powersave"

                                selected:
                                    root.keyboardNavigation
                                    && root.selectedIndex === 6

                                onClicked: {
                                    powersaveProcess.running = false
                                    powersaveProcess.running = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    component MenuButton: Item {
        id: button

        property string icon: ""
        property string label: ""
        property bool selected: false

        signal clicked()

        implicitWidth: 70
        implicitHeight:
            buttonContent.implicitHeight + 16

        Rectangle {
            anchors.fill: parent

            color: "#00000000"

            border.width: 1

            border.color:
                button.selected
                ? "#ff0000"
                : "#ffffff"

            radius: 0
        }

        Column {
            id: buttonContent

            anchors.centerIn: parent

            spacing: 4

            Text {
                anchors.horizontalCenter:
                    parent.horizontalCenter

                text: button.icon

                font.family:
                    "FiraCode Nerd Font Propo"

                font.pixelSize: 18

                color: "#ffffff"
            }

            Text {
                anchors.horizontalCenter:
                    parent.horizontalCenter

                text: button.label

                font.family: "FiraCode Nerd Font Propo"
                font.pixelSize: 9

                color: "#ffffff"
            }
        }

        MouseArea {
            anchors.fill: parent

            cursorShape:
                Qt.PointingHandCursor

            onClicked: {
                button.clicked()
            }
        }
    }

    Process {
        id: shutdownProcess

        command: [
            "systemctl",
            "poweroff"
        ]
    }

    Process {
        id: rebootProcess

        command: [
            "systemctl",
            "reboot"
        ]
    }

    Process {
        id: suspendProcess

        command: [
            "systemctl",
            "suspend"
        ]
    }

    Process {
        id: logoutProcess

        command: [
            "hyprctl",
            "dispatch",
            "exit"
        ]
    }

    Process {
        id: performanceProcess

        command: [
            "sh",
            "-c",
            "sudo cpupower frequency-set -g performance && notify-send ' performance power mode'"
        ]
    }

    Process {
        id: schedutilProcess

        command: [
            "sh",
            "-c",
            "sudo cpupower frequency-set -g schedutil && notify-send ' schedutil power mode'"
        ]
    }

    Process {
        id: powersaveProcess

        command: [
            "sh",
            "-c",
            "sudo cpupower frequency-set -g powersave && notify-send ' powersave power mode'"
        ]
    }
}
