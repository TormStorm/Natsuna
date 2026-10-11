/*
 * SPDX-FileCopyrightText: 2022 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import org.kde.ki18n

import org.kde.haruna

Loader {
    id: root

    required property MpvVideo m_mpv

    function open() : void {
        if (!root.active) {
            root.active = true
            root.loaded.connect(function() {
                root.open()
            })
            return
        }

        const contextMenu = root.item as Menu
        contextMenu.popup()
    }

    function close() : void {
        root.active = false
    }

    active: false
    asynchronous: true
    sourceComponent: Menu {

        onClosed: root.active = false

        // Natsuna: VLC-style right-click menu
        MenuItem {
            action: HarunaApp.actions.playPauseAction
            text: root.m_mpv.pause
                  ? KI18n.i18nc("@action:inmenu", "Play")
                  : KI18n.i18nc("@action:inmenu", "Pause")
        }
        MenuItem { action: HarunaApp.actions.stopAction }
        MenuItem {
            action: HarunaApp.actions.playPreviousAction
            text: KI18n.i18nc("@action:inmenu", "Previous")
        }
        MenuItem {
            action: HarunaApp.actions.playNextAction
            text: KI18n.i18nc("@action:inmenu", "Next")
        }

        MenuSeparator {}

        NatsunaAudioMenu {
            m_mpv: root.m_mpv
        }
        NatsunaVideoMenu {}
        NatsunaSubtitleMenu {
            m_mpv: root.m_mpv
        }
        NatsunaPlaybackMenu {
            m_mpv: root.m_mpv
        }
        NatsunaViewMenu {}

        MenuSeparator {}

        MenuItem {
            action: HarunaApp.actions.openFileAction
            text: KI18n.i18nc("@action:inmenu", "Open File…")
        }
        MenuItem {
            action: HarunaApp.actions.configureAction
            text: KI18n.i18nc("@action:inmenu", "Preferences")
        }
        MenuItem { action: HarunaApp.actions.quitApplicationAction }
    }
}