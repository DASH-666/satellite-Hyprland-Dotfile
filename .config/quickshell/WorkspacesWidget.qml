// WorkspaceWidget.qml

pragma ComponentBehavior: Bound

import Quickshell.Hyprland
import QtQuick

Item {
    id: root

    property var workspaceIds: []

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    function updateWorkspaceIds() {
        var ids = [1, 2, 3, 4, 5]
        var workspaces = Hyprland.workspaces.values

        for (var i = 0; i < workspaces.length; i++) {
            var id = workspaces[i].id

            if (id > 5 && id < 1000 && ids.indexOf(id) === -1)
                ids.push(id)
        }

        ids.sort(function(a, b) {
            return a - b
        })

        workspaceIds = ids
    }

    function getWorkspace(id) {
        var workspaces = Hyprland.workspaces.values

        for (var i = 0; i < workspaces.length; i++) {
            if (workspaces[i].id === id)
                return workspaces[i]
        }

        return null
    }

    function isOccupied(id) {
        var ws = getWorkspace(id)

        return ws
            && ws.toplevels
            && ws.toplevels.values.length > 0
    }

    function isUrgent(id) {
        var ws = getWorkspace(id)

        return ws && ws.urgent
    }

    function isFocused(id) {
        var current = Hyprland.focusedWorkspace

        return current && current.id === id
    }

    function workspaceTextColor(id) {
        if (isUrgent(id))
            return "#ff0000"

        if (isOccupied(id))
            return "#ffffff"

        return "#99ffffff"
    }

    function workspaceStyleColor(id) {
        if (isUrgent(id))
            return "#ff0000"

        if (isOccupied(id))
            return "#ffffff"

        return "#99ffffff"
    }

    function isSpecialOccupied() {
        var workspaces = Hyprland.workspaces.values

        for (var i = 0; i < workspaces.length; i++) {
            var ws = workspaces[i]

            if (
                ws.name === "special:magic"
                && ws.toplevels
                && ws.toplevels.values.length > 0
            ) {
                return true
            }
        }

        return false
    }

    function activateWorkspace(id) {
        var ws = getWorkspace(id)

        if (ws) {
            ws.activate()
            return
        }

        Hyprland.dispatch(
            'hl.dsp.focus({ workspace = "' + id + '" })'
        )
    }

    function activateSpecial() {
        Hyprland.dispatch(
            'hl.dsp.workspace.toggle_special("magic")'
        )
    }

    function currentIndex() {
        var current = Hyprland.focusedWorkspace

        if (!current)
            return 0

        var index = workspaceIds.indexOf(current.id)

        return index >= 0 ? index : 0
    }

    function scrollWorkspace(direction) {
        var current = currentIndex()

        for (var i = 1; i <= workspaceIds.length; i++) {
            var index = (current + direction * i) % workspaceIds.length

            if (index < 0)
                index += workspaceIds.length

            if (isOccupied(workspaceIds[index])) {
                activateWorkspace(workspaceIds[index])
                return
            }
        }
    }

    Row {
        id: content

        spacing: 8

        Repeater {
            model: root.workspaceIds

            delegate: Item {
                required property int modelData

                implicitWidth: number.implicitWidth
                implicitHeight: number.implicitHeight

                BarNumberStyle {
                    id: number

                    anchors.centerIn: parent

                    text: modelData.toString()

                    textColor: root.workspaceTextColor(modelData)
                    textStyleColor: root.workspaceStyleColor(modelData)
                }

                Rectangle {
                    anchors.fill: number

                    visible: root.isFocused(modelData)

                    color: "transparent"
                    border.width: 1
                    border.color: "#ffffff"
                }

                MouseArea {
                    anchors.fill: parent

                    acceptedButtons: Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        root.activateWorkspace(modelData)
                    }

                    onWheel: function(wheel) {
                        if (wheel.angleDelta.y > 0)
                            root.scrollWorkspace(1)
                        else if (wheel.angleDelta.y < 0)
                            root.scrollWorkspace(-1)

                        wheel.accepted = true
                    }
                }
            }
        }

        Item {
            implicitWidth: specialText.implicitWidth
            implicitHeight: specialText.implicitHeight

            BarTextStyle {
                id: specialText

                text: ""

                textColor: root.isSpecialOccupied()
                    ? "#ffffff"
                    : "#99ffffff"
            }

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    root.activateSpecial()
                }

                onWheel: function(wheel) {
                    if (wheel.angleDelta.y > 0)
                        root.scrollWorkspace(1)
                    else if (wheel.angleDelta.y < 0)
                        root.scrollWorkspace(-1)

                    wheel.accepted = true
                }
            }
        }
    }

    Connections {
        target: Hyprland.workspaces

        function onValuesChanged() {
            root.updateWorkspaceIds()
        }
    }

    Connections {
        target: Hyprland

        function onFocusedWorkspaceChanged() {
            root.updateWorkspaceIds()
        }
    }

    Component.onCompleted: {
        root.updateWorkspaceIds()
    }
}
