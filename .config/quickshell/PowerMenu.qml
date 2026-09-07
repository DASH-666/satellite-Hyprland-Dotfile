import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property var targetScreen: null
    property bool menuVisible: false
    property bool menuWindowVisible: false

    implicitWidth: powerWidget.implicitWidth
    implicitHeight: powerWidget.implicitHeight

    function toggle() {
        if (menuVisible) {
            menuVisible = false
        } else {
            menuWindowVisible = true
            menuVisible = true
        }
    }

    function close() {
        menuVisible = false
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

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton

                onClicked: {
                    if (
                        mouseX < menuContainer.x
                        || mouseX > menuContainer.x + menuContainer.width
                        || mouseY < menuContainer.y
                        || mouseY > menuContainer.y + menuContainer.height
                    ) {
                        root.close()
                    }
                }
            }

            Item {
                id: menuContainer

                width: 320

                height: menuContent.implicitHeight + 24

                anchors.horizontalCenter: parent.horizontalCenter

                y: root.menuVisible
                    ? (parent.height - height) / 2
                    : -height

                Behavior on y {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic

                        onRunningChanged: {
                            if (!running && !root.menuVisible) {
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

                    implicitHeight: mainLayout.implicitHeight

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

                            font.family: "OCRA"
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

                            font.family: "OCRA"
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

                                onClicked: {
                                    performanceProcess.running = false
                                    performanceProcess.running = true
                                }
                            }

                            MenuButton {
                                Layout.fillWidth: true

                                icon: ""
                                label: "Schedutil"

                                onClicked: {
                                    schedutilProcess.running = false
                                    schedutilProcess.running = true
                                }
                            }

                            MenuButton {
                                Layout.fillWidth: true

                                icon: ""
                                label: "Powersave"

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

        signal clicked()

        implicitWidth: 70
        implicitHeight: buttonContent.implicitHeight + 16

        Rectangle {
            anchors.fill: parent

            color: "#00000000"

            border.width: 1
            border.color: "#ffffff"

            radius: 0
        }

        Column {
            id: buttonContent

            anchors.centerIn: parent

            spacing: 4

            Text {
                anchors.horizontalCenter: parent.horizontalCenter

                text: button.icon

                font.pixelSize: 18

                color: "#ffffff"
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter

                text: button.label

                font.family: "OCRA"
                font.pixelSize: 9

                color: "#ffffff"
            }
        }

        MouseArea {
            anchors.fill: parent

            cursorShape: Qt.PointingHandCursor

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
