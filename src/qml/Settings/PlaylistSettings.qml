/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
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
import org.kde.haruna.settings

SettingsBasePage {
    id: root

    // A switch row bound to one boolean playlist setting
    component PlaylistSwitchRow: PrefRow {
        id: switchRow

        property bool value
        signal valueEdited(bool value)

        Switch {
            checked: switchRow.value
            onToggled: switchRow.valueEdited(checked)
        }
    }

    ColumnLayout {
        spacing: PrefStyle.sectionSpacing

        PrefHeading {
            text: KI18n.i18nc("@title", "Playlist")
        }

        // ------------------------------------
        // Playback
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Playback")

            PrefRow {
                title: KI18n.i18nc("@label:listbox", "When a file ends")
                helpWidth: 450
                help: KI18n.i18nc("@info:tooltip playback description",
                                  "<strong>Repeat playlist</strong>: playlist is repeated indefinitely<br>" +
                                  "<strong>Stop after last item</strong>: playback stops after the last item in the playlist<br>" +
                                  "<strong>Repeat item</strong>: current playing item is repeated indefinitely<br>" +
                                  "<strong>Stop after item</strong>: playback stops after the current playing item")

                ComboBox {
                    id: playbackBehaviorComboBox

                    textRole: "text"
                    valueRole: "value"
                    model: ListModel {
                        id: playbackBehaviorModel
                    }
                    Layout.preferredWidth: PrefStyle.fieldWidth
                    Component.onCompleted: {
                        playbackBehaviorModel.append({
                            text: KI18n.i18nc("@item:listbox the playback behavior of the playlist", "Repeat playlist"),
                            value: "RepeatPlaylist"
                        })
                        playbackBehaviorModel.append({
                            text: KI18n.i18nc("@item:listbox the playback behavior of the playlist", "Stop after last item"),
                            value: "StopAfterLast"
                        })
                        playbackBehaviorModel.append({
                            text: KI18n.i18nc("@item:listbox the playback behavior of the playlist", "Repeat item"),
                            value: "RepeatItem"
                        })
                        playbackBehaviorModel.append({
                            text: KI18n.i18nc("@item:listbox the playback behavior of the playlist", "Stop after item"),
                            value: "StopAfterItem"
                        })
                        currentIndex = indexOfValue(PlaylistSettings.playbackBehavior)
                    }
                    onActivated: function(index) {
                        PlaylistSettings.playbackBehavior = model.get(index).value
                        PlaylistSettings.save()
                    }
                    // When changed from mpris or toolbar, sync the GUI:
                    Connections {
                        target: PlaylistSettings
                        function onPlaybackBehaviorChanged() {
                            const comboBox = playbackBehaviorComboBox
                            comboBox.currentIndex = comboBox.indexOfValue(PlaylistSettings.playbackBehavior)
                        }
                    }
                }
            }

            PlaylistSwitchRow {
                title: KI18n.i18nc("@item:listbox the playback behavior of the playlist", "Shuffle")
                enabled: ["StopAfterLast", "RepeatPlaylist"].includes(PlaylistSettings.playbackBehavior)
                value: PlaylistSettings.randomPlayback
                onValueEdited: function(value) {
                    PlaylistSettings.randomPlayback = value
                    PlaylistSettings.save()
                }
            }

            PlaylistSwitchRow {
                title: KI18n.i18nc("@option:check", "Add other files from the same folder")
                description: KI18n.i18nc("@info", "Opening a file also queues the other videos next to it.")
                value: PlaylistSettings.loadSiblings
                onValueEdited: function(value) {
                    PlaylistSettings.loadSiblings = value
                    PlaylistSettings.save()
                }
            }

            PlaylistSwitchRow {
                title: KI18n.i18nc("@option:check", "Open items with a single click")
                value: PlaylistSettings.openWithSingleClick
                onValueEdited: function(value) {
                    PlaylistSettings.openWithSingleClick = value
                    PlaylistSettings.save()
                }
            }
        }

        // ------------------------------------
        // Appearance
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Appearance")

            PrefRow {
                title: KI18n.i18nc("@label:listbox", "Position")

                ComboBox {
                    textRole: "text"
                    valueRole: "value"
                    model: ListModel {
                        id: positionModel
                    }
                    Layout.preferredWidth: PrefStyle.fieldWidth
                    Component.onCompleted: {
                        positionModel.append({
                            text: KI18n.i18nc("@item:listbox playlist position", "Left"),
                            value: "left"
                        })
                        positionModel.append({
                            text: KI18n.i18nc("@item:listbox playlist position", "Right"),
                            value: "right"
                        })
                        currentIndex = indexOfValue(PlaylistSettings.position)
                    }

                    onActivated: function(index) {
                        PlaylistSettings.position = model.get(index).value
                        PlaylistSettings.save()
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:listbox", "Style")

                ComboBox {
                    textRole: "text"
                    valueRole: "value"
                    model: ListModel {
                        id: styleModel
                    }
                    Layout.preferredWidth: PrefStyle.fieldWidth
                    Component.onCompleted: {
                        styleModel.append({
                            text: KI18n.i18nc("@item:listbox the style of the playlist", "Default"),
                            value: "default"
                        })
                        styleModel.append({
                            text: KI18n.i18nc("@item:listbox the style of the playlist", "With thumbnails"),
                            value: "withThumbnails"
                        })
                        styleModel.append({
                            text: KI18n.i18nc("@item:listbox the style of the playlist", "Compact"),
                            value: "compact"
                        })
                        currentIndex = indexOfValue(PlaylistSettings.style)
                    }
                    onActivated: function(index) {
                        PlaylistSettings.style = model.get(index).value
                        PlaylistSettings.save()
                    }
                }
            }

            PlaylistSwitchRow {
                title: KI18n.i18nc("@option:check", "Draw over the video")
                description: KI18n.i18nc("@info", "When off, the video shrinks to make room for the playlist.")
                value: PlaylistSettings.overlayVideo
                onValueEdited: function(value) {
                    PlaylistSettings.overlayVideo = value
                    PlaylistSettings.save()
                }
            }

            PlaylistSwitchRow {
                title: KI18n.i18nc("@option:check", "Show toolbar")
                value: PlaylistSettings.showToolbar
                onValueEdited: function(value) {
                    PlaylistSettings.showToolbar = value
                    PlaylistSettings.save()
                }
            }

            PlaylistSwitchRow {
                title: KI18n.i18nc("@option:check", "Show media title instead of file name")
                value: PlaylistSettings.showMediaTitle
                onValueEdited: function(value) {
                    PlaylistSettings.showMediaTitle = value
                    PlaylistSettings.save()
                }
            }

            PlaylistSwitchRow {
                title: KI18n.i18nc("@option:check", "Show row numbers")
                value: PlaylistSettings.showRowNumber
                onValueEdited: function(value) {
                    PlaylistSettings.showRowNumber = value
                    PlaylistSettings.save()
                }
            }

            PlaylistSwitchRow {
                title: KI18n.i18nc("@option:check", "Larger text in fullscreen")
                enabled: PlaylistSettings.style !== "compact"
                value: PlaylistSettings.bigFontFullscreen
                onValueEdited: function(value) {
                    PlaylistSettings.bigFontFullscreen = value
                    PlaylistSettings.save()
                }
            }
        }

        // ------------------------------------
        // Showing the playlist
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Showing the playlist")

            PlaylistSwitchRow {
                title: KI18n.i18nc("@option:check", "Open when the mouse reaches the window edge")
                value: PlaylistSettings.canToggleWithMouse
                onValueEdited: function(value) {
                    PlaylistSettings.canToggleWithMouse = value
                    PlaylistSettings.save()
                }
            }

            PlaylistSwitchRow {
                title: KI18n.i18nc("@option:check", "Remember if it was open")
                description: KI18n.i18nc("@info", "Reopen the playlist on startup if it was open when you closed the player.")
                value: PlaylistSettings.rememberState
                onValueEdited: function(value) {
                    PlaylistSettings.rememberState = value
                    PlaylistSettings.save()
                }
            }
        }

        Item { Layout.preferredHeight: Kirigami.Units.gridUnit }
    }
}
