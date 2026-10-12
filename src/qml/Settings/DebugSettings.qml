/*
 * SPDX-FileCopyrightText: 2023 George Florea Bănuș <georgefb899@gmail.com>
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.ki18n
import org.kde.kirigami as Kirigami

import org.kde.haruna
import org.kde.haruna.utilities
import org.kde.haruna.settings

SettingsBasePage {
    id: root

    required property MpvVideo m_mpv

    component ConfigFileField: Kirigami.ActionTextField {
        id: configFileField

        property int configFile: PathUtils.ConfigFile.Main

        text: PathUtils.configFilePath(configFile)
        placeholderText: KI18n.i18nc("@info:placeholder", "Not created yet (using defaults)")
        readOnly: true
        Layout.fillWidth: true
        rightActions: [
            Kirigami.Action {
                icon.name: "document-open"
                visible: configFileField.text !== ""
                text: KI18n.i18nc("@info:tooltip", "Open file")
                onTriggered: {
                    const url = PathUtils.pathToUrl(PathUtils.configFilePath(configFileField.configFile))
                    Qt.openUrlExternally(url)
                }
            },
            Kirigami.Action {
                icon.name: "document-open-folder"
                visible: configFileField.text !== ""
                text: KI18n.i18nc("@info:tooltip", "Open containing folder")
                onTriggered: {
                    const path = PathUtils.configFilePath(configFileField.configFile)
                    PathUtils.highlightInFileManager(path)
                }
            }
        ]
    }

    ColumnLayout {
        spacing: PrefStyle.sectionSpacing

        PrefHeading {
            text: KI18n.i18nc("@title", "Debug")
        }

        PrefSection {
            title: KI18n.i18nc("@title", "Configuration files")

            PrefRow {
                title: KI18n.i18nc("@label:textbox", "Settings")
                stacked: true

                ConfigFileField {
                    configFile: PathUtils.ConfigFile.Main
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:textbox", "Custom commands")
                stacked: true

                ConfigFileField {
                    configFile: PathUtils.ConfigFile.CustomCommands
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:textbox", "Shortcuts")
                stacked: true

                ConfigFileField {
                    configFile: PathUtils.ConfigFile.Shortcuts
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:textbox", "Playlists")
                stacked: true

                ConfigFileField {
                    configFile: PathUtils.ConfigFile.PlaylistCache
                }
            }
        }
    }
}
