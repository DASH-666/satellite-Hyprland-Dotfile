// Bar.qml

import Quickshell
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    readonly property int fontSize: 15

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panelWindow

            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            color: "#00000000"
            implicitHeight: 30

            // LEFT
            RowLayout {
                id: leftBar

                anchors.left: parent.left
                spacing: 10
                anchors.verticalCenter: parent.verticalCenter

                AppGroupWidget {
                    displayName: "browser"
                    icon: ""

                    apps: [
                        {
                            name: "Firefox",
                            command: "firefox-developer-edition"
                        },
                        {
                            name: "Chromium",
                            command: "chromium"
                        }
                    ]
                }
                AppGroupWidget {
                    displayName: "file"
                    icon: ""

                    apps: [
                        {
                            name: "thunar",
                            command: "thunar"
                        },
                        {
                            name: "superfile",
                            command: "ghostty -e spf"
                        }
                    ]
                }
                AppGroupWidget {
                    displayName: "terminal"
                    icon: ""

                    apps: [
                        {
                            name: "ghostty",
                            command: "ghostty"
                        },
                        {
                            name: "foot",
                            command: "foot"
                        }
                    ]
                }


            }

            // CENTER
            RowLayout {
                id: centerBar

                anchors.centerIn: parent
                spacing: 10
                anchors.verticalCenter: parent.verticalCenter

                PowerWidget {}
                LanguageWidget {}
                NetworkWidget {}
                CalculatorWidget {}
                WorkspacesWidget {}
                MprisWidget {}
                ClockWidget {}
                IdleInhibitorWidget {}
            }

            // RIGHT
            RowLayout {
                id: rightBar

                anchors.right: parent.right
                spacing: 10
                anchors.verticalCenter: parent.verticalCenter

                AudioWidget {}
                SystemMonitorWidget {}
                TrayWidget {
                    panelWindow: panelWindow
                }
            }
        }
    }
}
