import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import Quickshell.Io

Item {
    id: root

    property var selectedDevice: null

    signal deviceRequested(var device)

    property bool menuVisible: false
    property bool windowVisible: false

    property string interfaceName: ""
    property string ipAddress: "—"

    property real downloadBytes: 0
    property real uploadBytes: 0

    property real previousRx: -1
    property real previousTx: -1
    property double previousTime: 0

    readonly property var selectedNetwork: {
        if (!root.selectedDevice)
            return null

        if (
            root.selectedDevice.type === DeviceType.Wired
        ) {
            return root.selectedDevice.network
        }

        for (
            const network
            of root.selectedDevice.networks.values
        ) {
            if (network.connected)
                return network
        }

        return null
    }

    readonly property var availableNetworks: {
        if (!root.selectedDevice)
            return []

        return root.selectedDevice.networks.values
    }

    function toggle() {
        if (root.menuVisible) {
            root.close()
            return
        }

        root.refresh()

        root.windowVisible = true
        root.menuVisible = true

        refreshTimer.start()
    }

    function close() {
        root.menuVisible = false
        refreshTimer.stop()
    }

    function selectNetwork(network) {
        if (!network)
            return

        root.deviceRequested(
            network.device
        )

        root.refresh()
    }

    function connectNetwork(network) {
        if (!network)
            return

        if (network.stateChanging)
            return

        network.connect()
    }

    function disconnectNetwork(network) {
        if (!network)
            return

        if (network.stateChanging)
            return

        network.disconnect()
    }

    function refresh() {
        if (!root.selectedDevice) {
            root.interfaceName = ""
            root.ipAddress = "—"
            root.downloadBytes = 0
            root.uploadBytes = 0
            root.previousRx = -1
            root.previousTx = -1
            return
        }

        root.interfaceName =
            root.selectedDevice.name

        networkStatsProcess.command = [
            "sh",
            "-c",
            "iface=\"$1\"; " +
            "ipaddr=$(ip -4 -o addr show dev \"$iface\" | " +
            "awk '{print $4}' | cut -d/ -f1 | head -n1); " +
            "rx=$(cat \"/sys/class/net/$iface/statistics/rx_bytes\" 2>/dev/null || echo 0); " +
            "tx=$(cat \"/sys/class/net/$iface/statistics/tx_bytes\" 2>/dev/null || echo 0); " +
            "printf '%s\\n%s\\n%s\\n' \"$ipaddr\" \"$rx\" \"$tx\"",
            "network-stats",
            root.selectedDevice.name
        ]

        networkStatsProcess.running = false
        networkStatsProcess.running = true
    }

    function formatSpeed(bytesPerSecond) {
        if (bytesPerSecond < 1024)
            return Math.round(bytesPerSecond) + " B/s"

        if (bytesPerSecond < 1024 * 1024)
            return (
                bytesPerSecond / 1024
            ).toFixed(1) + " KB/s"

        if (bytesPerSecond < 1024 * 1024 * 1024)
            return (
                bytesPerSecond / (1024 * 1024)
            ).toFixed(1) + " MB/s"

        return (
            bytesPerSecond
            / (1024 * 1024 * 1024)
        ).toFixed(1) + " GB/s"
    }

    function networkType(device) {
        if (!device)
            return "Unknown"

        if (device.type === DeviceType.Wifi)
            return "Wi-Fi"

        if (device.type === DeviceType.Wired)
            return "Ethernet"

        return "Unknown"
    }

    function networkState(network) {
        if (!network)
            return "Disconnected"

        switch (network.state) {
        case ConnectionState.Connecting:
            return "Connecting"

        case ConnectionState.Connected:
            return "Connected"

        case ConnectionState.Disconnecting:
            return "Disconnecting"

        case ConnectionState.Disconnected:
            return "Disconnected"

        case ConnectionState.Failed:
            return "Failed"

        case ConnectionState.Unknown:
            return "Unknown"

        default:
            return "Unknown"
        }
    }

    function networkSignal(network) {
        if (
            !network
            || !network.device
            || network.device.type !== DeviceType.Wifi
        )
            return ""

        return (
            Math.round(
                network.signalStrength * 100
            ) + "%"
        )
    }

    function selectedNetworkName() {
        if (!root.selectedNetwork)
            return "No connection"

        return root.selectedNetwork.name
    }

    PanelWindow {
        id: networkWindow

        screen: Quickshell.screens.length > 0
            ? Quickshell.screens[0]
            : null

        visible: root.windowVisible

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

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton

                onClicked: {
                    if (
                        mouseX < networkContainer.x
                        || mouseX > networkContainer.x
                            + networkContainer.width
                        || mouseY < networkContainer.y
                        || mouseY > networkContainer.y
                            + networkContainer.height
                    ) {
                        root.close()
                    }
                }
            }

            Item {
                id: networkContainer

                width: 360

                height:
                    networkContent.implicitHeight
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
                    id: networkContent

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: 12
                    }

                    implicitHeight:
                        networkLayout.implicitHeight

                    ColumnLayout {
                        id: networkLayout

                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                        }

                        spacing: 10

                        Text {
                            Layout.fillWidth: true

                            text: root.selectedNetworkName()

                            font.family: "OCRA"
                            font.pixelSize: 14
                            font.weight: 700

                            color: "#ffffff"

                            elide: Text.ElideRight
                        }

                        Rectangle {
                            Layout.fillWidth: true

                            height: 1

                            color: "#ffffff"
                        }

                        NetworkInfoRow {
                            label: "TYPE"

                            value:
                                root.networkType(
                                    root.selectedDevice
                                )
                        }

                        NetworkInfoRow {
                            label: "STATE"

                            value:
                                root.networkState(
                                    root.selectedNetwork
                                )
                        }

                        NetworkInfoRow {
                            label: "IF"

                            value:
                                root.selectedDevice
                                ? root.selectedDevice.name
                                : "—"
                        }

                        NetworkInfoRow {
                            label: "IP"

                            value: root.ipAddress
                        }

                        NetworkInfoRow {
                            label: "DOWN"

                            value:
                                root.formatSpeed(
                                    root.downloadBytes
                                )
                        }

                        NetworkInfoRow {
                            label: "UP"

                            value:
                                root.formatSpeed(
                                    root.uploadBytes
                                )
                        }

                        NetworkInfoRow {
                            visible:
                                root.selectedNetwork
                                && root.selectedDevice
                                && root.selectedDevice.type
                                    === DeviceType.Wifi

                            label: "SIGNAL"

                            value:
                                root.networkSignal(
                                    root.selectedNetwork
                                )
                        }

                        NetworkInfoRow {
                            visible:
                                root.selectedDevice
                                && root.selectedDevice.type
                                    === DeviceType.Wired

                            label: "LINK"

                            value: {
                                if (
                                    !root.selectedDevice
                                    || !root.selectedDevice.hasLink
                                )
                                    return "No link"

                                return (
                                    root.selectedDevice.linkSpeed
                                    + " Mbps"
                                )
                            }
                        }

                        Item {
                            Layout.fillWidth: true

                            implicitHeight: 30

                            visible:
                                root.selectedNetwork !== null

                            Rectangle {
                                anchors.fill: parent

                                color: "#00000000"

                                border.width: 1
                                border.color: "#ffffff"

                                radius: 0
                            }

                            Text {
                                anchors.centerIn: parent

                                text:
                                    root.selectedNetwork
                                    && root.selectedNetwork.connected
                                    ? "DISCONNECT"
                                    : "CONNECT"

                                font.family: "OCRA"
                                font.pixelSize: 11
                                font.weight: 700

                                color: "#ffffff"
                            }

                            MouseArea {
                                anchors.fill: parent

                                cursorShape:
                                    Qt.PointingHandCursor

                                onClicked: {
                                    if (
                                        !root.selectedNetwork
                                    )
                                        return

                                    if (
                                        root.selectedNetwork.connected
                                    ) {
                                        root.disconnectNetwork(
                                            root.selectedNetwork
                                        )
                                    } else {
                                        root.connectNetwork(
                                            root.selectedNetwork
                                        )
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true

                            height: 1

                            color: "#ffffff"
                        }

                        Text {
                            Layout.fillWidth: true

                            text: "CONNECTIONS"

                            font.family: "OCRA"
                            font.pixelSize: 10
                            font.weight: 700

                            color: "#99ffffff"
                        }

                        ColumnLayout {
                            Layout.fillWidth: true

                            spacing: 5

                            Repeater {
                                model:
                                    root.availableNetworks

                                Item {
                                    Layout.fillWidth: true

                                    implicitHeight: 32

                                    Rectangle {
                                        anchors.fill: parent

                                        color: "#00000000"

                                        border.width: 1
                                        border.color:
                                            modelData
                                            === root.selectedNetwork
                                            ? "#ffffff"
                                            : "#66ffffff"

                                        radius: 0
                                    }

                                    RowLayout {
                                        anchors.fill: parent

                                        anchors.leftMargin: 8
                                        anchors.rightMargin: 8

                                        spacing: 8

                                        Text {
                                            Layout.fillWidth: true

                                            text: modelData.name

                                            font.family: "OCRA"
                                            font.pixelSize: 10
                                            font.weight: 700

                                            color: "#ffffff"

                                            elide:
                                                Text.ElideRight
                                        }

                                        Text {
                                            visible:
                                                modelData.device
                                                && modelData.device.type
                                                    === DeviceType.Wifi

                                            text:
                                                Math.round(
                                                    modelData.signalStrength
                                                    * 100
                                                ) + "%"

                                            font.family: "OCRA"
                                            font.pixelSize: 9
                                            font.weight: 700

                                            color: "#99ffffff"
                                        }

                                        Text {
                                            text:
                                                root.networkState(
                                                    modelData
                                                )

                                            font.family: "OCRA"
                                            font.pixelSize: 9
                                            font.weight: 700

                                            color:
                                                modelData.connected
                                                ? "#ffffff"
                                                : "#99ffffff"
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent

                                        cursorShape:
                                            Qt.PointingHandCursor

                                        onClicked: {
                                            root.selectNetwork(
                                                modelData
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

    component NetworkInfoRow: RowLayout {
        property string label: ""
        property string value: ""

        Layout.fillWidth: true

        Text {
            Layout.preferredWidth: 70

            text: parent.label

            font.family: "OCRA"
            font.pixelSize: 10
            font.weight: 700

            color: "#99ffffff"
        }

        Text {
            Layout.fillWidth: true

            text: parent.value

            horizontalAlignment:
                Text.AlignRight

            font.family: "OCRA"
            font.pixelSize: 11
            font.weight: 700

            color: "#ffffff"

            elide: Text.ElideRight
        }
    }

    Timer {
        id: refreshTimer

        interval: 1000
        repeat: true

        onTriggered: {
            root.refresh()
        }
    }

    Process {
        id: networkStatsProcess

        stdout: StdioCollector {
            onStreamFinished: {
                var lines = this.text
                    .trim()
                    .split("\n")

                if (lines.length < 3)
                    return

                root.ipAddress =
                    lines[0].trim() || "—"

                var rx =
                    Number(lines[1].trim())

                var tx =
                    Number(lines[2].trim())

                var now = Date.now()

                if (
                    root.previousRx >= 0
                    && root.previousTx >= 0
                    && root.previousTime > 0
                ) {
                    var elapsed =
                        (now - root.previousTime)
                        / 1000

                    if (elapsed > 0) {
                        root.downloadBytes =
                            Math.max(
                                0,
                                (rx - root.previousRx)
                                / elapsed
                            )

                        root.uploadBytes =
                            Math.max(
                                0,
                                (tx - root.previousTx)
                                / elapsed
                            )
                    }
                }

                root.previousRx = rx
                root.previousTx = tx
                root.previousTime = now
            }
        }
    }
}
