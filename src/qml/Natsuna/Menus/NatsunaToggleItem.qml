/*
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

// A checkable menu item whose check mark always reflects `isOn`.
// Clicking runs the item's action; the action changes the real state,
// and the binding below keeps the check mark in sync with it.
MenuItem {
    id: root

    property bool isOn: false

    checkable: true
    checked: root.isOn
    onToggled: root.checked = Qt.binding(() => root.isOn)

    // Assigning an `action` copies the action's (non-checkable) state onto
    // the item, so restore checkability and the binding once everything is set.
    Component.onCompleted: {
        root.checkable = true
        root.checked = Qt.binding(() => root.isOn)
    }
}
