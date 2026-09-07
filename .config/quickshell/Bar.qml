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

                SystemMonitorWidget {}
                TrayWidget {
                    panelWindow: panelWindow
                }
            }
        }
    }
}
