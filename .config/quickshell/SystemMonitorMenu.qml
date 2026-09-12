import Quickshell
import Quickshell.Wayland
import QtQuick

Item {
    id: root

    property bool menuVisible: false
    property bool menuWindowVisible: false

    property real cpuUsage: 0
    property real cpuTemperature: 0

    property real memoryUsage: 0
    property real memoryTotal: 0
    property real memoryUsed: 0

    property real rootUsage: 0
    property real rootTotal: 0
    property real rootUsed: 0

    // RAM:
    // /proc/meminfo = KiB
    // KiB -> GiB
    function formatMemoryGiB(value) {
        return (
            value /
            1024 /
            1024
        ).toFixed(1)
    }

    // Disk:
    // df -B1 = bytes
    // bytes -> GiB
    function formatDiskGiB(value) {
        return (
            value /
            1024 /
            1024 /
            1024
        ).toFixed(1)
    }

    function toggle() {
        if (menuVisible)
            close()
        else
            open()
    }

    function open() {
        menuWindowVisible = true
        menuVisible = true

        Qt.callLater(function() {
            menuArea.forceActiveFocus()
        })
    }

    function close() {
        menuVisible = false
    }

    function openBtop() {
        Quickshell.execDetached([
            "ghostty",
            "-e",
            "btop"
        ])
    }

    PanelWindow {
        id: menuWindow

        screen:
            root.QsWindow.window.screen

        visible:
            root.menuWindowVisible

        focusable:
            root.menuWindowVisible

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

        exclusionMode:
            ExclusionMode.Ignore

        Item {
            id: menuArea

            anchors.fill: parent

            focus:
                root.menuVisible

            activeFocusOnTab: true

            Keys.onPressed: function(event) {
                if (
                    event.key ===
                    Qt.Key_Escape
                ) {
                    root.close()
                    event.accepted = true
                    return
                }

                // Vim + arrow navigation.
                if (
                    event.key === Qt.Key_H ||
                    event.key === Qt.Key_J ||
                    event.key === Qt.Key_K ||
                    event.key === Qt.Key_L ||
                    event.key === Qt.Key_Left ||
                    event.key === Qt.Key_Right ||
                    event.key === Qt.Key_Up ||
                    event.key === Qt.Key_Down
                ) {
                    btopButton.forceActiveFocus()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Tab &&
                    !event.modifiers
                ) {
                    btopButton.forceActiveFocus()
                    event.accepted = true
                    return
                }

                if (
                    (
                        event.key ===
                        Qt.Key_Return ||
                        event.key ===
                        Qt.Key_Enter ||
                        event.key ===
                        Qt.Key_Space
                    ) &&
                    !event.modifiers
                ) {
                    btopButton.forceActiveFocus()
                    root.openBtop()
                    event.accepted = true
                    return
                }
            }

            MouseArea {
                anchors.fill: parent

                acceptedButtons:
                    Qt.LeftButton

                onClicked: function(mouse) {
                    var point =
                        menuContainer.mapFromItem(
                            menuArea,
                            mouse.x,
                            mouse.y
                        )

                    if (
                        point.x < 0 ||
                        point.x >
                            menuContainer.width ||
                        point.y < 0 ||
                        point.y >
                            menuContainer.height
                    ) {
                        root.close()
                    }
                }
            }

            Item {
                id: menuContainer

                width: 340

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
                        "#ffffffff"

                    radius: 0
                }

                Item {
                    id: menuContent

                    anchors.top:
                        parent.top

                    anchors.left:
                        parent.left

                    anchors.right:
                        parent.right

                    anchors.margins: 12

                    implicitHeight:
                        contentColumn.implicitHeight

                    Column {
                        id: contentColumn

                        width: parent.width

                        spacing: 10

                        Text {
                            width: parent.width

                            text:
                                "SYSTEM MONITOR"

                            color:
                                "#ffffff"

                            font.family:
                                "FiraCode Nerd Font Propo"

                            font.pixelSize: 14
                            font.weight: 700

                            horizontalAlignment:
                                Text.AlignHCenter

                            style:
                                Text.Raised

                            styleColor:
                                "#ffffff"
                        }

                        Rectangle {
                            width:
                                parent.width

                            height: 1

                            color:
                                "#ffffffff"
                        }

                        // =========================
                        // CPU
                        // =========================

                        Column {
                            width:
                                parent.width

                            spacing: 5

                            Text {
                                text:
                                    "CPU"

                                color:
                                    "#ffffff"

                                font.family:
                                    "FiraCode Nerd Font Propo"

                                font.pixelSize: 13
                                font.weight: 700

                                style:
                                    Text.Raised

                                styleColor:
                                    "#ffffff"
                            }

                            Item {
                                width:
                                    parent.width

                                height: 20

                                Text {
                                    anchors.left:
                                        parent.left

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        "Usage"

                                    color:
                                        "#888888"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 12

                                    style:
                                        Text.Raised

                                    styleColor:
                                        "#888888"
                                }

                                Text {
                                    anchors.right:
                                        parent.right

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        Math.round(
                                            root.cpuUsage
                                        ) + "%"

                                    color:
                                        "#ffffff"

                                    font.family:
                                        "OCRA"

                                    font.pixelSize: 12
                                    font.weight: 700

                                    horizontalAlignment:
                                        Text.AlignRight

                                    style:
                                        Text.Raised

                                    styleColor:
                                        "#ffffff"
                                }
                            }

                            Item {
                                width:
                                    parent.width

                                height: 20

                                Text {
                                    anchors.left:
                                        parent.left

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        "Temperature"

                                    color:
                                        "#888888"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 12

                                    style:
                                        Text.Raised

                                    styleColor:
                                        "#888888"
                                }

                                Text {
                                    anchors.right:
                                        parent.right

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        Math.round(
                                            root.cpuTemperature
                                        ) + " °C"

                                    color:
                                        root.cpuTemperature >= 70
                                        ? "#ff5555"
                                        : "#ffffff"

                                    font.family:
                                        "OCRA"

                                    font.pixelSize: 12
                                    font.weight: 700

                                    horizontalAlignment:
                                        Text.AlignRight

                                    style:
                                        Text.Raised

                                    styleColor:
                                        root.cpuTemperature >= 70
                                        ? "#ff5555"
                                        : "#ffffff"
                                }
                            }
                        }

                        Rectangle {
                            width:
                                parent.width

                            height: 1

                            color:
                                "#ffffffff"
                        }

                        // =========================
                        // MEMORY
                        // =========================

                        Column {
                            width:
                                parent.width

                            spacing: 5

                            Text {
                                text:
                                    "MEMORY"

                                color:
                                    "#ffffff"

                                font.family:
                                    "FiraCode Nerd Font Propo"

                                font.pixelSize: 13
                                font.weight: 700

                                style:
                                    Text.Raised

                                styleColor:
                                    "#ffffff"
                            }

                            Item {
                                width:
                                    parent.width

                                height: 20

                                Text {
                                    anchors.left:
                                        parent.left

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        "Used"

                                    color:
                                        "#888888"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 12

                                    style:
                                        Text.Raised

                                    styleColor:
                                        "#888888"
                                }

                                Text {
                                    anchors.right:
                                        parent.right

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        root.formatMemoryGiB(
                                            root.memoryUsed
                                        )
                                        + " GiB / "
                                        + root.formatMemoryGiB(
                                            root.memoryTotal
                                        )
                                        + " GiB"

                                    color:
                                        "#ffffff"

                                    font.family:
                                        "OCRA"

                                    font.pixelSize: 12
                                    font.weight: 700

                                    horizontalAlignment:
                                        Text.AlignRight

                                    style:
                                        Text.Raised

                                    styleColor:
                                        "#ffffff"
                                }
                            }

                            Item {
                                width:
                                    parent.width

                                height: 20

                                Text {
                                    anchors.left:
                                        parent.left

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        "Usage"

                                    color:
                                        "#888888"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 12

                                    style:
                                        Text.Raised

                                    styleColor:
                                        "#888888"
                                }

                                Text {
                                    anchors.right:
                                        parent.right

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        Math.round(
                                            root.memoryUsage
                                        ) + "%"

                                    color:
                                        "#ffffff"

                                    font.family:
                                        "OCRA"

                                    font.pixelSize: 12
                                    font.weight: 700

                                    horizontalAlignment:
                                        Text.AlignRight

                                    style:
                                        Text.Raised

                                    styleColor:
                                        "#ffffff"
                                }
                            }
                        }

                        Rectangle {
                            width:
                                parent.width

                            height: 1

                            color:
                                "#ffffffff"
                        }

                        // =========================
                        // ROOT PARTITION
                        // =========================

                        Column {
                            width:
                                parent.width

                            spacing: 5

                            Text {
                                text:
                                    "ROOT PARTITION (/)"

                                color:
                                    "#ffffff"

                                font.family:
                                    "FiraCode Nerd Font Propo"

                                font.pixelSize: 13
                                font.weight: 700

                                style:
                                    Text.Raised

                                styleColor:
                                    "#ffffff"
                            }

                            Item {
                                width:
                                    parent.width

                                height: 20

                                Text {
                                    anchors.left:
                                        parent.left

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        "Used"

                                    color:
                                        "#888888"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 12

                                    style:
                                        Text.Raised

                                    styleColor:
                                        "#888888"
                                }

                                Text {
                                    anchors.right:
                                        parent.right

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        root.formatDiskGiB(
                                            root.rootUsed
                                        )
                                        + " GiB / "
                                        + root.formatDiskGiB(
                                            root.rootTotal
                                        )
                                        + " GiB"

                                    color:
                                        "#ffffff"

                                    font.family:
                                        "OCRA"

                                    font.pixelSize: 12
                                    font.weight: 700

                                    horizontalAlignment:
                                        Text.AlignRight

                                    style:
                                        Text.Raised

                                    styleColor:
                                        "#ffffff"
                                }
                            }

                            Item {
                                width:
                                    parent.width

                                height: 20

                                Text {
                                    anchors.left:
                                        parent.left

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        "Usage"

                                    color:
                                        "#888888"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 12

                                    style:
                                        Text.Raised

                                    styleColor:
                                        "#888888"
                                }

                                Text {
                                    anchors.right:
                                        parent.right

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text:
                                        Math.round(
                                            root.rootUsage
                                        ) + "%"

                                    color:
                                        root.rootUsage >= 90
                                        ? "#ff5555"
                                        : "#ffffff"

                                    font.family:
                                        "OCRA"

                                    font.pixelSize: 12
                                    font.weight: 700

                                    horizontalAlignment:
                                        Text.AlignRight

                                    style:
                                        Text.Raised

                                    styleColor:
                                        root.rootUsage >= 90
                                        ? "#ff5555"
                                        : "#ffffff"
                                }
                            }
                        }

                        Rectangle {
                            width:
                                parent.width

                            height: 1

                            color:
                                "#ffffffff"
                        }

                        // =========================
                        // BTOP
                        // =========================

                        Item {
                            id: btopButton

                            width:
                                parent.width

                            height: 34

                            focus: false

                            activeFocusOnTab:
                                true

                            Keys.onPressed:
                                function(event) {

                                if (
                                    event.key ===
                                    Qt.Key_Return ||
                                    event.key ===
                                    Qt.Key_Enter ||
                                    event.key ===
                                    Qt.Key_Space
                                ) {
                                    root.openBtop()

                                    event.accepted =
                                        true

                                    return
                                }

                                if (
                                    event.key ===
                                    Qt.Key_Escape
                                ) {
                                    root.close()

                                    event.accepted =
                                        true

                                    return
                                }

                                if (
                                    event.key ===
                                    Qt.Key_H ||
                                    event.key ===
                                    Qt.Key_J ||
                                    event.key ===
                                    Qt.Key_K ||
                                    event.key ===
                                    Qt.Key_L ||
                                    event.key ===
                                    Qt.Key_Left ||
                                    event.key ===
                                    Qt.Key_Right ||
                                    event.key ===
                                    Qt.Key_Up ||
                                    event.key ===
                                    Qt.Key_Down
                                ) {
                                    btopButton.forceActiveFocus()

                                    event.accepted =
                                        true

                                    return
                                }

                                if (
                                    event.key ===
                                    Qt.Key_Tab &&
                                    !event.modifiers
                                ) {
                                    menuArea.forceActiveFocus()

                                    event.accepted =
                                        true

                                    return
                                }
                            }

                            Rectangle {
                                anchors.fill:
                                    parent

                                color:
                                    btopButton.activeFocus
                                    ? "#ffffff"
                                    : "#00000000"

                                border.width: 1

                                border.color:
                                    "#ffffff"

                                Text {
                                    anchors.centerIn:
                                        parent

                                    text:
                                        "  BTOP"

                                    color:
                                        btopButton.activeFocus
                                        ? "#000000"
                                        : "#ffffff"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 12
                                    font.weight: 700

                                    style:
                                        Text.Raised

                                    styleColor:
                                        btopButton.activeFocus
                                        ? "#000000"
                                        : "#ffffff"
                                }
                            }

                            MouseArea {
                                anchors.fill:
                                    parent

                                cursorShape:
                                    Qt.PointingHandCursor

                                onClicked: {
                                    btopButton.forceActiveFocus()
                                    root.openBtop()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
