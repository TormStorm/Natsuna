/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.ki18n
import org.kde.kirigami as Kirigami

import org.kde.haruna
import org.kde.haruna.settings

// Natsuna: the Preferences window.
Loader {
    id: root

    required property MpvVideo m_mpv

    property int activePage: SettingsWindow.Page.General

    enum Page {
        General = 0,
        Playback,
        Video,
        Audio,
        Subtitles,
        Playlist,
        Mouse,
        Shortcuts,
        CustomCommands,
        Database,
        Debug,
        About,
        Input   // Natsuna: Shortcuts + Mouse
    }

    // sidebar order
    readonly property var pages: [
        SettingsWindow.Page.General,
        SettingsWindow.Page.Playback,
        SettingsWindow.Page.Audio,
        SettingsWindow.Page.Video,
        SettingsWindow.Page.Subtitles,
        SettingsWindow.Page.Playlist,
        SettingsWindow.Page.Input,
        SettingsWindow.Page.CustomCommands,
        SettingsWindow.Page.Database,
        SettingsWindow.Page.Debug,
        SettingsWindow.Page.About
    ]

    // Haruna's separate Shortcuts and Mouse pages now live on the Input page
    function normalizedPage(page: int) : int {
        if (page === SettingsWindow.Page.Shortcuts || page === SettingsWindow.Page.Mouse) {
            return SettingsWindow.Page.Input
        }
        return page
    }

    function pageText(page: int) : string {
        switch (page) {
        case SettingsWindow.Page.General: return KI18n.i18nc("@action", "General")
        case SettingsWindow.Page.Playback: return KI18n.i18nc("@action", "Playback")
        case SettingsWindow.Page.Video: return KI18n.i18nc("@action", "Video")
        case SettingsWindow.Page.Audio: return KI18n.i18nc("@action", "Audio")
        case SettingsWindow.Page.Subtitles: return KI18n.i18nc("@action", "Subtitles")
        case SettingsWindow.Page.Playlist: return KI18n.i18nc("@action", "Playlist")
        case SettingsWindow.Page.Input: return KI18n.i18nc("@action", "Input")
        case SettingsWindow.Page.CustomCommands: return KI18n.i18nc("@action", "Custom Commands")
        case SettingsWindow.Page.Database: return KI18n.i18nc("@action", "Database")
        case SettingsWindow.Page.Debug: return KI18n.i18nc("@action", "Debug")
        case SettingsWindow.Page.About: return KI18n.i18nc("@action", "About")
        }
        return ""
    }

    function pageIcon(page: int) : string {
        switch (page) {
        case SettingsWindow.Page.General: return "configure"
        case SettingsWindow.Page.Playback: return "media-playback-start"
        case SettingsWindow.Page.Video: return "video-x-generic"
        case SettingsWindow.Page.Audio: return "player-volume"
        case SettingsWindow.Page.Subtitles: return "add-subtitle"
        case SettingsWindow.Page.Playlist: return "view-media-playlist"
        case SettingsWindow.Page.Input: return "input-keyboard"
        case SettingsWindow.Page.CustomCommands: return "dialog-scripts"
        case SettingsWindow.Page.Database: return "server-database"
        case SettingsWindow.Page.Debug: return "tools-report-bug"
        case SettingsWindow.Page.About: return "help-about"
        }
        return ""
    }

    function openSettingPage(page: int) : void {
        page = root.normalizedPage(page)
        if (!root.active) {
            // choose the page first so the window builds only that page
            root.activePage = page
            root.active = true
            root.loaded.connect(function() {
                root.openSettingPage(page)
            })
            return
        }

        const settingsWindow = root.item as Kirigami.ApplicationWindow
        root.activePage = page
        if (settingsWindow.visible) {
            settingsWindow.raise()
        } else {
            settingsWindow.visible = true
        }
    }

    // Show the content page for `activePage` next to the sidebar
    function loadPage() : void {
        const settingsWindow = root.item as Kirigami.ApplicationWindow
        if (!settingsWindow) {
            return
        }

        const path = "qrc:/qt/qml/org/kde/haruna/qml/Settings"
        const stack = settingsWindow.pageStack
        stack.removePage(1)

        switch (root.activePage) {
        case SettingsWindow.Page.General:
            stack.push(`${path}/GeneralSettings.qml`)
            break
        case SettingsWindow.Page.Playback:
            stack.push(`${path}/PlaybackSettings.qml`)
            break
        case SettingsWindow.Page.Video:
            stack.push(`${path}/VideoSettings.qml`, {m_mpv: root.m_mpv})
            break
        case SettingsWindow.Page.Audio:
            stack.push(`${path}/AudioSettings.qml`)
            break
        case SettingsWindow.Page.Subtitles:
            stack.push(`${path}/SubtitlesSettings.qml`)
            break
        case SettingsWindow.Page.Playlist:
            stack.push(`${path}/PlaylistSettings.qml`)
            break
        case SettingsWindow.Page.Input:
        case SettingsWindow.Page.Shortcuts:
        case SettingsWindow.Page.Mouse:
            stack.push(`${path}/InputSettings.qml`)
            break
        case SettingsWindow.Page.CustomCommands:
            stack.push(`${path}/CustomCommandsSettings.qml`,
                       {m_mpv: root.m_mpv, m_settingsWindow: settingsWindow})
            break
        case SettingsWindow.Page.Database:
            stack.push(`${path}/DatabaseSettings.qml`)
            break
        case SettingsWindow.Page.Debug:
            stack.push(`${path}/DebugSettings.qml`, {m_mpv: root.m_mpv})
            break
        case SettingsWindow.Page.About:
            stack.push(settingsWindow.aboutPageComponent)
            break
        }
    }

    // one entry in the sidebar
    component PageDelegate: ItemDelegate {
        id: pageDelegate

        required property int modelData

        text: root.pageText(pageDelegate.modelData)
        icon.name: root.pageIcon(pageDelegate.modelData)
        highlighted: pageDelegate.modelData === root.activePage
        Layout.fillWidth: true
        onClicked: root.activePage = pageDelegate.modelData
    }

    onActivePageChanged: loadPage()
    onLoaded: loadPage()

    active: false
    asynchronous: true
    sourceComponent: Kirigami.ApplicationWindow {
        id: settingsWindow

        // kept for pages that build paths from it (e.g. custom commands)
        property string settingsPath: "qrc:/qt/qml/org/kde/haruna/qml/Settings"
        readonly property Component aboutPageComponent: aboutPage

        width: Kirigami.Units.gridUnit * 52
        height: Kirigami.Units.gridUnit * 38
        minimumWidth: Kirigami.Units.gridUnit * 40
        minimumHeight: Kirigami.Units.gridUnit * 24
        title: KI18n.i18nc("@title:window", "Preferences")
        transientParent: null

        pageStack.initialPage: Kirigami.ScrollablePage {
            globalToolBarStyle: Kirigami.ApplicationHeaderStyle.None
            topPadding: Kirigami.Units.largeSpacing
            bottomPadding: Kirigami.Units.largeSpacing
            leftPadding: Kirigami.Units.smallSpacing
            rightPadding: Kirigami.Units.smallSpacing
            Kirigami.Theme.colorSet: Kirigami.Theme.View

            ColumnLayout {
                spacing: 0

                // App identity
                RowLayout {
                    spacing: Kirigami.Units.largeSpacing
                    Layout.leftMargin: Kirigami.Units.largeSpacing
                    Layout.rightMargin: Kirigami.Units.largeSpacing
                    Layout.topMargin: Kirigami.Units.smallSpacing
                    Layout.bottomMargin: Kirigami.Units.gridUnit

                    Image {
                        source: "qrc:/data/icons/256-apps-natsuna.png"
                        sourceSize.width: Kirigami.Units.iconSizes.large
                        sourceSize.height: Kirigami.Units.iconSizes.large
                        smooth: true
                        Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                        Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                    }

                    ColumnLayout {
                        spacing: 0
                        Layout.fillWidth: true

                        Kirigami.Heading {
                            text: "Natsuna"
                            level: 3
                        }
                        Label {
                            text: KI18n.i18nc("@title", "Preferences")
                            font: Kirigami.Theme.smallFont
                            opacity: 0.7
                        }
                    }
                }

                Repeater {
                    model: root.pages
                    delegate: PageDelegate {}
                }
            }
        }

        // Defined inside the window: Kirigami.AboutPage needs its applicationWindow
        Component {
            id: aboutPage

            Kirigami.AboutPage {
                aboutData: HarunaApp.aboutData()
            }
        }

        onClosing: root.active = false

        Component.onCompleted: {
            HarunaApp.setupEventFilter(settingsWindow)
            pageStack.columnView.columnWidth = Kirigami.Units.gridUnit * 13
        }

        Shortcut {
            sequence: "Esc"
            enabled: HarunaApp.actionsEnabled
            onActivated: settingsWindow.close()
        }
    }
}
