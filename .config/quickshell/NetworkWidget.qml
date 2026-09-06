import QtQuick
import Quickshell.Io
import Quickshell.Networking

Item {
    id: root

    implicitWidth: networkText.implicitWidth
    implicitHeight: networkText.implicitHeight

    readonly property var devices: Networking.devices.values

    readonly property var wifiDevice: {
        for (const device of devices) {
            if (
                device.type === DeviceType.Wifi
                && device.connected
            )
                return device
        }

        return null
    }

    readonly property var ethernetDevice: {
        for (const device of devices) {
            if (
                device.type === DeviceType.Wired
                && device.connected
            )
                return device
        }

        return null
    }

    readonly property var connectedWifi: {
        if (!wifiDevice)
            return null

        const networks = wifiDevice.networks.values

        for (const network of networks) {
            if (network.connected)
                return network
        }

        return null
    }

    readonly property int wifiSignal: {
        if (!connectedWifi)
            return 0

        return Math.round(
            connectedWifi.signalStrength * 100
        )
    }

    function openNmtui() {
        nmtuiProcess.running = false
        nmtuiProcess.running = true
    }

    function toggleWifi() {
        wifiToggleProcess.running = false
        wifiToggleProcess.running = true
    }

    BarIconStyle {
        id: networkText

        anchors.centerIn: parent

        text: {
            if (root.connectedWifi)
                return "" + root.wifiSignal + "%"

            if (root.ethernetDevice)
                return ""

            return ""
        }
    }

    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.AllButtons
        cursorShape: Qt.PointingHandCursor

        onClicked: function(mouse) {
            switch (mouse.button) {
            case Qt.RightButton:
                root.openNmtui()
                break

            case Qt.MiddleButton:
                root.toggleWifi()
                break
            }
        }

        onWheel: function(wheel) {
            // Intentionally unused.
        }
    }

    Process {
        id: nmtuiProcess

        command: [
            "ghostty",
            "-e",
            "nmtui"
        ]
    }

    Process {
        id: wifiToggleProcess

        command: [
            "/home/dash-/.config/hypr/wifi-toggle.sh"
        ]
    }
}
