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

            RowLayout {
                id: leftBar

                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
            }

            RowLayout {
                id: centerBar

                anchors.centerIn: parent
                spacing: 10

                PowerMenu {
                    //anchorWindow: panelWindow
                }
                LanguageWidget {}
                NetworkWidget {}
                MpdWidget {}
                WorkspacesWidget {}
                MprisWidget {}
                ClockWidget {
                    targetScreen: modelData
                }
                IdleInhibitorWidget {}
            }

            RowLayout {
                id: rightBar

                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter


            }
        }
    }
}
