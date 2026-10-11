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

// VLC: Tools
Menu {
    id: root

    required property SettingsWindow m_settingsLoader

    title: KI18n.i18nc("@title:menu", "&Tools")

    MenuItem {
        action: HarunaApp.actions.configureShortcutsAction
        text: KI18n.i18nc("@action:inmenu", "Customize Shortcuts…")
    }
    MenuItem {
        action: HarunaApp.actions.configureAction
        text: KI18n.i18nc("@action:inmenu", "Preferences")
    }
}
