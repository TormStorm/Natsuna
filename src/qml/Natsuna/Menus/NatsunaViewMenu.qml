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
import org.kde.haruna.settings

// VLC: View
Menu {
    id: root

    title: KI18n.i18nc("@title:menu", "V&iew")

    MenuItem {
        action: HarunaApp.actions.togglePlaylistAction
        text: KI18n.i18nc("@action:inmenu", "Playlist")
    }

    MenuSeparator {}

    NatsunaToggleItem {
        text: KI18n.i18nc("@action:inmenu", "Always on Top")
        icon.name: "window-keep-above"
        isOn: GeneralSettings.alwaysOnTop
        onTriggered: {
            GeneralSettings.alwaysOnTop = !GeneralSettings.alwaysOnTop
            GeneralSettings.save()
        }
    }

    MenuSeparator {}

    NatsunaToggleItem {
        action: HarunaApp.actions.toggleHeaderAction
        text: KI18n.i18nc("@action:inmenu", "Toolbar")
        isOn: GeneralSettings.showHeader
    }
}
