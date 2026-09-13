// AppGroupWidget.qml

import QtQuick
import Quickshell

Item {
    id: root

    property string displayName: "BROWSER"
    property string icon: ""

    property var apps: []

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    function launchDefault() {
        if (
            !root.apps ||
            root.apps.length === 0
        )
            return

        var app = root.apps[0]

        if (!app || !app.command)
            return

        Quickshell.execDetached([
            "sh",
            "-c",
            app.command
        ])
    }

    Row {
        id: content

        spacing: 3

        BarIconStyle {
            text: root.icon
            textColor: "#ffffff"
        }

        BarTextStyle {
            text: root.displayName
            textColor: "#ffffff"
        }
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons:
            Qt.LeftButton |
            Qt.RightButton

        cursorShape:
            Qt.PointingHandCursor

        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                root.launchDefault()
                return
            }

            if (mouse.button === Qt.RightButton) {
                appGroupMenu.toggle()
                return
            }
        }
    }

    AppGroupMenu {
        id: appGroupMenu

        displayName: root.displayName
        apps: root.apps
    }
}
