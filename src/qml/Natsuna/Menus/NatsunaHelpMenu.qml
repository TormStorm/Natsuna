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

// VLC: Help
Menu {
    id: root

    title: KI18n.i18nc("@title:menu", "&Help")

    MenuItem { action: HarunaApp.actions.aboutHarunaAction }
    MenuItem {
        action: HarunaApp.actions.reportBugAction
        text: KI18n.i18nc("@action:inmenu", "Report a Bug…")
    }

    MenuSeparator {}

    MenuItem {
        action: HarunaApp.actions.sponsorAction
        text: KI18n.i18nc("@action:inmenu", "Support Haruna Development")
    }
}
