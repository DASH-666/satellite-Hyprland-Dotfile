import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Item {
    id: root

    required property var panelWindow
    property var customIcons: ({
        "TelegramDesktop": "",
        "easyeffects": "󰺢",
        "Wayscriber Screen Annotation": "󰃥",
    })

    function customIcon(item) {
        var title = item.title || ""

        if (customIcons[title] !== undefined)
            return customIcons[title]

        return ""
    }

    implicitWidth: trayRow.width + 2
    implicitHeight: 22

    TrayMenu {
        id: trayMenu
    }

    Row {
        id: trayRow

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        spacing: 7

        Repeater {
            model: SystemTray.items.values

            delegate: Item {
                required property var modelData

                width: 15
                height: 20

                Text {
                    anchors.centerIn: parent

                    visible: root.customIcon(modelData) !== ""

                    text: root.customIcon(modelData)

                    color: "#ffffff"

                    font.family: "FiraCode Nerd Font Propo"
                    font.pixelSize: 13
                    font.weight: 700

                    style: Text.Raised
                    styleColor: "#ffffff"
                }

                IconImage {
                    anchors.centerIn: parent

                    width: 14
                    height: 14

                    visible: root.customIcon(modelData) === ""

                    source: modelData.icon

                    asynchronous: true
                    mipmap: true
                }

                MouseArea {
                    id: mouseArea

                    anchors.fill: parent

                    acceptedButtons:
                        Qt.LeftButton |
                        Qt.RightButton |
                        Qt.MiddleButton

                    cursorShape: Qt.PointingHandCursor

                    onClicked: function(mouse) {
                        if (mouse.button === Qt.LeftButton) {
                            modelData.activate()
                            return
                        }

                        if (mouse.button === Qt.MiddleButton) {
                            modelData.secondaryActivate()
                            return
                        }

                        if (mouse.button === Qt.RightButton) {
                            if (modelData.hasMenu) {
                                trayMenu.openFor(
                                    modelData,
                                    root.panelWindow,
                                    mouseArea
                                )
                            } else {
                                modelData.secondaryActivate()
                            }
                        }
                    }

                    onWheel: function(wheel) {
                        modelData.scroll(
                            wheel.angleDelta.y,
                            wheel.angleDelta.x !== 0
                        )
                    }
                }
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.leftMargin: 0
        anchors.rightMargin: 0

        height: 1

        color: "#ffffffff"
    }
}
