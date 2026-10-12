/*
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.kirigami as Kirigami

// Page title for list-style preferences pages (used as the page `header`),
// matching the heading and width of the form pages. Extra items placed
// inside (e.g. a search field) appear under the title.
Control {
    id: root

    property string text
    default property alias extraContent: extra.data

    topPadding: Kirigami.Units.gridUnit
    bottomPadding: Kirigami.Units.largeSpacing
    leftPadding: Kirigami.Units.gridUnit
    rightPadding: Kirigami.Units.gridUnit

    contentItem: ColumnLayout {
        spacing: Kirigami.Units.largeSpacing

        Kirigami.Heading {
            text: root.text
            level: 1
            Layout.fillWidth: true
            Layout.maximumWidth: PrefStyle.contentWidth
            Layout.alignment: Qt.AlignHCenter
        }

        ColumnLayout {
            id: extra

            visible: children.length > 0
            Layout.fillWidth: true
            Layout.maximumWidth: PrefStyle.contentWidth
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
