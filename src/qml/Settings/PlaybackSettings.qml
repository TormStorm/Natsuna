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

    ColumnLayout {
        spacing: PrefStyle.sectionSpacing

        PrefHeading {
            text: KI18n.i18nc("@title", "Playback")
        }

        // ------------------------------------
        // General
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "General")

            PrefRow {
                title: KI18n.i18nc("@label", "Hardware decoding")
                helpWidth: 450
                help: KI18n.i18nc("@info:tooltip hardware decoding setting",
                                  "Specify the hardware video decoding API that should be used if possible. " +
                                  "Whether hardware decoding is actually done depends on the video codec. " +
                                  "If hardware decoding is not possible, mpv will fall back on software decoding.<br><br>" +
                                  "<ul><li><strong>auto</strong> tries to automatically enable hardware decoding using the first available method.</li>" +
                                  "<li><strong>auto-safe</strong> similar to auto, but allows only whitelisted methods that are considered “safe”.</li>" +
                                  "<li><strong>vaapi</strong> works with Intel and AMD GPUs only. It also requires the opengl EGL backend.</li>" +
                                  "<li><strong>nvdec</strong> the newest, and recommended method to do hardware decoding on Nvidia GPUs.</li>" +
                                  "<li><strong>cuda</strong> an older implementation of hardware decoding on Nvidia GPUs.</li>" +
                                  "<li><strong>videotoolbox</strong></li>" +
                                  "<li><strong>d3d11va</strong></li>" +
                                  "</ul>" +
                                  "<br><br>" +
                                  "You can read more about hardware decoding here: " +
                                  "<a href='https://mpv.io/manual/stable/#options-hwdec'>https://mpv.io/manual/stable/#options-hwdec</a>" +
                                  "<br><br>" +
                                  "You can set another hardware decoder by creating a startup custom command <strong>set hwdec <i>decoder_name</i></strong>.")

                ComboBox {
                    id: hwDecodingComboBox

                    textRole: "key"
                    model: ListModel {
                        id: hwDecModel
                        ListElement { key: "disabled"; }
                        ListElement { key: "auto"; }
                        ListElement { key: "auto-safe"; }
                        ListElement { key: "vaapi"; }
                        ListElement { key: "nvdec"; }
                        ListElement { key: "cuda"; }
                        ListElement { key: "videotoolbox"; }
                        ListElement { key: "d3d11va"; }
                    }
                    Layout.preferredWidth: PrefStyle.fieldWidth

                    onActivated: function(index) {
                        PlaybackSettings.hWDecoding = model.get(index).key === "disabled"
                                ? "no"
                                : model.get(index).key
                        PlaybackSettings.save()
                    }

                    Component.onCompleted: {
                        for (let i = 0; i < hwDecModel.count; ++i) {
                            if (hwDecModel.get(i).key === PlaybackSettings.hWDecoding) {
                                currentIndex = i
                                break
                            }
                        }
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@option:check", "Open last played file on startup")

                Switch {
                    checked: PlaybackSettings.openLastPlayedFile
                    onToggled: {
                        PlaybackSettings.openLastPlayedFile = checked
                        PlaybackSettings.save()
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@option:check", "Pause when minimized")
                description: KI18n.i18nc("@info", "Playback resumes when the window is restored.")

                Switch {
                    checked: PlaybackSettings.pauseWhileMinimized
                    onToggled: {
                        PlaybackSettings.pauseWhileMinimized = checked
                        PlaybackSettings.save()
                    }
                }
            }
        }

        // ------------------------------------
        // Seeking
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Seeking")

            PrefRow {
                title: KI18n.i18nc("@label:spinbox", "Small step (seconds)")
                description: KI18n.i18nc("@info", "Left and right arrow keys.")

                SpinBox {
                    id: seekSmallStep

                    editable: true
                    from: 0
                    to: 100
                    value: PlaybackSettings.seekSmallStep
                    onValueModified: {
                        PlaybackSettings.seekSmallStep = seekSmallStep.value
                        PlaybackSettings.save()
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:spinbox", "Medium step (seconds)")
                description: KI18n.i18nc("@info", "Shift + arrow keys, and scrolling over the seek bar.")

                SpinBox {
                    id: seekMediumStep

                    editable: true
                    from: 0
                    to: 100
                    value: PlaybackSettings.seekMediumStep
                    onValueModified: {
                        PlaybackSettings.seekMediumStep = seekMediumStep.value
                        PlaybackSettings.save()
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:spinbox", "Big step (seconds)")
                description: KI18n.i18nc("@info", "Ctrl + arrow keys.")

                SpinBox {
                    id: seekBigStep

                    editable: true
                    from: 0
                    to: 100
                    value: PlaybackSettings.seekBigStep
                    onValueModified: {
                        PlaybackSettings.seekBigStep = seekBigStep.value
                        PlaybackSettings.save()
                    }
                }
            }
        }

        // ------------------------------------
        // Resume playback
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Resume playback")

            PrefRow {
                title: KI18n.i18nc("@option:check", "Remember playback position")
                description: KI18n.i18nc("@info", "Opening the same file again continues where you left off.")

                Switch {
                    id: saveFilePositionCheckBox

                    checked: PlaybackSettings.restoreFilePosition
                    onToggled: {
                        PlaybackSettings.restoreFilePosition = checked
                        PlaybackSettings.save()
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@option:check", "Start playing after resuming")
                indented: true
                enabled: saveFilePositionCheckBox.checked

                Switch {
                    checked: PlaybackSettings.playOnResume
                    onToggled: {
                        PlaybackSettings.playOnResume = checked
                        PlaybackSettings.save()
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:spinbox when to save position", "Only for files longer than (minutes)")
                description: KI18n.i18nc("@info", "Set to 0 to remember the position of every file.")
                indented: true
                enabled: saveFilePositionCheckBox.checked

                SpinBox {
                    from: 0
                    to: 9999
                    editable: true
                    value: PlaybackSettings.minDurationToSavePosition
                    onValueModified: {
                        PlaybackSettings.minDurationToSavePosition = value
                        PlaybackSettings.save()
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:spinbox", "Save every (seconds)")
                indented: true
                enabled: saveFilePositionCheckBox.checked

                SpinBox {
                    from: 1
                    to: 9999
                    editable: true
                    value: PlaybackSettings.savePositionInterval
                    onValueModified: {
                        PlaybackSettings.savePositionInterval = value
                        PlaybackSettings.save()
                    }
                }
            }
        }

        // ------------------------------------
        // Chapters
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Chapters")

            PrefRow {
                title: KI18n.i18nc("@option:check", "Skip chapters")
                description: KI18n.i18nc("@info", "Automatically skip chapters whose titles contain certain words.")

                Switch {
                    id: skipChaptersCheckBox

                    checked: PlaybackSettings.skipChapters
                    onToggled: {
                        PlaybackSettings.skipChapters = checked
                        PlaybackSettings.save()
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:textbox", "Words to skip")
                description: KI18n.i18nc("@info", "Comma separated. Partial matches count, so “op” also matches “opening”.")
                indented: true
                stacked: true
                enabled: skipChaptersCheckBox.checked

                TextField {
                    id: chaptersToSkip

                    text: PlaybackSettings.chaptersToSkip
                    placeholderText: KI18n.i18nc("placeholder text", "op, ed, chapter 1")
                    Layout.fillWidth: true
                    onEditingFinished: save()

                    Connections {
                        target: root
                        function onSave() {
                            chaptersToSkip.save()
                        }
                    }

                    function save() : void {
                        PlaybackSettings.chaptersToSkip = text
                        PlaybackSettings.save()
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@option:check", "Show a message when skipping")
                indented: true
                enabled: skipChaptersCheckBox.checked

                Switch {
                    checked: PlaybackSettings.showOsdOnSkipChapters
                    onToggled: {
                        PlaybackSettings.showOsdOnSkipChapters = checked
                        PlaybackSettings.save()
                    }
                }
            }
        }

        // ------------------------------------
        // Online videos (yt-dlp)
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Online videos")

            PrefRow {
                title: KI18n.i18nc("@label", "Maximum quality")
                description: KI18n.i18nc("@info", "Used when playing YouTube and other online videos.")

                ComboBox {
                    id: ytdlFormatComboBox

                    textRole: "text"
                    valueRole: "value"
                    model: ListModel {
                        id: formatModel
                    }
                    Layout.preferredWidth: PrefStyle.fieldWidth

                    onActivated: function(index) {
                        if (index === 0) {
                            PlaybackSettings.ytdlFormat = PlaybackSettings.ytdlFormatCustom
                        } else {
                            PlaybackSettings.ytdlFormat = ytdlFormatComboBox.valueAt(currentIndex)
                        }

                        PlaybackSettings.save()
                    }

                    Component.onCompleted: {
                        formatModel.append({
                            text: KI18n.i18nc("@item:listbox the custom youtube-dl format selection", "Custom"),
                            value: ""
                        })
                        formatModel.append({
                            text: KI18n.i18nc("@item:listbox the default youtube-dl format selection", "Best available"),
                            value: "bestvideo+bestaudio/best"
                        })
                        formatModel.append({ text: "2160p", value: "bestvideo[height<=2160]+bestaudio/best" })
                        formatModel.append({ text: "1440p", value: "bestvideo[height<=1440]+bestaudio/best" })
                        formatModel.append({ text: "1080p", value: "bestvideo[height<=1080]+bestaudio/best" })
                        formatModel.append({ text: "720p",  value: "bestvideo[height<=720]+bestaudio/best" })
                        formatModel.append({ text: "480p",  value: "bestvideo[height<=480]+bestaudio/best" })

                        currentIndex = hIndexOfValue(PlaybackSettings.ytdlFormat)
                    }

                    function hIndexOfValue(value) : int {
                        switch(value) {
                        case "bestvideo+bestaudio/best":
                            return 1
                        case "bestvideo[height<=2160]+bestaudio/best":
                            return 2
                        case "bestvideo[height<=1440]+bestaudio/best":
                            return 3
                        case "bestvideo[height<=1080]+bestaudio/best":
                            return 4
                        case "bestvideo[height<=720]+bestaudio/best":
                            return 5
                        case "bestvideo[height<=480]+bestaudio/best":
                            return 6
                        }
                        return 0
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:textbox", "Custom format")
                description: KI18n.i18nc("@info", "A yt-dlp format selection string.")
                indented: true
                stacked: true
                visible: ytdlFormatComboBox.currentIndex === 0

                TextField {
                    id: ytdlCustomFormatField

                    text: PlaybackSettings.ytdlFormatCustom
                    placeholderText: "bestvideo+bestaudio/best"
                    font.family: "monospace"
                    Layout.fillWidth: true

                    onTextChanged: {
                        PlaybackSettings.ytdlFormatCustom = ytdlCustomFormatField.text
                        PlaybackSettings.ytdlFormat = ytdlCustomFormatField.text
                        PlaybackSettings.save()
                    }

                    Connections {
                        target: root
                        function onSave() {
                            PlaybackSettings.ytdlFormatCustom = ytdlCustomFormatField.text
                            PlaybackSettings.save()
                        }
                    }
                }
            }
        }

        Item { Layout.preferredHeight: Kirigami.Units.gridUnit }
    }
}
