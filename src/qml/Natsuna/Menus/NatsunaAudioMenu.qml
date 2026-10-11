/*
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import org.kde.ki18n

import org.kde.haruna

// VLC: Audio
Menu {
    id: root

    required property MpvVideo m_mpv

    title: KI18n.i18nc("@title:menu", "&Audio")

    AudioTracksMenu {
        m_mpv: root.m_mpv
        title: KI18n.i18nc("@title:menu", "Audio Track")
    }

    MenuSeparator {}

    MenuItem {
        action: HarunaApp.actions.volumeUpAction
        text: KI18n.i18nc("@action:inmenu", "Increase Volume")
    }
    MenuItem {
        action: HarunaApp.actions.volumeDownAction
        text: KI18n.i18nc("@action:inmenu", "Decrease Volume")
    }
    NatsunaToggleItem {
        action: HarunaApp.actions.muteAction
        isOn: root.m_mpv.mute
    }
}
