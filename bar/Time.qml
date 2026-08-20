pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string timeString: {
        Qt.formatDateTime(clock.date, "hh:mm");
    }

    readonly property string dateString: {
        Qt.formatDateTime(clock.date, "d ddd MMM");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
