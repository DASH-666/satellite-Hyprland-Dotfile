// AppGroupMenu.qml

import Quickshell
import Quickshell.Wayland
import QtQuick

Item {
    id: root

    property string displayName: ""
    property var apps: []

    property bool menuVisible: false
    property bool menuWindowVisible: false

    property int selectedIndex: -1
    property bool keyboardNavigation: false

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
        if (
            index < 0 ||
            index >= root.apps.length
        )
            return

        selectedIndex = index
        keyboardNavigation = true
    }

    function movePrevious() {
        if (!keyboardNavigation) {
            select(0)
            return
        }

        if (root.apps.length === 0)
            return

        if (selectedIndex <= 0) {
            select(root.apps.length - 1)
        } else {
            select(selectedIndex - 1)
        }
    }

    function moveNext() {
        if (!keyboardNavigation) {
            select(0)
            return
        }

        if (root.apps.length === 0)
            return

        if (
            selectedIndex < 0 ||
            selectedIndex >= root.apps.length - 1
        ) {
            select(0)
        } else {
            select(selectedIndex + 1)
        }
    }

    function activateSelected() {
        if (
            !root.keyboardNavigation ||
            root.selectedIndex < 0 ||
            root.selectedIndex >= root.apps.length
        )
            return

        var app =
            root.apps[root.selectedIndex]

        if (!app || !app.command)
            return

        root.close()

        Quickshell.execDetached([
            "sh",
            "-c",
            app.command
        ])
    }

    PanelWindow {
        id: menuWindow

        screen:
            root.QsWindow.window
            ? root.QsWindow.window.screen
            : null

        visible:
            root.menuWindowVisible

        focusable:
            root.menuWindowVisible

        WlrLayershell.keyboardFocus:
            root.menuWindowVisible
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

        color:
            "#00000000"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        exclusionMode:
            ExclusionMode.Ignore

        Item {
            id: menuArea

            anchors.fill: parent

            focus:
                root.menuVisible

            Keys.onPressed: function(event) {
                if (
                    event.key ===
                    Qt.Key_Escape
                ) {
                    root.close()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Left
                    || event.key === Qt.Key_Up
                    || event.key === Qt.Key_H
                    || event.key === Qt.Key_K
                ) {
                    root.movePrevious()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Right
                    || event.key === Qt.Key_Down
                    || event.key === Qt.Key_L
                    || event.key === Qt.Key_J
                ) {
                    root.moveNext()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Return
                    || event.key === Qt.Key_Enter
                    || event.key === Qt.Key_Space
                ) {
                    if (
                        root.keyboardNavigation
                    ) {
                        root.activateSelected()
                        event.accepted = true
                    }

                    return
                }
            }

            MouseArea {
                anchors.fill: parent

                acceptedButtons:
                    Qt.LeftButton

                onClicked: {
                    if (
                        mouseX < menuContainer.x
                        || mouseX >
                            menuContainer.x +
                            menuContainer.width
                        || mouseY <
                            menuContainer.y
                        || mouseY >
                            menuContainer.y +
                            menuContainer.height
                    ) {
                        root.close()
                    }
                }
            }

            Item {
                id: menuContainer

                width: 320

                height:
                    menuContent.implicitHeight +
                    24

                anchors.horizontalCenter:
                    parent.horizontalCenter

                y:
                    root.menuVisible
                    ? (
                        parent.height -
                        height
                    ) / 2
                    : -height

                Behavior on y {
                    NumberAnimation {
                        duration: 300

                        easing.type:
                            Easing.OutCubic

                        onRunningChanged: {
                            if (
                                !running &&
                                !root.menuVisible
                            ) {
                                root.menuWindowVisible =
                                    false
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent

                    color:
                        "#B3000000"

                    border.width: 1

                    border.color:
                        "#ffffff"

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

                    Column {
                        id: mainLayout

                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                        }

                        spacing: 10

                        Text {
                            text:
                                root.displayName

                            font.family:
                                "FiraCode Nerd Font Propo"

                            font.pixelSize: 13
                            font.weight: 700

                            color:
                                "#ffffff"
                        }

                        Rectangle {
                            width: parent.width

                            height: 1

                            color:
                                "#ffffff"
                        }

                        Column {
                            width: parent.width

                            spacing: 8

                            Repeater {
                                model: root.apps

                                delegate: Item {
                                    required property var modelData
                                    required property int index

                                    width: mainLayout.width

                                    height: 40

                                    Rectangle {
                                        anchors.fill: parent

                                        color:
                                            root.keyboardNavigation &&
                                            root.selectedIndex === index
                                            ? "#ffffff"
                                            : "#00000000"

                                        border.width: 1

                                        border.color:
                                            "#ffffff"

                                        radius: 0
                                    }

                                    Row {
                                        anchors.left: parent.left
                                        anchors.right: parent.right

                                        anchors.verticalCenter:
                                            parent.verticalCenter

                                        anchors.leftMargin: 10
                                        anchors.rightMargin: 10

                                        spacing: 8

                                        Text {
                                            width:
                                                parent.width -
                                                appName.implicitWidth -
                                                8

                                            anchors.verticalCenter:
                                                parent.verticalCenter

                                            text:
                                                modelData.name || ""

                                            font.family:
                                                "FiraCode Nerd Font Propo"

                                            font.pixelSize: 12
                                            font.weight: 700

                                            color:
                                                root.keyboardNavigation &&
                                                root.selectedIndex === index
                                                ? "#000000"
                                                : "#ffffff"

                                            elide:
                                                Text.ElideRight
                                        }

                                        Text {
                                            id: appName

                                            anchors.verticalCenter:
                                                parent.verticalCenter

                                            text:
                                                index === 0
                                                ? "DEFAULT"
                                                : ""

                                            font.family:
                                                "FiraCode Nerd Font Propo"

                                            font.pixelSize: 9
                                            font.weight: 700

                                            color:
                                                root.keyboardNavigation &&
                                                root.selectedIndex === index
                                                ? "#000000"
                                                : "#99ffffff"
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent

                                        hoverEnabled: true

                                        cursorShape:
                                            Qt.PointingHandCursor

                                        onEntered: {
                                            root.select(index)
                                        }

                                        onClicked: {
                                            if (
                                                modelData &&
                                                modelData.command
                                            ) {
                                                root.close()

                                                Quickshell.execDetached([
                                                    "sh",
                                                    "-c",
                                                    modelData.command
                                                ])
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
    }
}
