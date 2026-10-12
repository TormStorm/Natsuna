/*
 * SPDX-FileCopyrightText: 2022 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.ki18n
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols
import org.kde.haruna
import org.kde.haruna.utilities

SettingsBasePage {
    id: root

    onVisibleChanged: {
        if (!visible) {
            Models.proxyActionsModel.setNameFilter("")
        }
    }

    header: PrefPageHeader {
        width: parent.width
        text: KI18n.i18nc("@title", "Shortcuts")

        Kirigami.SearchField {
            id: searchField

            focus: true
            placeholderText: KI18n.i18nc("@info:placeholder", "Search shortcuts…")
            onTextChanged: Models.proxyActionsModel.setNameFilter(text)
            onAccepted: Models.proxyActionsModel.setNameFilter(text)
            Layout.fillWidth: true
            KeyNavigation.up: actionsListView
            KeyNavigation.down: actionsListView
            Component.onCompleted: forceActiveFocus()
        }
    }

    ListView {
        id: actionsListView

        model: Models.proxyActionsModel
        reuseItems: true
        delegate: ItemDelegate {
            id: delegate

            required property int index
            required property string actionName
            required property string actionText
            required property string actionDescription
            required property string actionShortcut
            required property string actionIcon
            required property string actionType

            // same centred width as the other preferences pages
            width: Math.min(actionsListView.width - Kirigami.Units.gridUnit * 2, PrefStyle.contentWidth)
            x: (actionsListView.width - width) / 2

            contentItem: RowLayout {
                Kirigami.IconTitleSubtitle {
                    title: delegate.actionText
                    icon.name: delegate.actionIcon

                    Layout.fillWidth: true
                }

                KeySequenceItem {
                    checkForConflictsAgainst: ShortcutType.None
                    patterns: ShortcutPattern.Key | ShortcutPattern.ModifierAndKey
                    keySequence: MiscUtils.stringToKeySequence(delegate.actionShortcut)

                    onKeySequenceModified: {
                        const keySequenceString = MiscUtils.keySequenceToString(keySequence)
                        if (keySequenceString === "" ) {
                            return
                        }

                        if (keySequenceString !== delegate.actionShortcut) {
                            if (!Models.proxyActionsModel.saveShortcut(delegate.index, keySequence)) {
                                keySequence = MiscUtils.stringToKeySequence(delegate.actionShortcut)
                            }
                        }
                    }
                }
            }
        }
        KeyNavigation.down: searchField
        KeyNavigation.up: searchField
        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_End) {
                actionsListView.currentIndex = actionsListView.count - 1
                actionsListView.positionViewAtIndex(actionsListView.currentIndex,ListView.Center)
            }
            if (event.key === Qt.Key_Home) {
                actionsListView.currentIndex = 0
                actionsListView.positionViewAtIndex(actionsListView.currentIndex,ListView.Center)
            }
        }
    }
}
