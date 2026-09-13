// TrayWidget.qml

import QtQuick
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

        return customIcons[title] !== undefined
            ? customIcons[title]
            : ""
    }

    implicitWidth: trayRow.implicitWidth
    implicitHeight: 20

    TrayMenu {
        id: trayMenu
    }

    Row {
        id: trayRow

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        spacing: 8

        Repeater {
            model: SystemTray.items.values

            delegate: Item {
                required property var modelData

                readonly property string customIconText:
                    root.customIcon(modelData)

                implicitWidth:
                    customIconText !== ""
                    ? barIcon.implicitWidth
                    : 14

                implicitHeight: 20

                BarIconStyle {
                    id: barIcon

                    anchors.centerIn: parent

                    text: parent.customIconText
                    textColor: "#ffffff"

                    visible: parent.customIconText !== ""
                }

                IconImage {
                    anchors.centerIn: parent

                    width: 14
                    height: 14

                    source: modelData.icon

                    visible: parent.customIconText === ""

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
}
