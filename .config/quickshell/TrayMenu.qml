import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Item {
    id: root

    property var menuItem: null
    property var parentWindow: null
    property var sourceItem: null

    function openFor(item, window, source) {
        if (!item || !item.hasMenu || !window || !source)
            return

        root.menuItem = item
        root.parentWindow = window
        root.sourceItem = source

        menuPopup.visible = false

        Qt.callLater(function() {
            menuPopup.anchor.window = root.parentWindow

            var position = root.sourceItem.mapToItem(
                root.parentWindow.contentItem,
                0,
                root.sourceItem.height
            )

            menuPopup.anchor.rect.x = Math.round(position.x)
            menuPopup.anchor.rect.y = Math.round(position.y)

            menuPopup.visible = true
        })
    }

    function close() {
        menuPopup.visible = false
        root.menuItem = null
        root.parentWindow = null
        root.sourceItem = null
    }

    QsMenuOpener {
        id: menuOpener

        menu: root.menuItem
            ? root.menuItem.menu
            : null
    }

    PopupWindow {
        id: menuPopup

        visible: false

        implicitWidth: 240
        implicitHeight: menuColumn.implicitHeight + 12

        anchor.window: root.parentWindow
        anchor.adjustment: PopupAdjustment.Slide

        color: "transparent"
        grabFocus: true

        onVisibleChanged: {
            if (visible)
                menuFocus.forceActiveFocus()
        }

        FocusScope {
            id: menuFocus

            anchors.fill: parent
            focus: true

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Escape) {
                    root.close()
                    event.accepted = true
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

                            width: menuColumn.width
                            height: modelData.isSeparator ? 7 : 30

                            Rectangle {
                                visible: modelData.isSeparator

                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter

                                height: 1

                                color: "#55FFFFFF"
                            }

                            Rectangle {
                                visible: !modelData.isSeparator

                                anchors.fill: parent

                                color: mouseArea.containsMouse
                                    ? "#22FFFFFF"
                                    : "transparent"
                            }

                            Image {
                                visible:
                                    !modelData.isSeparator &&
                                    modelData.icon !== ""

                                anchors.left: parent.left
                                anchors.leftMargin: 8
                                anchors.verticalCenter: parent.verticalCenter

                                width: 18
                                height: 18

                                source: modelData.icon

                                sourceSize.width: 18
                                sourceSize.height: 18

                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                asynchronous: true
                            }

                            Text {
                                visible: !modelData.isSeparator

                                anchors.left: parent.left
                                anchors.leftMargin:
                                    modelData.icon !== ""
                                    ? 34
                                    : 10

                                anchors.right: parent.right
                                anchors.rightMargin: 28

                                anchors.verticalCenter: parent.verticalCenter

                                text: modelData.text

                                color: modelData.enabled
                                    ? "#FFFFFFFF"
                                    : "#66FFFFFF"

                                font.family: "FiraCode Nerd Font Propo"
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
                                anchors.verticalCenter: parent.verticalCenter

                                text: "›"

                                color: "#FFFFFFFF"

                                font.family: "FiraCode Nerd Font Propo"
                                font.pixelSize: 18
                            }

                            Text {
                                visible:
                                    !modelData.isSeparator &&
                                    modelData.buttonType !== 0 &&
                                    modelData.checkState === Qt.Checked

                                anchors.left: parent.left
                                anchors.leftMargin: 9
                                anchors.verticalCenter: parent.verticalCenter

                                text: "✓"

                                color: "#FFFFFFFF"

                                font.family: "FiraCode Nerd Font Propo"
                                font.pixelSize: 13
                            }

                            MouseArea {
                                id: mouseArea

                                visible: !modelData.isSeparator

                                anchors.fill: parent

                                hoverEnabled: true

                                cursorShape:
                                    modelData.enabled
                                    ? Qt.PointingHandCursor
                                    : Qt.ArrowCursor

                                onClicked: {
                                    if (!modelData.enabled)
                                        return

                                    if (modelData.hasChildren) {
                                        modelData.display(
                                            root.parentWindow,
                                            mouseArea.x + mouseArea.width,
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
