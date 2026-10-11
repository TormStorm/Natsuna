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

// VLC: Subtitle
Menu {
    id: root

    required property MpvVideo m_mpv

    title: KI18n.i18nc("@title:menu", "Su&btitle")

    MenuItem {
        action: HarunaApp.actions.addExternalSubtitleAction
        text: KI18n.i18nc("@action:inmenu", "Add Subtitle File…")
        enabled: root.m_mpv.currentUrl.toString() !== ""
    }

    SubtitleTracksMenu {
        m_mpv: root.m_mpv
        isPrimarySubtitleMenu: true
        title: KI18n.i18nc("@title:menu", "Sub Track")
    }
}
