/*
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 * Based on Haruna's FileMenu.qml by George Florea Bănuș
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import org.kde.ki18n

import org.kde.haruna

// VLC: Media
Menu {
    id: root

    title: KI18n.i18nc("@title:menu", "&Media")

    MenuItem {
        action: HarunaApp.actions.openFileAction
        text: KI18n.i18nc("@action:inmenu", "Open File…")
    }
    MenuItem {
        action: HarunaApp.actions.openUrlAction
        text: KI18n.i18nc("@action:inmenu", "Open Network Stream…")
    }

    MenuSeparator {}

    Menu {
        id: recentFilesMenu

        title: KI18n.i18nc("@title:menu", "Open Recent Media")

        onAboutToShow: instantiator.model = Models.recentFilesModel

        Instantiator {
            id: instantiator

            model: 0
            delegate: MenuItem {
                id: delegate

                required property string url
                required property string toolTipText
                required property string filename

                text: delegate.filename
                onClicked: {
                    recentFilesMenu.dismiss()
                    HarunaApp.openRecentFile(delegate.url)
                }

                ToolTip {
                    text: delegate.toolTipText
                }
            }
            onObjectAdded: (index, object) => recentFilesMenu.insertItem(index, object)
            onObjectRemoved: (index, object) => recentFilesMenu.removeItem(object)
        }

        MenuSeparator {}

        MenuItem {
            text: KI18n.i18nc("@action:inmenu", "Clear")
            onClicked: Models.recentFilesModel.deleteEntries()
        }
    }

    MenuSeparator {}

    MenuItem { action: HarunaApp.actions.quitApplicationAction }
}
