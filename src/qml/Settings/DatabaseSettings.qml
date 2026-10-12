/*
 * SPDX-FileCopyrightText: 2023 George Florea Bănuș <georgefb899@gmail.com>
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.ki18n
import org.kde.kirigami as Kirigami

import org.kde.haruna

SettingsBasePage {
    id: root

    ColumnLayout {
        spacing: PrefStyle.sectionSpacing

        PrefHeading {
            text: KI18n.i18nc("@title", "Database")
        }

        PrefSection {
            title: KI18n.i18nc("@title", "Stored data")

            PrefRow {
                title: KI18n.i18nc("@label", "Recent files")
                description: KI18n.i18nc("@info", "Delete the list of recently opened files.")

                Button {
                    text: KI18n.i18nc("@action:button", "Clear")
                    icon.name: "edit-clear-history"
                    onClicked: Models.recentFilesModel.deleteEntries()
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label", "Metadata")
                description: KI18n.i18nc("@info", "Delete cached titles, durations and other file information.")

                Button {
                    text: KI18n.i18nc("@action:button", "Clear")
                    icon.name: "edit-clear-history"
                    onClicked: Database.deleteAllMetadata()
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label", "Playback positions")
                description: KI18n.i18nc("@info", "Forget where you stopped watching every file.")

                Button {
                    text: KI18n.i18nc("@action:button", "Clear")
                    icon.name: "edit-clear-history"
                    onClicked: Database.deletePlaybackPositions()
                }
            }
        }
    }
}
