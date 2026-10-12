/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import org.kde.ki18n
import org.kde.kirigami as Kirigami

import org.kde.haruna
import org.kde.haruna.settings

SettingsBasePage {
    id: root

    required property MpvVideo m_mpv

    ColumnLayout {
        spacing: PrefStyle.sectionSpacing

        PrefHeading {
            text: KI18n.i18nc("@title", "Video")
        }

        // ------------------------------------
        // Picture
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Picture")

            PrefRow {
                title: KI18n.i18nc("@label:slider", "Contrast")

                ImageAdjustmentSlider {
                    value: root.m_mpv.getProperty(MpvProperties.Contrast)
                    onSliderValueChanged: function(value) {
                        root.m_mpv.setProperty(MpvProperties.Contrast, value.toFixed(0))
                    }
                    Layout.preferredWidth: PrefStyle.fieldWidth * 1.4
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:slider", "Brightness")

                ImageAdjustmentSlider {
                    value: root.m_mpv.getProperty(MpvProperties.Brightness)
                    onSliderValueChanged: function(value) {
                        root.m_mpv.setProperty(MpvProperties.Brightness, value.toFixed(0))
                    }
                    Layout.preferredWidth: PrefStyle.fieldWidth * 1.4
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:slider", "Gamma")

                ImageAdjustmentSlider {
                    value: root.m_mpv.getProperty(MpvProperties.Gamma)
                    onSliderValueChanged: function(value) {
                        root.m_mpv.setProperty(MpvProperties.Gamma, value.toFixed(0))
                    }
                    Layout.preferredWidth: PrefStyle.fieldWidth * 1.4
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:slider", "Saturation")
                description: KI18n.i18nc("@info", "Middle-click a slider to reset it.")

                ImageAdjustmentSlider {
                    value: root.m_mpv.getProperty(MpvProperties.Saturation)
                    onSliderValueChanged: function(value) {
                        root.m_mpv.setProperty(MpvProperties.Saturation, value.toFixed(0))
                    }
                    Layout.preferredWidth: PrefStyle.fieldWidth * 1.4
                }
            }
        }

        // ------------------------------------
        // Snapshots
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Snapshots")

            PrefRow {
                title: KI18n.i18nc("@label:listbox", "Format")

                ComboBox {
                    id: screenshotFormat

                    textRole: "key"
                    model: ListModel {
                        ListElement { key: "PNG"; value: "png" }
                        ListElement { key: "JPG"; value: "jpg" }
                        ListElement { key: "WebP"; value: "webp" }
                        ListElement { key: "JPEG XL"; value: "jxl" }
                    }
                    Layout.preferredWidth: PrefStyle.fieldWidth

                    onActivated: function(index) {
                        VideoSettings.screenshotFormat = model.get(index).value
                        VideoSettings.save()
                    }

                    Component.onCompleted: {
                        const formats = ["png", "jpg", "webp", "jxl"]
                        const index = formats.indexOf(VideoSettings.screenshotFormat)
                        currentIndex = index === -1 ? 0 : index
                    }
                }
            }

            PrefRow {
                title: KI18n.i18nc("@label:textbox", "File name")
                description: KI18n.i18nc("@info", "Can start with a folder path. The default “%F-%n” is the video name plus a number.")
                stacked: true
                helpWidth: 500
                help: KI18n.i18nc("@info:tooltip",
                                  "Specify the filename template used to save screenshots. The template specifies the " +
                                  "filename without file extension, and can contain format specifiers, which will be " +
                                  "substituted when taking a screenshot. By default, the template is “%F-%n”. <br>" +
                                  "The template can start with a relative or absolute path, in order to specify " +
                                  "a directory location where screenshots should be saved.<br>" +
                                  "If the final screenshot filename points to an already existing file, the file " +
                                  "will not be overwritten. The screenshot will either not be saved, or if the template " +
                                  "contains %n, saved using different, newly generated filename.<br>" +
                                  "For full info checkout <a href='https://mpv.io/manual/stable/#options-screenshot-template'>https://mpv.io/manual/stable/#options-screenshot-template</a><br><br>" +
                                  "<strong>Allowed format specifiers:</strong><br>" +
                                  "<ul><li><strong>%[#][0X]n</strong> A sequence number, padded with zeros to length X.<br>" +
                                  "<li><strong>%f</strong> Filename of the currently played video.<br>" +
                                  "<li><strong>%F</strong> Same as %f, but without the file extension.<br>" +
                                  "<li><strong>%x</strong> Directory path of the currently played video. "+
                                  "If the video is not on the filesystem (http:// urls), this expands to an empty string.<br>" +
                                  "<li><strong>%X{fallback}</strong> Same as %x, but if the video file is not on the " +
                                  "filesystem, return the fallback string inside the {…}.<br>" +
                                  "<li><strong>%p</strong> Current playback time. The result is a " +
                                  "string of the form “HH:MM:SS”.<br>" +
                                  "<li><strong>%P</strong> Similar to %p, but extended with the playback time in milliseconds “HH:MM:SS.mmm”.<br>" +
                                  "<li><strong>%wX</strong> Specify the current playback time using the format string X.<br>" +
                                  "Valid format specifiers:<br>" +
                                  "<ul><li><strong>%wH</strong> hour (padded with 0 to two digits)</li>" +
                                  "<li><strong>%wh</strong> hour (not padded)</li>" +
                                  "<li><strong>%wM</strong> minutes (00–59)</li>" +
                                  "<li><strong>%wm</strong> total minutes (includes hours, unlike %wM)</li>" +
                                  "<li><strong>%wS</strong> seconds (00–59)</li>" +
                                  "<li><strong>%ws</strong> total seconds (includes hours and minutes)</li>" +
                                  "<li><strong>%wf</strong> like %ws, but as float</li>" +
                                  "<li><strong>%wT</strong> milliseconds (000–999)</li>" +
                                  "<li><strong>%%</strong> Replaced with the % character itself.</li></ul><br>")

                TextField {
                    id: screenshotTemplate

                    text: VideoSettings.screenshotTemplate
                    placeholderText: "%F-%n"
                    Layout.fillWidth: true
                    onEditingFinished: save()

                    Connections {
                        target: root
                        function onSave() {
                            screenshotTemplate.save()
                        }
                    }

                    function save() : void {
                        VideoSettings.screenshotTemplate = text
                        VideoSettings.save()
                    }
                }
            }
        }

        // ------------------------------------
        // Music files
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Music files")

            PrefRow {
                title: KI18n.i18nc("@label:listbox", "Default cover")
                description: KI18n.i18nc("@info", "Shown for music without a video track, embedded cover or cover image in its folder.")
                stacked: true

                TextField {
                    id: defaultCover

                    text: VideoSettings.defaultCover
                    placeholderText: KI18n.i18nc("placeholder text", "path to image")
                    Layout.fillWidth: true
                    onEditingFinished: save()

                    Connections {
                        target: root
                        function onSave() {
                            defaultCover.save()
                        }
                    }

                    function save() : void {
                        VideoSettings.defaultCover = defaultCover.text
                        VideoSettings.save()
                    }
                }

                Button {
                    icon.name: "document-open"
                    text: KI18n.i18nc("@action:button", "Browse…")
                    onClicked: fileDialog.open()
                }

                FileDialog {
                    id: fileDialog

                    currentFolder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
                    title: KI18n.i18nc("@title:window", "Select file")
                    fileMode: FileDialog.OpenFile

                    onAccepted: {
                        VideoSettings.defaultCover = fileDialog.selectedFile
                    }
                    onRejected: root.m_mpv.focus = true
                    onVisibleChanged: {
                        HarunaApp.actionsEnabled = !visible
                    }
                }
            }
        }

        Item { Layout.preferredHeight: Kirigami.Units.gridUnit }
    }
}
