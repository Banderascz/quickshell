import QtQuick

QtObject {
    // Catppuccin Mocha base colors
    readonly property color bgBase: "#1e1e2e"        // base
    readonly property color bgSurface: "#313244"     // surface0
    readonly property color bgOverlay: "#cc181825"   // mantle + alpha
    readonly property color bgHover: "#45475a"       // surface1
    readonly property color bgSelected: "#585b70"    // surface2
    readonly property color bgBorder: "#45475a"

    // Text
    readonly property color textPrimary: "#cdd6f4"   // text
    readonly property color textSecondary: "#bac2de" // subtext1
    readonly property color textMuted: "#7f849c"     // overlay1

    // Accents
    readonly property color accentPrimary: "#89b4fa" // blue
    readonly property color accentCyan: "#89dceb"    // sky
    readonly property color accentGreen: "#a6e3a1"   // green
    readonly property color accentOrange: "#fab387"  // peach
    readonly property color accentRed: "#f38ba8"     // red

    // Status
    readonly property color urgencyLow: textMuted
    readonly property color urgencyNormal: accentPrimary
    readonly property color urgencyCritical: accentRed

    readonly property color batteryGood: accentGreen
    readonly property color batteryWarning: accentOrange
    readonly property color batteryCritical: accentRed
}
