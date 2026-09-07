import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Wayland

Item {
    id: root

    property bool menuVisible: false
    property bool windowVisible: false

    property string expression: ""
    property string result: ""

    implicitWidth: 0
    implicitHeight: 0

    function toggle() {
        if (root.menuVisible) {
            root.close()
            return
        }

        root.windowVisible = true
        root.menuVisible = true

        Qt.callLater(function() {
            expressionInput.forceActiveFocus()
        })
    }

    function close() {
        root.menuVisible = false
        expressionInput.focus = false
        resultOutput.focus = false
    }

    function calculate() {
        if (root.expression.trim() === "") {
            root.result = ""
            return
        }

        qalcProcess.command = [
            "qalc",
            "-t",
            root.expression
        ]

        qalcProcess.running = false
        qalcProcess.running = true
    }

    function append(value) {
        var position =
            expressionInput.cursorPosition

        expressionInput.insert(
            position,
            value
        )

        expressionInput.cursorPosition =
            position + value.length

        expressionInput.forceActiveFocus()
    }

    function clear() {
        expressionInput.text = ""
        root.result = ""
        expressionInput.forceActiveFocus()
    }

    function backspace() {
        var position =
            expressionInput.cursorPosition

        if (position <= 0)
            return

        expressionInput.remove(
            position - 1,
            position
        )

        expressionInput.cursorPosition =
            position - 1

        expressionInput.forceActiveFocus()
    }

    PanelWindow {
        id: calculatorWindow

        screen: Quickshell.screens.length > 0
            ? Quickshell.screens[0]
            : null

        visible: root.windowVisible

        focusable: root.windowVisible

        WlrLayershell.keyboardFocus:
            root.windowVisible
                ? WlrKeyboardFocus.Exclusive
                : WlrKeyboardFocus.None

        color: "#00000000"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        exclusionMode: ExclusionMode.Ignore

        Item {
            anchors.fill: parent

            Keys.onEscapePressed: {
                root.close()
            }

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton

                onClicked: {
                    if (
                        mouseX < calculatorContainer.x
                        || mouseX >
                            calculatorContainer.x
                            + calculatorContainer.width
                        || mouseY <
                            calculatorContainer.y
                        || mouseY >
                            calculatorContainer.y
                            + calculatorContainer.height
                    ) {
                        root.close()
                    }
                }
            }

            Item {
                id: calculatorContainer

                width: 330

                height:
                    calculatorContent.implicitHeight
                    + 24

                anchors.horizontalCenter:
                    parent.horizontalCenter

                y: root.menuVisible
                    ? (parent.height - height) / 2
                    : -height

                Behavior on y {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutCubic

                        onRunningChanged: {
                            if (
                                !running
                                && !root.menuVisible
                            ) {
                                root.windowVisible = false
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent

                    color: "#B3000000"

                    border.width: 1
                    border.color: "#ffffff"

                    radius: 0
                }

                Item {
                    id: calculatorContent

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: 12
                    }

                    implicitHeight:
                        calculatorLayout.implicitHeight

                    ColumnLayout {
                        id: calculatorLayout

                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                        }

                        spacing: 10

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36

                            TextInput {
                                id: expressionInput

                                anchors.fill: parent

                                text: root.expression

                                focus: root.menuVisible

                                selectByMouse: true

                                horizontalAlignment:
                                    Text.AlignRight

                                verticalAlignment:
                                    Text.AlignVCenter

                                font.family:
                                    "FiraCode Nerd Font Propo"

                                font.pixelSize: 15
                                font.weight: 700

                                color: "#ffffff"

                                selectionColor: "#ffffff"
                                selectedTextColor: "#000000"

                                cursorVisible: true

                                clip: true

                                onTextChanged: {
                                    root.expression = text
                                    root.calculate()
                                }

                                Keys.onPressed: function(event) {
                                    if (
                                        event.key === Qt.Key_C
                                        && (
                                            event.modifiers
                                            & Qt.ControlModifier
                                        )
                                    ) {
                                        if (
                                            expressionInput.selectedText
                                            !== ""
                                        ) {
                                            expressionInput.copy()
                                            event.accepted = true
                                        }
                                    }

                                    if (
                                        event.key === Qt.Key_Escape
                                    ) {
                                        root.close()
                                        event.accepted = true
                                    }
                                }

                                Keys.onReturnPressed: {
                                    root.calculate()
                                }

                                Keys.onEnterPressed: {
                                    root.calculate()
                                }

                                onActiveFocusChanged: {
                                    if (
                                        root.menuVisible
                                        && !activeFocus
                                    ) {
                                        Qt.callLater(function() {
                                            if (
                                                root.menuVisible
                                                && !resultOutput.activeFocus
                                            ) {
                                                expressionInput.forceActiveFocus()
                                            }
                                        })
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true

                            height: 1

                            color: "#ffffff"
                        }

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 34

                            TextEdit {
                                id: resultOutput

                                anchors.fill: parent

                                text:
                                    root.result === ""
                                    ? " "
                                    : root.result

                                readOnly: true

                                selectByMouse: true

                                persistentSelection: true

                                wrapMode:
                                    TextEdit.NoWrap

                                horizontalAlignment:
                                    Text.AlignRight

                                verticalAlignment:
                                    Text.AlignVCenter

                                font.family:
                                    "FiraCode Nerd Font Propo"

                                font.pixelSize: 13
                                font.weight: 700

                                color: "#ffffff"

                                selectionColor: "#ffffff"
                                selectedTextColor: "#000000"

                                cursorVisible: false

                                clip: true

                                Keys.onPressed: function(event) {
                                    if (
                                        event.key === Qt.Key_C
                                        && (
                                            event.modifiers
                                            & Qt.ControlModifier
                                        )
                                    ) {
                                        if (
                                            resultOutput.selectedText
                                            !== ""
                                        ) {
                                            resultOutput.copy()
                                            event.accepted = true
                                        }
                                    }

                                    if (
                                        event.key === Qt.Key_Escape
                                    ) {
                                        root.close()
                                        event.accepted = true
                                    }
                                }

                                onActiveFocusChanged: {
                                    if (
                                        root.menuVisible
                                        && activeFocus
                                    ) {
                                        resultOutput.forceActiveFocus()
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true

                            height: 1

                            color: "#ffffff"
                        }

                        GridLayout {
                            Layout.fillWidth: true

                            columns: 4

                            columnSpacing: 6
                            rowSpacing: 6

                            CalculatorButton {
                                text: "C"
                                operation: true

                                onClicked: {
                                    root.clear()
                                }
                            }

                            CalculatorButton {
                                text: "⌫"
                                operation: true

                                onClicked: {
                                    root.backspace()
                                }
                            }

                            CalculatorButton {
                                text: "("
                                operation: true

                                onClicked: {
                                    root.append("(")
                                }
                            }

                            CalculatorButton {
                                text: ")"
                                operation: true

                                onClicked: {
                                    root.append(")")
                                }
                            }

                            CalculatorButton {
                                text: "7"
                                numeric: true

                                onClicked: {
                                    root.append("7")
                                }
                            }

                            CalculatorButton {
                                text: "8"
                                numeric: true

                                onClicked: {
                                    root.append("8")
                                }
                            }

                            CalculatorButton {
                                text: "9"
                                numeric: true

                                onClicked: {
                                    root.append("9")
                                }
                            }

                            CalculatorButton {
                                text: "÷"
                                operation: true

                                onClicked: {
                                    root.append("/")
                                }
                            }

                            CalculatorButton {
                                text: "4"
                                numeric: true

                                onClicked: {
                                    root.append("4")
                                }
                            }

                            CalculatorButton {
                                text: "5"
                                numeric: true

                                onClicked: {
                                    root.append("5")
                                }
                            }

                            CalculatorButton {
                                text: "6"
                                numeric: true

                                onClicked: {
                                    root.append("6")
                                }
                            }

                            CalculatorButton {
                                text: "×"
                                operation: true

                                onClicked: {
                                    root.append("*")
                                }
                            }

                            CalculatorButton {
                                text: "1"
                                numeric: true

                                onClicked: {
                                    root.append("1")
                                }
                            }

                            CalculatorButton {
                                text: "2"
                                numeric: true

                                onClicked: {
                                    root.append("2")
                                }
                            }

                            CalculatorButton {
                                text: "3"
                                numeric: true

                                onClicked: {
                                    root.append("3")
                                }
                            }

                            CalculatorButton {
                                text: "−"
                                operation: true

                                onClicked: {
                                    root.append("-")
                                }
                            }

                            CalculatorButton {
                                text: "0"
                                numeric: true

                                Layout.columnSpan: 2

                                onClicked: {
                                    root.append("0")
                                }
                            }

                            CalculatorButton {
                                text: "."
                                operation: true

                                onClicked: {
                                    root.append(".")
                                }
                            }

                            CalculatorButton {
                                text: "+"
                                operation: true

                                onClicked: {
                                    root.append("+")
                                }
                            }

                            CalculatorButton {
                                text: "%"
                                operation: true

                                onClicked: {
                                    root.append("%")
                                }
                            }

                            CalculatorButton {
                                text: "="
                                operation: true

                                Layout.columnSpan: 3

                                onClicked: {
                                    root.calculate()
                                    expressionInput.forceActiveFocus()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    component CalculatorButton: Item {
        id: button

        property string text: ""
        property bool operation: false
        property bool numeric: false

        signal clicked()

        Layout.fillWidth: true
        Layout.preferredHeight: 34

        Rectangle {
            anchors.fill: parent

            color: "#00000000"

            border.width: 1
            border.color: "#ffffff"

            radius: 0
        }

        Text {
            anchors.centerIn: parent

            text: button.text

            font.family: button.numeric
                ? "OCRA"
                : "FiraCode Nerd Font Propo"

            font.pixelSize: 11
            font.weight: 700

            color: button.operation
                ? "#ff0000"
                : "#ffffff"
        }

        MouseArea {
            anchors.fill: parent

            cursorShape:
                Qt.PointingHandCursor

            onClicked: {
                button.clicked()
                expressionInput.forceActiveFocus()
            }
        }
    }

    Process {
        id: qalcProcess

        stdout: StdioCollector {
            onStreamFinished: {
                root.result =
                    this.text.trim()
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                var error =
                    this.text.trim()

                if (error !== "")
                    root.result = error
            }
        }
    }
}
