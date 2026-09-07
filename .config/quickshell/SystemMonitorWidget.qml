import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property real cpuUsage: 0
    property real memoryUsage: 0
    property real cpuTemperature: 0

    property real previousCpuTotal: 0
    property real previousCpuIdle: 0

    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    FileView {
        id: cpuFile

        path: "/proc/stat"

        onLoaded: {
            var lines = text().split("\n")

            if (lines.length === 0)
                return

            var parts = lines[0].trim().split(/\s+/)

            if (parts.length < 8 || parts[0] !== "cpu")
                return

            var user = Number(parts[1])
            var nice = Number(parts[2])
            var system = Number(parts[3])
            var idle = Number(parts[4])
            var iowait = Number(parts[5])
            var irq = Number(parts[6])
            var softirq = Number(parts[7])
            var steal = parts.length > 8 ? Number(parts[8]) : 0

            var total =
                user +
                nice +
                system +
                idle +
                iowait +
                irq +
                softirq +
                steal

            var idleTotal = idle + iowait

            if (root.previousCpuTotal > 0) {
                var totalDelta =
                    total - root.previousCpuTotal

                var idleDelta =
                    idleTotal - root.previousCpuIdle

                if (totalDelta > 0) {
                    root.cpuUsage = Math.max(
                        0,
                        Math.min(
                            100,
                            (1 - idleDelta / totalDelta) * 100
                        )
                    )
                }
            }

            root.previousCpuTotal = total
            root.previousCpuIdle = idleTotal
        }
    }

    FileView {
        id: memoryFile

        path: "/proc/meminfo"

        onLoaded: {
            var lines = text().split("\n")
            var total = 0
            var available = 0

            for (var i = 0; i < lines.length; i++) {
                var line = lines[i]

                if (line.indexOf("MemTotal:") === 0) {
                    total = Number(
                        line
                            .replace("MemTotal:", "")
                            .trim()
                            .split(/\s+/)[0]
                    )
                }

                if (line.indexOf("MemAvailable:") === 0) {
                    available = Number(
                        line
                            .replace("MemAvailable:", "")
                            .trim()
                            .split(/\s+/)[0]
                    )
                }
            }

            if (total > 0) {
                root.memoryUsage = Math.max(
                    0,
                    Math.min(
                        100,
                        (1 - available / total) * 100
                    )
                )
            }
        }
    }

    FileView {
        id: temperatureFile

        path: "/sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input"

        onLoaded: {
            var value = Number(text().trim())

            if (!isNaN(value) && value > 0)
                root.cpuTemperature = value / 1000
        }
    }

    Timer {
        interval: 700
        running: true
        repeat: true

        onTriggered: {
            cpuFile.reload()
            memoryFile.reload()
            temperatureFile.reload()
        }
    }

    Component.onCompleted: {
        cpuFile.reload()
        memoryFile.reload()
        temperatureFile.reload()
    }

    Row {
        id: content

        spacing: 8

        Row {
            spacing: 2

            BarTextStyle {
                text: ""
            }

            BarNumberStyle {
                text: Math.round(root.cpuUsage)
            }

            BarTextStyle {
                text: "%"
            }
        }

        Row {
            spacing: 2

            BarTextStyle {
                text: root.cpuTemperature >= 70
                    ? ""
                    : ""

                textColor: root.cpuTemperature >= 70
                    ? "#ff5555"
                    : "#ffffff"
            }

            BarNumberStyle {
                text: Math.round(root.cpuTemperature)

                textColor: root.cpuTemperature >= 70
                    ? "#ff5555"
                    : "#ffffff"
            }

            BarIconStyle {
                text: "󰔄"
            }
        }

        Row {
            spacing: 2

            BarTextStyle {
                text: ""
            }

            BarNumberStyle {
                text: Math.round(root.memoryUsage)
            }

            BarTextStyle {
                text: "%"
            }
        }
    }
}
