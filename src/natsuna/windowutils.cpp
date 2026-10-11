/*
 * SPDX-FileCopyrightText: 2026 Natsuna contributors
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "windowutils.h"

#include "config-haruna.h"

#include <QCoreApplication>
#include <QDir>
#include <QTemporaryFile>
#include <QWindow>

#if HAVE_DBUS
#include <QDBusConnection>
#include <QDBusConnectionInterface>
#include <QDBusMessage>
#include <QDBusReply>
#endif

using namespace Qt::StringLiterals;

NatsunaWindowUtils::NatsunaWindowUtils(QObject *parent)
    : QObject(parent)
{
}

void NatsunaWindowUtils::setKeepAbove(QWindow *window, bool keepAbove)
{
    if (!window) {
        return;
    }

    if (setKeepAboveWithKWin(keepAbove)) {
        return;
    }

    // Not running under KWin: ask the window manager through Qt.
    // Changing window flags can hide the window, so show it again if needed.
    const bool wasVisible = window->isVisible();
    window->setFlag(Qt::WindowStaysOnTopHint, keepAbove);
    if (wasVisible && !window->isVisible()) {
        window->show();
    }
}

bool NatsunaWindowUtils::setKeepAboveWithKWin(bool keepAbove)
{
#if HAVE_DBUS
    auto bus = QDBusConnection::sessionBus();
    if (!bus.isConnected() || !bus.interface() || !bus.interface()->isServiceRegistered(u"org.kde.KWin"_s)) {
        return false;
    }

    // A tiny KWin script that sets "Keep Above Others" on this app's windows.
    const QString script = uR"(
const windows = workspace.windowList ? workspace.windowList() : workspace.clientList();
for (const w of windows) {
    if (w.pid === %1 && w.normalWindow) {
        w.keepAbove = %2;
    }
}
)"_s.arg(QCoreApplication::applicationPid())
                               .arg(keepAbove ? u"true"_s : u"false"_s);

    QTemporaryFile file(QDir::tempPath() + u"/natsuna-keepabove-XXXXXX.js"_s);
    if (!file.open()) {
        return false;
    }
    file.write(script.toUtf8());
    file.flush();

    const QString pluginName = u"natsuna-keepabove"_s;
    const QString service = u"org.kde.KWin"_s;
    const QString scriptingPath = u"/Scripting"_s;
    const QString scriptingIface = u"org.kde.kwin.Scripting"_s;

    // Remove a leftover copy from an earlier call, if any.
    auto unload = QDBusMessage::createMethodCall(service, scriptingPath, scriptingIface, u"unloadScript"_s);
    unload << pluginName;
    bus.call(unload);

    auto load = QDBusMessage::createMethodCall(service, scriptingPath, scriptingIface, u"loadScript"_s);
    load << file.fileName() << pluginName;
    QDBusReply<int> scriptId = bus.call(load);
    if (!scriptId.isValid() || scriptId.value() < 0) {
        return false;
    }

    auto run = QDBusMessage::createMethodCall(service,
                                              u"/Scripting/Script%1"_s.arg(scriptId.value()),
                                              u"org.kde.kwin.Script"_s,
                                              u"run"_s);
    const auto runReply = bus.call(run);

    bus.call(unload);

    return runReply.type() != QDBusMessage::ErrorMessage;
#else
    Q_UNUSED(keepAbove)
    return false;
#endif
}
