/*
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami

// Large title at the top of a preferences page.
Kirigami.Heading {
    level: 1
    Layout.fillWidth: true
    Layout.maximumWidth: PrefStyle.contentWidth
    Layout.alignment: Qt.AlignHCenter
    Layout.bottomMargin: Kirigami.Units.smallSpacing
}
