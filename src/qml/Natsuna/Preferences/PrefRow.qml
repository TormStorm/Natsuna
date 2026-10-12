/*
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.kirigami as Kirigami

import org.kde.haruna

// One setting: the name (plus optional description and help) on the left,
// its control(s) on the right. With `stacked: true` the controls go below
// the name and can use the full width (for long text fields and lists).
GridLayout {
    id: root

    property string title
    property string description
    property string help
    property int helpWidth: 400
    property bool helpIsWarning: false
    property bool indented: false
    property bool stacked: false
    default property alias controls: controlsRow.data

    columns: root.stacked ? 1 : 2
    columnSpacing: Kirigami.Units.gridUnit
    rowSpacing: Kirigami.Units.smallSpacing
    Layout.fillWidth: true

    ColumnLayout {
        spacing: 0
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: root.indented ? Kirigami.Units.gridUnit * 1.5 : 0

        // The title wraps to the available width; the help icon sits right
        // after the text (positioned manually so it can't cause a layout loop).
        Label {
            id: titleLabel

            readonly property real helpSpace: helpButton.visible ? helpButton.width + Kirigami.Units.smallSpacing : 0

            text: root.title
            visible: root.title !== ""
            wrapMode: Text.Wrap
            rightPadding: helpSpace
            Layout.fillWidth: true

            ToolTipButton {
                id: helpButton

                visible: root.help !== ""
                toolTipText: root.help
                toolTipWidth: root.helpWidth
                icon.width: Kirigami.Units.iconSizes.small
                icon.height: Kirigami.Units.iconSizes.small
                icon.color: root.helpIsWarning ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.textColor
                display: AbstractButton.IconOnly
                padding: 2
                width: Kirigami.Units.iconSizes.small + 4
                height: Kirigami.Units.iconSizes.small + 4
                x: Math.min(titleLabel.contentWidth, titleLabel.width - titleLabel.helpSpace) + Kirigami.Units.smallSpacing
                y: (titleLabel.font.pixelSize > 0 ? titleLabel.font.pixelSize * 1.35 : 18) / 2 - height / 2
            }
        }

        Label {
            text: root.description
            visible: root.description !== ""
            wrapMode: Text.Wrap
            textFormat: Text.StyledText
            font: Kirigami.Theme.smallFont
            opacity: 0.7
            Layout.fillWidth: true
        }
    }

    RowLayout {
        id: controlsRow

        spacing: Kirigami.Units.smallSpacing
        Layout.fillWidth: root.stacked
        Layout.alignment: root.stacked ? Qt.AlignLeft : (Qt.AlignRight | Qt.AlignVCenter)
        Layout.leftMargin: root.stacked && root.indented ? Kirigami.Units.gridUnit * 1.5 : 0
    }
}
