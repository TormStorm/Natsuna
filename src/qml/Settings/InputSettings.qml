/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

// Natsuna: keyboard shortcuts and mouse actions on one page.
// The editing logic comes from Haruna's ShortcutsSettings.qml and MouseSettings.qml.

pragma ComponentBehavior: Bound

import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.ki18n
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols
import org.kde.haruna
import org.kde.haruna.utilities

SettingsBasePage {
    id: root

    signal newMouseActionChanged()

    Component.onDestruction: Models.proxyActionsModel.setNameFilter("")

    SelectActionPopup {
        id: selectActionPopup
    }

    ColumnLayout {
        id: content

        spacing: PrefStyle.sectionSpacing

        PrefHeading {
            text: KI18n.i18nc("@title", "Input")
        }

        // ------------------------------------
        // Keyboard
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Keyboard")

            Kirigami.SearchField {
                id: searchField

                placeholderText: KI18n.i18nc("@info:placeholder", "Search shortcuts…")
                onTextChanged: Models.proxyActionsModel.setNameFilter(text)
                onAccepted: Models.proxyActionsModel.setNameFilter(text)
                Layout.fillWidth: true
                Layout.bottomMargin: Kirigami.Units.smallSpacing
            }

            Label {
                text: KI18n.i18nc("@info", "No shortcuts match your search.")
                visible: shortcutsRepeater.count === 0
                opacity: 0.7
                Layout.alignment: Qt.AlignHCenter
            }

            Repeater {
                id: shortcutsRepeater

                model: Models.proxyActionsModel
                delegate: PrefRow {
                    id: shortcutRow

                    required property int index
                    required property string actionName
                    required property string actionText
                    required property string actionShortcut

                    title: shortcutRow.actionText

                    KeySequenceItem {
                        checkForConflictsAgainst: ShortcutType.None
                        patterns: ShortcutPattern.Key | ShortcutPattern.ModifierAndKey
                        keySequence: MiscUtils.stringToKeySequence(shortcutRow.actionShortcut)

                        onKeySequenceModified: {
                            const keySequenceString = MiscUtils.keySequenceToString(keySequence)
                            if (keySequenceString === "") {
                                return
                            }

                            if (keySequenceString !== shortcutRow.actionShortcut) {
                                if (!Models.proxyActionsModel.saveShortcut(shortcutRow.index, keySequence)) {
                                    keySequence = MiscUtils.stringToKeySequence(shortcutRow.actionShortcut)
                                }
                            }
                        }
                    }
                }
            }
        }

        // ------------------------------------
        // Mouse
        // ------------------------------------
        PrefSection {
            title: KI18n.i18nc("@title", "Mouse")

            Repeater {
                model: Models.mouseActionsModel
                delegate: PrefRow {
                    id: mouseRow

                    required property mouseAction mouseAction
                    required property int index
                    required property string actionName
                    required property string i18nButton
                    required property string i18nModifier
                    required property bool isDoubleClick

                    title: {
                        let combo = mouseRow.i18nButton
                        if (mouseRow.i18nModifier !== "") {
                            combo = KI18n.i18nc("@label %1 is a modifier key, %2 a mouse button", "%1 + %2",
                                                mouseRow.i18nModifier, combo)
                        }
                        if (mouseRow.isDoubleClick) {
                            combo = KI18n.i18nc("@label %1 is a mouse button", "%1 double-click", combo)
                        }
                        return combo
                    }

                    Label {
                        text: HarunaApp.actions[mouseRow.actionName]?.text ?? mouseRow.actionName
                        elide: Text.ElideRight
                        opacity: 0.85
                        Layout.maximumWidth: PrefStyle.fieldWidth * 1.4
                    }

                    ToolButton {
                        icon.name: "edit-entry"
                        display: AbstractButton.IconOnly
                        text: KI18n.i18nc("@label:action change action associated with mouse event", "Change action")
                        ToolTip.text: text
                        ToolTip.visible: hovered
                        ToolTip.delay: Kirigami.Units.toolTipDelay
                        onClicked: {
                            const actionHandler = function (actionName) {
                                mouseRow.mouseAction.actionName = actionName
                                Models.mouseActionsModel.editAction(mouseRow.mouseAction)
                                selectActionPopup.actionSelected.disconnect(actionHandler)
                            }
                            selectActionPopup.actionSelected.connect(actionHandler)
                            selectActionPopup.open()
                        }
                    }

                    ToolButton {
                        icon.name: "edit-delete"
                        display: AbstractButton.IconOnly
                        text: KI18n.i18nc("@label:action delete mouse event", "Delete")
                        ToolTip.text: text
                        ToolTip.visible: hovered
                        ToolTip.delay: Kirigami.Units.toolTipDelay
                        onClicked: Models.mouseActionsModel.removeAction(mouseRow.index)
                    }
                }
            }

            Button {
                text: KI18n.i18nc("@action:button add a mouse button action", "Add mouse action…")
                icon.name: "list-add"
                onClicked: addActionComponent.createObject(root)
                Layout.alignment: Qt.AlignRight
            }
        }

        Item { Layout.preferredHeight: Kirigami.Units.gridUnit }
    }

    Component {
        id: addActionComponent

        Dialog {
            id: mouseActionDialog

            property bool canBeSaved: !noActionSelectedMessage.visible && !actionExistsMessage.visible

            function selectAction() {
                const actionHandler = function (actionName) {
                    if (mouseActionDialog === null) {
                        return
                    }

                    selectedActionLabel.actionName = actionName
                    selectedActionLabel.text = HarunaApp.actions[actionName].text
                    root.newMouseActionChanged()

                    selectActionPopup.actionSelected.disconnect(actionHandler)
                }
                selectActionPopup.actionSelected.connect(actionHandler)
                selectActionPopup.open()
            }

            title: KI18n.i18nc("@title:window", "Add mouse button action")
            parent: Overlay.overlay
            anchors.centerIn: parent
            width: Math.min(parent.width, Kirigami.Units.gridUnit * 22)
            height: Math.min(parent.height, Kirigami.Units.gridUnit * 30)
            visible: true
            standardButtons: Dialog.Ok | Dialog.Cancel
            closePolicy: Popup.NoAutoClose | Popup.CloseOnEscape
            modal: true
            onClosed: destroy()

            ColumnLayout {
                width: parent.width

                Label {
                    text: KI18n.i18nc("@label:listbox", "Mouse button")
                }

                ComboBox {
                    id: mouseButtonComboBox

                    textRole: "text"
                    valueRole: "value"
                    currentIndex: 0
                    model: ListModel {
                        id: mouseButtonsModel
                    }
                    onActivated: root.newMouseActionChanged()
                    Component.onCompleted: {
                        mouseButtonsModel.append({ text: KI18n.i18nc("@item:listbox left mouse button", "Left"), value: "Left" })
                        mouseButtonsModel.append({ text: KI18n.i18nc("@item:listbox middle mouse button", "Middle"), value: "Middle" })
                        mouseButtonsModel.append({ text: KI18n.i18nc("@item:listbox right mouse button", "Right"), value: "Right" })
                        mouseButtonsModel.append({ text: KI18n.i18nc("@item:listbox forward mouse button", "Forward"), value: "Forward" })
                        mouseButtonsModel.append({ text: KI18n.i18nc("@item:listbox back mouse button", "Back"), value: "Back" })
                        mouseButtonsModel.append({ text: KI18n.i18nc("@item:listbox mouse scroll up", "Scroll up"), value: "ScrollUp" })
                        mouseButtonsModel.append({ text: KI18n.i18nc("@item:listbox mouse scroll down", "Scroll down"), value: "ScrollDown" })
                    }
                    Layout.fillWidth: true
                    Layout.bottomMargin: Kirigami.Units.largeSpacing
                }

                Label {
                    text: KI18n.i18nc("@label:listbox", "Modifier key")
                }

                ComboBox {
                    id: modifierComboBox

                    textRole: "text"
                    valueRole: "value"
                    currentIndex: 0
                    model: ListModel {
                        id: modifiersModel
                    }
                    onActivated: root.newMouseActionChanged()
                    Component.onCompleted: {
                        modifiersModel.append({ text: KI18n.i18nc("@item:listbox no modifier key", "No modifier"), value: "NoModifier" })
                        modifiersModel.append({ text: KI18n.i18nc("@item:listbox control modifier key", "Control"), value: "Control" })
                        modifiersModel.append({ text: KI18n.i18nc("@item:listbox shift modifier key", "Shift"), value: "Shift" })
                        modifiersModel.append({ text: KI18n.i18nc("@item:listbox alt modifier key", "Alt"), value: "Alt" })
                        modifiersModel.append({ text: KI18n.i18nc("@item:listbox meta modifier key", "Meta"), value: "Meta" })
                    }
                    Layout.fillWidth: true
                    Layout.bottomMargin: Kirigami.Units.largeSpacing
                }

                CheckBox {
                    id: isDoubleClickCheckBox

                    text: KI18n.i18nc("@label:check whether mouse button action should trigger on double click",
                                      "Trigger on double click")
                    enabled: mouseButtonComboBox.currentIndex < 5
                    onClicked: root.newMouseActionChanged()
                    Layout.bottomMargin: Kirigami.Units.largeSpacing
                }

                Label {
                    text: KI18n.i18nc("@label", "Action")
                }

                RowLayout {
                    Layout.fillWidth: true

                    Button {
                        text: KI18n.i18nc("@action:button select mouse button action", "Select action")
                        visible: !selectedActionLabel.text
                        onClicked: mouseActionDialog.selectAction()
                    }

                    Label {
                        id: selectedActionLabel

                        property string actionName

                        font.weight: Font.Bold
                        Layout.fillWidth: true
                    }

                    Button {
                        text: KI18n.i18nc("@action:button", "Change action")
                        visible: selectedActionLabel.text
                        onClicked: mouseActionDialog.selectAction()
                    }
                }

                Kirigami.InlineMessage {
                    id: noActionSelectedMessage

                    text: KI18n.i18nc("@info", "No action selected")
                    type: Kirigami.MessageType.Warning
                    visible: selectedActionLabel.text === ""

                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.largeSpacing
                }

                Kirigami.InlineMessage {
                    id: actionExistsMessage

                    text: {
                        const model = Models.mouseActionsModel
                        const actionName = model.getAction(model.stringToMouseButton(mouseButtonComboBox.currentValue),
                                                           model.stringToModifier(modifierComboBox.currentValue),
                                                           isDoubleClickCheckBox.checked)
                        if (actionName === "") {
                            return ""
                        }
                        return KI18n.i18nc("@info", "Mouse button combination is already assigned to “%1”",
                                           HarunaApp.actions[actionName].text)
                    }
                    visible: text !== ""
                    type: Kirigami.MessageType.Warning

                    Layout.fillWidth: true
                    Layout.topMargin: Kirigami.Units.largeSpacing
                }
            }

            Connections {
                target: root
                function onNewMouseActionChanged() {
                    const button = mouseButtonComboBox.currentValue
                    const modifier = modifierComboBox.currentValue
                    const isDoubleClick = isDoubleClickCheckBox.checked

                    actionExistsMessage.visible = Models.mouseActionsModel.actionExists(button, modifier, isDoubleClick)
                    const okBtn = mouseActionDialog.standardButton(Dialog.Ok)
                    okBtn.enabled = mouseActionDialog.canBeSaved
                }
            }

            Component.onCompleted: {
                const okBtn = mouseActionDialog.standardButton(Dialog.Ok)
                if (okBtn) {
                    okBtn.enabled = false
                }
            }

            onAccepted: {
                Models.mouseActionsModel.addAction(selectedActionLabel.actionName,
                                                   mouseButtonComboBox.currentValue,
                                                   modifierComboBox.currentValue,
                                                   isDoubleClickCheckBox.checked)
            }
        }
    }
}
