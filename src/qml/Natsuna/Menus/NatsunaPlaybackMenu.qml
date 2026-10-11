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
import org.kde.haruna.utilities

// VLC: Playback
Menu {
    id: root

    required property MpvVideo m_mpv

    title: KI18n.i18nc("@title:menu", "&Playback")

    Menu {
        id: chapterMenu

        title: KI18n.i18nc("@title:menu", "Chapter")
        enabled: root.m_mpv.chaptersModel.rowCount > 0

        MenuItem {
            action: HarunaApp.actions.seekNextChapterAction
            text: KI18n.i18nc("@action:inmenu", "Next Chapter")
        }
        MenuItem {
            action: HarunaApp.actions.seekPreviousChapterAction
            text: KI18n.i18nc("@action:inmenu", "Previous Chapter")
        }

        MenuSeparator {}

        Instantiator {
            model: root.m_mpv.chaptersModel
            delegate: MenuItem {
                id: chapterItem

                required property int index
                required property string title
                required property double startTime

                checkable: true
                checked: chapterItem.index === root.m_mpv.chapter
                text: `${MiscUtils.formatTime(chapterItem.startTime)}  ${chapterItem.title}`
                onTriggered: {
                    root.m_mpv.chapter = chapterItem.index
                    checked = Qt.binding(() => chapterItem.index === root.m_mpv.chapter)
                }
            }
            // after the two navigation items and the separator
            onObjectAdded: (index, object) => chapterMenu.insertItem(index + 3, object)
            onObjectRemoved: (index, object) => chapterMenu.removeItem(object)
        }
    }

    Menu {
        title: KI18n.i18nc("@title:menu %1 is the current playback speed", "Speed (%1×)",
                           Number(root.m_mpv.playbackSpeed.toFixed(2)))

        MenuItem {
            action: HarunaApp.actions.playbackSpeedIncreaseAction
            text: KI18n.i18nc("@action:inmenu", "Faster")
        }
        MenuItem {
            action: HarunaApp.actions.playbackSpeedResetAction
            text: KI18n.i18nc("@action:inmenu", "Normal Speed")
        }
        MenuItem {
            action: HarunaApp.actions.playbackSpeedDecreaseAction
            text: KI18n.i18nc("@action:inmenu", "Slower")
        }
    }

    MenuSeparator {}

    MenuItem {
        action: HarunaApp.actions.seekForwardSmallAction
        text: KI18n.i18nc("@action:inmenu", "Jump Forward")
    }
    MenuItem {
        action: HarunaApp.actions.seekBackwardSmallAction
        text: KI18n.i18nc("@action:inmenu", "Jump Backward")
    }

    MenuSeparator {}

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
}
