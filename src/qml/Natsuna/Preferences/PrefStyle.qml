/*
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

pragma Singleton

import QtQuick

import org.kde.kirigami as Kirigami

// Shared measurements so every preferences page lines up the same way.
QtObject {
    // the settings column never gets wider than this, and is centred
    readonly property real contentWidth: Kirigami.Units.gridUnit * 36
    // standard width for drop-downs and short text fields
    readonly property real fieldWidth: Kirigami.Units.gridUnit * 11
    readonly property real cardPadding: Kirigami.Units.largeSpacing * 1.5
    readonly property real rowSpacing: Kirigami.Units.largeSpacing * 1.5
    readonly property real sectionSpacing: Kirigami.Units.largeSpacing
}
