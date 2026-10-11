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

// VLC: Video
Menu {
    id: root

    title: KI18n.i18nc("@title:menu", "&Video")

    MenuItem {
        action: HarunaApp.actions.toggleFullscreenAction
        text: KI18n.i18nc("@action:inmenu", "Fullscreen")
    }

    MenuSeparator {}

    Menu {
        title: KI18n.i18nc("@title:menu", "Zoom")

        MenuItem {
            action: HarunaApp.actions.zoomInAction
            text: KI18n.i18nc("@action:inmenu", "Zoom In")
        }
        MenuItem {
            action: HarunaApp.actions.zoomOutAction
            text: KI18n.i18nc("@action:inmenu", "Zoom Out")
        }
        MenuItem {
            action: HarunaApp.actions.zoomResetAction
            text: KI18n.i18nc("@action:inmenu", "Original Size")
        }
    }

    MenuItem {
        action: HarunaApp.actions.toggleDeinterlacingAction
        text: KI18n.i18nc("@action:inmenu", "Deinterlace")
    }

    MenuSeparator {}

    MenuItem {
        action: HarunaApp.actions.screenshotAction
        text: KI18n.i18nc("@action:inmenu", "Take Snapshot")
    }
}
