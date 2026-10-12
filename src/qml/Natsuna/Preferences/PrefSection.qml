/*
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.kirigami as Kirigami

// A titled group of settings drawn as a rounded card.
// Put PrefRow items (or anything else) inside it.
ColumnLayout {
    id: root

    property string title
    default property alias rows: rowsColumn.data

    spacing: Kirigami.Units.smallSpacing
    Layout.fillWidth: true
    Layout.maximumWidth: PrefStyle.contentWidth
    Layout.alignment: Qt.AlignHCenter

    Label {
        text: root.title
        visible: root.title !== ""
        font.weight: Font.DemiBold
        opacity: 0.8
        Layout.leftMargin: Kirigami.Units.smallSpacing
        Layout.topMargin: Kirigami.Units.largeSpacing
    }

    Rectangle {
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        Kirigami.Theme.inherit: false

        color: Kirigami.Theme.backgroundColor
        radius: Kirigami.Units.cornerRadius * 2
        border.width: 1
        border.color: Qt.alpha(Kirigami.Theme.textColor, 0.12)
        implicitHeight: rowsColumn.implicitHeight + PrefStyle.cardPadding * 2

        Layout.fillWidth: true

        ColumnLayout {
            id: rowsColumn

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: PrefStyle.cardPadding
            }
            spacing: PrefStyle.rowSpacing
        }
    }
}
