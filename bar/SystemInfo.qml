pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // property string cpuUsage: "0%"
    // property string memoryUsage: "0%"
    property string networkInfo: "Disconnected"
    property string networkType: "disconnected"
    property int batteryLevelRaw: 0
    property string batteryLevel: "0%"
    property string batteryIcon: "󰂎"
    property bool batteryCharging: false
    // property string temperature: "0°C"
    property string powerProfile: ""
    property string powerProfileIcon: ""
    property string powerColor: "red"
    property string keyboardLayout: "us"
    property string keyboardLayoutFlag: ""

    // Keyboard layout
    Process {
        id: keyLayout
        command: ["sh", "-c", "hyprctl devices -j | jq -r '.keyboards[] | select(.main) | .active_keymap' | cut -d' ' -f1"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const flag = text.trim();
                root.keyboardLayout = text.trim();
                if (flag == "English") {
                    root.keyboardLayoutFlag = Qt.resolvedUrl("../icons/us_flag.svg");
                } else if (flag == "Czech") {
                    root.keyboardLayoutFlag = Qt.resolvedUrl("../icons/cz_flag.svg");
                }
            }
        }
    }

    // Power profile
    Process {
        id: powProfile
        command: ["sh", "-c", "powerprofilesctl get"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const profile = text.trim();

                root.powerProfile = profile;

                if (profile === "power-saver") {
                    root.powerProfileIcon = "";
                    root.powerColor = "green";
                } else if (profile === "balanced") {
                    root.powerProfileIcon = "";
                    root.powerColor = "#E5C07B";
                } else if (profile === "performance") {
                    root.powerProfileIcon = "󰈸";
                    root.powerColor = "red";
                } else {
                    root.powerProfileIcon = "󰈸 else";
                    root.powerColor = "blue";
                }
            }
        }
    }

    // CPU Usage
    // Process {
    //     id: cpuProc
    //     command: ["sh", "-c", "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1\"%\"}'"]
    //     running: true
    //
    //     stdout: StdioCollector {
    //         onStreamFinished: {
    //             root.cpuUsage = text.trim();
    //         }
    //     }
    // }

    // Memory Usage
    // Process {
    //     id: memProc
    //     command: ["sh", "-c", "free | grep Mem | awk '{printf \"%.1f%%\", ($3/$2) * 100.0}'"]
    //     running: true
    //
    //     stdout: StdioCollector {
    //         onStreamFinished: {
    //             root.memoryUsage = text.trim();
    //         }
    //     }
    // }

    // Network Info (ethernet takes priority over wifi)
    Process {
        id: netProc

        command: ["sh", "-c", `
        dev=$(nmcli -t -f TYPE,STATE,CONNECTION device 2>/dev/null)

        ethernet=$(echo "$dev" | grep '^ethernet:connected')
        if [ -n "$ethernet" ]; then
            echo "ethernet:Ethernet"
            exit
        fi

        wifi=$(echo "$dev" | grep '^wifi:connected')
        if [ -n "$wifi" ]; then
            ssid=$(echo "$wifi" | cut -d: -f3-)
            echo "wifi:$ssid"
            exit
        fi

        echo "disconnected:Disconnected"
        `]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const result = text.trim();

                const parts = result.split(":");
                root.networkType = parts[0];
                root.networkInfo = parts.slice(1).join(":") || "Disconnected";
            }
        }
    }

    // Battery
    Process {
        id: batteryProc
        command: ["sh", "-c", "printf '%s\\n%s' \"$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo '99')\" \"$(cat /sys/class/power_supply/BAT*/status 2>/dev/null || echo 'Discharging')\""]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                const level = parseInt(lines[0]) || 0;
                const status = (lines[1] || "Discharging").trim();

                root.batteryLevelRaw = level;
                root.batteryLevel = level + "%";
                root.batteryCharging = status === "Charging";

                if (root.batteryCharging)
                    root.batteryIcon = "";
                else if (level >= 90)
                    root.batteryIcon = "󰁹";
                else if (level >= 80)
                    root.batteryIcon = "󰂂";
                else if (level >= 70)
                    root.batteryIcon = "󰂁";
                else if (level >= 60)
                    root.batteryIcon = "󰂀";
                else if (level >= 50)
                    root.batteryIcon = "󰁿";
                else if (level >= 40)
                    root.batteryIcon = "󰁾";
                else if (level >= 30)
                    root.batteryIcon = "󰁽";
                else if (level >= 20)
                    root.batteryIcon = "󰁼";
                else if (level >= 10)
                    root.batteryIcon = "󰁻";
                else
                    root.batteryIcon = "󰁺";
            }
        }
    }

    // Temperature
    // Process {
    //     id: tempProc
    //     command: ["sh", "-c", "sensors 2>/dev/null | grep -E 'Package id 0|Tctl' | head -1 | awk '{print $2}' | sed 's/+//' || echo 'N/A'"]
    //     running: true
    //
    //     stdout: StdioCollector {
    //         onStreamFinished: {
    //             root.temperature = text.trim() || "N/A";
    //         }
    //     }
    // }

    // Update timer
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            powProfile.running = true;
            // cpuProc.running = true
            // memProc.running = true
            netProc.running = true;
            batteryProc.running = true;
            // tempProc.running = true
            keyLayout.running = true;
        }
    }
}
