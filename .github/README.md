# Natsuna

Natsuna is a personal fork of [Haruna](https://invent.kde.org/multimedia/haruna), the mpv-based media player from KDE. It keeps everything Haruna does, but with defaults that feel like VLC.

It installs and runs alongside Haruna: it has its own name, icon entry, binary (`natsuna`) and settings (`~/.config/natsuna/`).

## What's different from Haruna

**Mouse**
- A single click on the video does nothing (no accidental pausing).
- Double-click toggles fullscreen without a pause/play flicker.
- Middle click plays/pauses.
- If you set a single-click action yourself, it now waits for the double-click interval, so double-clicking never also fires it.

**Playlist**
- No longer slides out when the mouse touches the side of the window.
- Toggle it with **Ctrl+L** or the playlist button.

**VLC-style keyboard shortcuts**

| Key | Action |
|---|---|
| Space | Play / pause |
| F | Fullscreen |
| Esc | Leave fullscreen |
| ← / → | Seek |
| Ctrl+← / Ctrl+→ | Big seek |
| ↑ / ↓ | Volume |
| M | Mute |
| N / P | Next / previous file |
| S | Stop |
| Shift+S | Screenshot |
| V / Shift+V | Next / previous subtitle track |
| B / Shift+B | Next / previous audio track |
| L | Loop |
| Ctrl+L | Show / hide playlist |
| Ctrl+P | Settings |

All of these can still be changed under Settings → Shortcuts and Settings → Mouse.

## Building

Natsuna needs the same dependencies as Haruna (Qt ≥ 6.9, KDE Frameworks ≥ 6.24, mpv/MpvQt, FFmpeg). On a current KDE Plasma distro (Arch, openSUSE Tumbleweed, KDE neon, recent Fedora), installing Haruna's build dependencies is enough.

```bash
git clone https://github.com/TormStorm/natsuna.git
cd natsuna
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build build -j"$(nproc)"

./build/bin/natsuna            # run without installing
cmake --install build          # or install to ~/.local (adds it to the app menu)
```

## Keeping up to date with Haruna

Natsuna's changes live in a few small commits on top of Haruna, so upstream updates merge in cleanly most of the time.

**On GitHub:** open the repository page and click **Sync fork → Update branch**.

**From the command line:**

```bash
git remote add upstream https://invent.kde.org/multimedia/haruna.git   # once
git fetch upstream
git merge upstream/master
git push
```

If a merge conflicts, it will almost always be in one of the files touched by the Natsuna commits (shortcut defaults in `src/models/actionsmodel.cpp`, mouse defaults, or the renamed app identity). Keep Haruna's new code and re-apply the Natsuna value.

## Credits and license

All the real work is Haruna's, by George Florea Bănuș and the KDE community. Natsuna is distributed under the same GPL-3.0-or-later license. Please report Natsuna-specific issues here, not to KDE.
