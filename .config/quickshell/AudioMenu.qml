import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

Item {
    id: root

    property bool menuVisible: false
    property bool menuWindowVisible: false

    property int selectedIndex: -1
    property bool keyboardNavigation: false

    readonly property var output:
        Pipewire.defaultAudioSink

    readonly property var microphone:
        Pipewire.defaultAudioSource

    property var applicationStreams: []
    property var recordingStreams: []

    function toggle() {
        if (menuVisible) {
            close()
        } else {
            refreshStreams()

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

    function refreshStreams() {
        var applications = []
        var recordings = []

        var nodes = Pipewire.nodes.values

        for (var i = 0; i < nodes.length; ++i) {
            var node = nodes[i]

            if (!node)
                continue

            /*
             * Application playback streams
             */
            if (
                node.isSink &&
                node.isStream
            ) {
                applications.push(node)
                continue
            }

            /*
             * Application recording/capture streams
             */
            if (
                !node.isSink &&
                node.isStream
            ) {
                recordings.push(node)
            }
        }

        applicationStreams = applications
        recordingStreams = recordings

        var count = totalControls()

        if (count <= 0) {
            selectedIndex = -1
            return
        }

        if (
            selectedIndex >= count
        ) {
            selectedIndex = count - 1
        }
    }

    function totalControls() {
        var count = 0

        if (root.output)
            count += 1

        if (root.microphone)
            count += 1

        count += root.applicationStreams.length
        count += root.recordingStreams.length

        return count
    }

    function select(index) {
        if (
            index < 0 ||
            index >= totalControls()
        )
            return

        selectedIndex = index
        keyboardNavigation = true
    }

    function moveUp() {
        var count = totalControls()

        if (count <= 0)
            return

        if (!keyboardNavigation) {
            select(0)
            return
        }

        if (selectedIndex <= 0) {
            select(count - 1)
            return
        }

        select(selectedIndex - 1)
    }

    function moveDown() {
        var count = totalControls()

        if (count <= 0)
            return

        if (!keyboardNavigation) {
            select(0)
            return
        }

        if (selectedIndex >= count - 1) {
            select(0)
            return
        }

        select(selectedIndex + 1)
    }

    function moveLeft() {
        if (!keyboardNavigation) {
            select(0)
            return
        }

        changeSelectedVolume(-5)
    }

    function moveRight() {
        if (!keyboardNavigation) {
            select(0)
            return
        }

        changeSelectedVolume(5)
    }

    function selectedNode() {
        var index = selectedIndex

        if (index < 0)
            return null

        /*
         * OUTPUT
         */
        if (root.output) {
            if (index === 0)
                return root.output

            index -= 1
        }

        /*
         * MIC
         */
        if (root.microphone) {
            if (index === 0)
                return root.microphone

            index -= 1
        }

        /*
         * APPLICATIONS
         */
        if (
            index >= 0 &&
            index < root.applicationStreams.length
        ) {
            return root.applicationStreams[index]
        }

        index -= root.applicationStreams.length

        /*
         * RECORDING
         */
        if (
            index >= 0 &&
            index < root.recordingStreams.length
        ) {
            return root.recordingStreams[index]
        }

        return null
    }

    function changeSelectedVolume(delta) {
        var node = selectedNode()

        if (
            !node ||
            !node.audio
        )
            return

        var current =
            node.audio.volume * 100

        var next =
            Math.round(
                (current + delta) / 5
            ) * 5

        next =
            Math.max(
                0,
                Math.min(100, next)
            )

        node.audio.volume =
            next / 100
    }

    function toggleSelectedMute() {
        var node = selectedNode()

        if (
            !node ||
            !node.audio
        )
            return

        node.audio.muted =
            !node.audio.muted
    }

    function activateSelected() {
        toggleSelectedMute()
    }

    function applicationName(node) {
        if (!node)
            return "UNKNOWN"

        var properties = node.properties

        if (
            properties &&
            properties["application.name"]
        ) {
            return properties["application.name"]
        }

        if (
            properties &&
            properties["application.process.binary"]
        ) {
            return properties["application.process.binary"]
        }

        if (node.description)
            return node.description

        if (node.nickname)
            return node.nickname

        if (node.name)
            return node.name

        return "UNKNOWN"
    }

    Timer {
        interval: 1000

        running:
            root.menuVisible

        repeat: true

        onTriggered: {
            root.refreshStreams()
        }
    }

    Component.onCompleted: {
        refreshStreams()
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
                    event.key === Qt.Key_Escape
                ) {
                    root.close()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Up ||
                    event.key === Qt.Key_K
                ) {
                    root.moveUp()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Down ||
                    event.key === Qt.Key_J
                ) {
                    root.moveDown()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Left ||
                    event.key === Qt.Key_H
                ) {
                    root.moveLeft()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Right ||
                    event.key === Qt.Key_L
                ) {
                    root.moveRight()
                    event.accepted = true
                    return
                }

                if (
                    event.key === Qt.Key_Return ||
                    event.key === Qt.Key_Enter ||
                    event.key === Qt.Key_Space
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

            /*
             * فقط click بیرون منو.
             *
             * چون menuContainer بعد از این
             * MouseArea آمده، خودش بالاتر است
             * و MouseAreaهای داخلی آن کار می‌کنند.
             */
            MouseArea {
                anchors.fill: parent

                acceptedButtons:
                    Qt.LeftButton

                onClicked: {
                    if (
                        mouseX < menuContainer.x ||
                        mouseX >
                            menuContainer.x +
                            menuContainer.width ||
                        mouseY < menuContainer.y ||
                        mouseY >
                            menuContainer.y +
                            menuContainer.height
                    ) {
                        root.close()
                    }
                }
            }

            Item {
                id: menuContainer

                width: 420

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

                    ColumnLayout {
                        id: mainLayout

                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                        }

                        spacing: 10

                        Text {
                            Layout.fillWidth: true

                            text:
                                "AUDIO"

                            horizontalAlignment:
                                Text.AlignHCenter

                            font.family:
                                "FiraCode Nerd Font Propo"

                            font.pixelSize: 13
                            font.weight: 700

                            color:
                                "#ffffff"

                            style:
                                Text.Raised

                            styleColor:
                                "#ffffff"
                        }

                        Rectangle {
                            Layout.fillWidth: true

                            height: 1

                            color:
                                "#ffffff"
                        }

                        /*
                         * OUTPUT
                         *
                         * فقط وقتی default output وجود دارد.
                         */
                        ColumnLayout {
                            Layout.fillWidth: true

                            visible:
                                root.output !== null

                            spacing: 6

                            Text {
                                Layout.fillWidth: true

                                text:
                                    "OUTPUT"

                                font.family:
                                    "FiraCode Nerd Font Propo"

                                font.pixelSize: 11
                                font.weight: 700

                                color:
                                    "#aaaaaa"
                            }

                            AudioControl {
                                Layout.fillWidth: true

                                node:
                                    root.output

                                title:
                                    root.output
                                    ? (
                                        root.output.description
                                        ||
                                        root.output.nickname
                                        ||
                                        root.output.name
                                        ||
                                        "DEFAULT OUTPUT"
                                    )
                                    : ""

                                selected:
                                    root.keyboardNavigation &&
                                    root.selectedIndex === 0
                            }
                        }

                        /*
                         * MIC
                         *
                         * فقط وقتی microphone وجود دارد.
                         */
                        ColumnLayout {
                            Layout.fillWidth: true

                            visible:
                                root.microphone !== null

                            spacing: 6

                            Text {
                                Layout.fillWidth: true

                                text:
                                    "MIC"

                                font.family:
                                    "FiraCode Nerd Font Propo"

                                font.pixelSize: 11
                                font.weight: 700

                                color:
                                    "#aaaaaa"
                            }

                            AudioControl {
                                Layout.fillWidth: true

                                node:
                                    root.microphone

                                title:
                                    root.microphone
                                    ? (
                                        root.microphone.description
                                        ||
                                        root.microphone.nickname
                                        ||
                                        root.microphone.name
                                        ||
                                        "DEFAULT MIC"
                                    )
                                    : ""

                                selected: {
                                    var index = 0

                                    if (root.output)
                                        index += 1

                                    return (
                                        root.keyboardNavigation &&
                                        root.selectedIndex === index
                                    )
                                }
                            }
                        }

                        /*
                         * APPLICATIONS
                         *
                         * فقط وقتی حداقل یک
                         * application playback stream
                         * وجود دارد.
                         */
                        ColumnLayout {
                            Layout.fillWidth: true

                            visible:
                                root.applicationStreams.length > 0

                            spacing: 6

                            Text {
                                Layout.fillWidth: true

                                text:
                                    "APPLICATIONS"

                                font.family:
                                    "FiraCode Nerd Font Propo"

                                font.pixelSize: 11
                                font.weight: 700

                                color:
                                    "#aaaaaa"
                            }

                            ColumnLayout {
                                Layout.fillWidth: true

                                spacing: 6

                                Repeater {
                                    model:
                                        root.applicationStreams

                                    delegate:
                                        AudioControl {
                                            required property var modelData
                                            required property int index

                                            Layout.fillWidth: true

                                            node:
                                                modelData

                                            title:
                                                root.applicationName(
                                                    modelData
                                                )

                                            selected: {
                                                var base = 0

                                                if (root.output)
                                                    base += 1

                                                if (root.microphone)
                                                    base += 1

                                                return (
                                                    root.keyboardNavigation &&
                                                    root.selectedIndex ===
                                                    base + index
                                                )
                                            }
                                        }
                                }
                            }
                        }

                        /*
                         * RECORDING
                         *
                         * application capture streams.
                         *
                         * فقط وقتی حداقل یک
                         * recording stream وجود دارد.
                         */
                        ColumnLayout {
                            Layout.fillWidth: true

                            visible:
                                root.recordingStreams.length > 0

                            spacing: 6

                            Text {
                                Layout.fillWidth: true

                                text:
                                    "RECORDING"

                                font.family:
                                    "FiraCode Nerd Font Propo"

                                font.pixelSize: 11
                                font.weight: 700

                                color:
                                    "#aaaaaa"
                            }

                            ColumnLayout {
                                Layout.fillWidth: true

                                spacing: 6

                                Repeater {
                                    model:
                                        root.recordingStreams

                                    delegate:
                                        AudioControl {
                                            required property var modelData
                                            required property int index

                                            Layout.fillWidth: true

                                            node:
                                                modelData

                                            title:
                                                root.applicationName(
                                                    modelData
                                                )

                                            selected: {
                                                var base = 0

                                                if (root.output)
                                                    base += 1

                                                if (root.microphone)
                                                    base += 1

                                                base +=
                                                    root.applicationStreams.length

                                                return (
                                                    root.keyboardNavigation &&
                                                    root.selectedIndex ===
                                                    base + index
                                                )
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

    component AudioControl: Item {
        id: control

        property var node: null
        property string title: "UNKNOWN"
        property bool selected: false

        implicitHeight: 48

        PwObjectTracker {
            objects:
                control.node
                ? [control.node]
                : []
        }

        function volumePercent() {
            if (
                !control.node ||
                !control.node.audio
            )
                return 0

            return Math.round(
                control.node.audio.volume * 100
            )
        }

        function setVolumePercent(value) {
            if (
                !control.node ||
                !control.node.audio
            )
                return

            var next =
                Math.round(value / 5) * 5

            next =
                Math.max(
                    0,
                    Math.min(100, next)
                )

            control.node.audio.volume =
                next / 100
        }

        function changeVolume(delta) {
            setVolumePercent(
                volumePercent() + delta
            )
        }

        function toggleMute() {
            if (
                !control.node ||
                !control.node.audio
            )
                return

            control.node.audio.muted =
                !control.node.audio.muted
        }

        /*
         * Wheel handler پشت محتوای کنترل است.
         *
         * بنابراین slider و mute button
         * event موس خودشان را می‌گیرند.
         */
        MouseArea {
            id: wheelArea

            anchors.fill: parent

            acceptedButtons:
                Qt.NoButton

            cursorShape:
                Qt.PointingHandCursor

            z: -1

            onWheel: function(wheel) {
                if (
                    wheel.angleDelta.y > 0
                ) {
                    control.changeVolume(5)
                } else if (
                    wheel.angleDelta.y < 0
                ) {
                    control.changeVolume(-5)
                }
            }
        }

        Rectangle {
            anchors.fill: parent

            color:
                control.selected
                ? "#ffffff"
                : "#00000000"

            border.width: 1

            border.color:
                control.selected
                ? "#ffffff"
                : "#33ffffff"

            radius: 0
        }

        RowLayout {
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter:
                    parent.verticalCenter

                leftMargin: 8
                rightMargin: 8
            }

            spacing: 8

            Text {
                Layout.preferredWidth: 105
                Layout.maximumWidth: 105

                text:
                    control.title

                elide:
                    Text.ElideRight

                verticalAlignment:
                    Text.AlignVCenter

                font.family:
                    "FiraCode Nerd Font Propo"

                font.pixelSize: 10
                font.weight: 700

                color:
                    control.selected
                    ? "#000000"
                    : "#ffffff"

                MouseArea {
                    anchors.fill: parent

                    acceptedButtons:
                        Qt.NoButton

                    cursorShape:
                        Qt.PointingHandCursor
                }
            }

            /*
             * SLIDER
             */
            Item {
                id: sliderArea

                Layout.fillWidth: true

                Layout.preferredHeight: 30

                Rectangle {
                    id: sliderBackground

                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter:
                            parent.verticalCenter
                    }

                    height: 5

                    color:
                        control.selected
                        ? "#555555"
                        : "#333333"
                }

                Rectangle {
                    id: sliderFill

                    anchors {
                        left:
                            sliderBackground.left

                        verticalCenter:
                            sliderBackground.verticalCenter
                    }

                    width:
                        sliderBackground.width *
                        (
                            control.volumePercent() /
                            100
                        )

                    height: 5

                    color:
                        control.selected
                        ? "#000000"
                        : "#ffffff"
                }

                Rectangle {
                    id: sliderHandle

                    width: 11
                    height: 11

                    radius: 0

                    x:
                        sliderBackground.x +
                        (
                            sliderBackground.width *
                            control.volumePercent() /
                            100
                        ) -
                        width / 2

                    anchors.verticalCenter:
                        sliderBackground.verticalCenter

                    color:
                        control.selected
                        ? "#000000"
                        : "#ffffff"
                }

                MouseArea {
                    id: sliderMouseArea

                    anchors.fill: parent

                    acceptedButtons:
                        Qt.LeftButton

                    hoverEnabled: true

                    cursorShape:
                        Qt.PointingHandCursor

                    function setFromMouse(mouseX) {
                        if (
                            sliderBackground.width <= 0
                        )
                            return

                        var x =
                            mouseX -
                            sliderBackground.x

                        x =
                            Math.max(
                                0,
                                Math.min(
                                    sliderBackground.width,
                                    x
                                )
                            )

                        var percent =
                            (
                                x /
                                sliderBackground.width
                            ) * 100

                        var snapped =
                            Math.round(
                                percent / 5
                            ) * 5

                        control.setVolumePercent(
                            snapped
                        )
                    }

                    onPressed: function(mouse) {
                        root.keyboardNavigation = false

                        setFromMouse(mouse.x)
                    }

                    onPositionChanged: function(mouse) {
                        if (pressed)
                            setFromMouse(mouse.x)
                    }
                }
            }

            BarNumberStyle {
                Layout.preferredWidth: 35

                text:
                    control.volumePercent()

                textColor:
                    control.selected
                    ? "#000000"
                    : "#ffffff"

                textStyleColor:
                    control.selected
                    ? "#000000"
                    : "#ffffff"
            }

            Text {
                Layout.preferredWidth: 10

                text:
                    "%"

                font.family:
                    "FiraCode Nerd Font Propo"

                font.pixelSize: 10
                font.weight: 700

                color:
                    control.selected
                    ? "#000000"
                    : "#ffffff"
            }

            /*
             * MUTE BUTTON
             */
            Item {
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30

                Rectangle {
                    anchors.fill: parent

                    color:
                        control.selected
                        ? "#000000"
                        : "#00000000"

                    border.width: 1

                    border.color:
                        "#ffffff"

                    radius: 0
                }

                Text {
                    anchors.centerIn: parent

                    text:
                        control.node &&
                        control.node.audio &&
                        control.node.audio.muted
                        ? ""
                        : ""

                    font.family:
                        "FiraCode Nerd Font Propo"

                    font.pixelSize: 13
                    font.weight: 700

                    color:
                        "#ffffff"
                }

                MouseArea {
                    anchors.fill: parent

                    acceptedButtons:
                        Qt.LeftButton

                    cursorShape:
                        Qt.PointingHandCursor

                    onClicked: {
                        root.keyboardNavigation = false

                        control.toggleMute()
                    }
                }
            }
        }
    }

    onMenuVisibleChanged: {
        if (menuVisible) {
            refreshStreams()

            Qt.callLater(function() {
                menuArea.forceActiveFocus()
            })
        }
    }
}
