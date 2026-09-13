// TrayMenu.qml

import QtQuick
import Quickshell
import Quickshell.Wayland

Item {
    id: root

    property var menuItem: null
    property var parentWindow: null
    property var sourceItem: null

    property bool menuVisible: false
    property bool menuWindowVisible: false

    property int selectedIndex: -1
    property bool keyboardNavigation: false

    property int screenMargin: 8
    property int menuGap: 4

    function openFor(item, window, source) {
        if (!item || !item.hasMenu || !window || !source)
            return

        root.menuItem = item
        root.parentWindow = window
        root.sourceItem = source

        root.selectedIndex = -1
        root.keyboardNavigation = false

        root.menuWindowVisible = true
        root.menuVisible = true

        Qt.callLater(function() {
            menuArea.forceActiveFocus()
        })
    }

    function close() {
        root.menuVisible = false
        root.menuWindowVisible = false

        root.keyboardNavigation = false
        root.selectedIndex = -1

        root.menuItem = null
        root.parentWindow = null
        root.sourceItem = null
    }

    function select(index) {
        if (index < 0 || index >= menuOpener.children.values.length)
            return

        var item = menuOpener.children.values[index]

        if (!item || item.isSeparator || !item.enabled)
            return

        root.selectedIndex = index
        root.keyboardNavigation = true
    }

    function selectNext() {
        var count = menuOpener.children.values.length

        if (count === 0)
            return

        var index = root.selectedIndex

        for (var i = 0; i < count; ++i) {
            index = (index + 1) % count

            var item = menuOpener.children.values[index]

            if (item && !item.isSeparator && item.enabled) {
                root.select(index)
                return
            }
        }
    }

    function selectPrevious() {
        var count = menuOpener.children.values.length

        if (count === 0)
            return

        var index = root.selectedIndex

        if (index < 0)
            index = 0

        for (var i = 0; i < count; ++i) {
            index = (index - 1 + count) % count

            var item = menuOpener.children.values[index]

            if (item && !item.isSeparator && item.enabled) {
                root.select(index)
                return
            }
        }
    }

    function activateSelected() {
        if (root.selectedIndex < 0)
            return

        var item =
            menuOpener.children.values[root.selectedIndex]

        if (!item || item.isSeparator || !item.enabled)
            return

        if (item.hasChildren) {
            item.display(
                root.parentWindow,
                menuContainer.x + menuContainer.width,
                menuContainer.y
            )
            return
        }

        item.triggered()

        root.close()
    }

    function selectFirst() {
        var count = menuOpener.children.values.length

        for (var i = 0; i < count; ++i) {
            var item = menuOpener.children.values[i]

            if (item && !item.isSeparator && item.enabled) {
                root.select(i)
                return
            }
        }
    }

    function selectLast() {
        var count = menuOpener.children.values.length

        for (var i = count - 1; i >= 0; --i) {
            var item = menuOpener.children.values[i]

            if (item && !item.isSeparator && item.enabled) {
                root.select(i)
                return
            }
        }
    }

    QsMenuOpener {
        id: menuOpener

        menu: root.menuItem
            ? root.menuItem.menu
            : null
    }

    PanelWindow {
        id: menuWindow

        screen:
            root.QsWindow.window
            ? root.QsWindow.window.screen
            : null

        visible: root.menuWindowVisible

        focusable: root.menuWindowVisible

        WlrLayershell.keyboardFocus:
            root.menuWindowVisible
            ? WlrKeyboardFocus.Exclusive
            : WlrKeyboardFocus.None

        exclusionMode: ExclusionMode.Ignore

        color: "transparent"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Item {
            id: menuArea

            anchors.fill: parent

            focus: root.menuVisible

            Keys.onPressed: function(event) {

                if (
                    event.key === Qt.Key_Down ||
                    event.key === Qt.Key_J
                ) {
                    root.selectNext()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Up ||
                    event.key === Qt.Key_K
                ) {
                    root.selectPrevious()
                    event.accepted = true
                    return
                }

                if (event.key === Qt.Key_Home) {
                    root.selectFirst()
                    event.accepted = true
                    return
                }

                if (event.key === Qt.Key_End) {
                    root.selectLast()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Return ||
                    event.key === Qt.Key_Enter ||
                    event.key === Qt.Key_Space
                ) {
                    root.activateSelected()
                    event.accepted = true
                    return
                }

                if (event.key === Qt.Key_Escape) {
                    root.close()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Left ||
                    event.key === Qt.Key_H
                ) {
                    root.close()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Right ||
                    event.key === Qt.Key_L
                ) {
                    root.selectNext()
                    event.accepted = true
                    return
                }
            }

            MouseArea {
                id: outsideMouseArea

                anchors.fill: parent

                acceptedButtons: Qt.LeftButton

                onClicked: function(mouse) {
                    var p = menuContainer.mapFromItem(
                        menuArea,
                        mouse.x,
                        mouse.y
                    )

                    if (
                        p.x < 0 ||
                        p.x > menuContainer.width ||
                        p.y < 0 ||
                        p.y > menuContainer.height
                    ) {
                        root.close()
                    }
                }
            }

            Item {
                id: menuContainer

                width: 240

                height: menuColumn.implicitHeight + 12

                x:
                    menuWindow.width
                    - width
                    - root.screenMargin

                y:
                    root.menuVisible
                    ? root.parentWindow.height + root.menuGap
                    : root.parentWindow.height + root.menuGap

                Behavior on y {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }

                Rectangle {
                    anchors.fill: parent

                    color: "#B3000000"

                    border.width: 1
                    border.color: "#FFFFFFFF"

                    radius: 0

                    Column {
                        id: menuColumn

                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top

                        anchors.margins: 6

                        spacing: 0

                        Repeater {
                            model: menuOpener.children

                            delegate: Item {
                                required property var modelData
                                required property int index

                                width: menuColumn.width

                                height:
                                    modelData.isSeparator
                                    ? 7
                                    : 30

                                Rectangle {
                                    visible:
                                        modelData.isSeparator

                                    anchors.left: parent.left
                                    anchors.right: parent.right

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    height: 1

                                    color: "#55FFFFFF"
                                }

                                Rectangle {
                                    visible:
                                        !modelData.isSeparator

                                    anchors.fill: parent

                                    color:
                                        root.selectedIndex === index
                                        ? "#FFFFFFFF"
                                        : mouseArea.containsMouse
                                            ? "#22FFFFFF"
                                            : "transparent"
                                }

                                Image {
                                    visible:
                                        !modelData.isSeparator &&
                                        modelData.icon !== ""

                                    anchors.left: parent.left
                                    anchors.leftMargin: 8

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    width: 18
                                    height: 18

                                    source: modelData.icon

                                    sourceSize.width: 18
                                    sourceSize.height: 18

                                    fillMode:
                                        Image.PreserveAspectFit

                                    smooth: true
                                    asynchronous: true
                                }

                                Text {
                                    visible:
                                        !modelData.isSeparator

                                    anchors.left: parent.left

                                    anchors.leftMargin:
                                        modelData.icon !== ""
                                        ? 34
                                        : 10

                                    anchors.right: parent.right
                                    anchors.rightMargin: 28

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text: modelData.text

                                    color:
                                        root.selectedIndex === index
                                        ? "#000000"
                                        : modelData.enabled
                                            ? "#FFFFFFFF"
                                            : "#66FFFFFF"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 13
                                    font.weight: 500

                                    elide: Text.ElideRight
                                }

                                Text {
                                    visible:
                                        !modelData.isSeparator &&
                                        modelData.hasChildren

                                    anchors.right: parent.right
                                    anchors.rightMargin: 9

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text: "›"

                                    color:
                                        root.selectedIndex === index
                                        ? "#000000"
                                        : "#FFFFFFFF"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 18
                                }

                                Text {
                                    visible:
                                        !modelData.isSeparator &&
                                        modelData.buttonType !== 0 &&
                                        modelData.checkState === Qt.Checked

                                    anchors.left: parent.left
                                    anchors.leftMargin: 9

                                    anchors.verticalCenter:
                                        parent.verticalCenter

                                    text: "✓"

                                    color:
                                        root.selectedIndex === index
                                        ? "#000000"
                                        : "#FFFFFFFF"

                                    font.family:
                                        "FiraCode Nerd Font Propo"

                                    font.pixelSize: 13
                                }

                                MouseArea {
                                    id: mouseArea

                                    visible:
                                        !modelData.isSeparator

                                    anchors.fill: parent

                                    hoverEnabled: true

                                    cursorShape:
                                        modelData.enabled
                                        ? Qt.PointingHandCursor
                                        : Qt.ArrowCursor

                                    onEntered: {
                                        if (modelData.enabled) {
                                            root.select(index)
                                            root.keyboardNavigation = false
                                        }
                                    }

                                    onClicked: {
                                        if (!modelData.enabled)
                                            return

                                        if (modelData.hasChildren) {
                                            modelData.display(
                                                root.parentWindow,
                                                mouseArea.x +
                                                mouseArea.width,
                                                mouseArea.y
                                            )
                                            return
                                        }

                                        modelData.triggered()

                                        root.close()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    onMenuVisibleChanged: {
        if (menuVisible) {
            Qt.callLater(function() {
                menuArea.forceActiveFocus()
            })
        }
    }
}
