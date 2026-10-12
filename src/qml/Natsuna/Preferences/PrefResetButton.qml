/*
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls

import org.kde.ki18n
import org.kde.kirigami as Kirigami

// Small "reset to default" button used next to a setting's control.
ToolButton {
    id: root

    icon.name: "edit-reset"
    display: AbstractButton.IconOnly
    text: KI18n.i18nc("@info:tooltip", "Reset to default value")

    ToolTip.text: root.text
    ToolTip.visible: root.hovered
    ToolTip.delay: Kirigami.Units.toolTipDelay
}
