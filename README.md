# TNFX-Plasma

TNFX-Plasma is a portable KDE Plasma 6 desktop appearance/configuration repository.

## Preview

![TNFX-Plasma desktop](screenshots/desktop.png)

## Author

Maintained by GitHub user: TNFX1

## Configuration Overview

This repository contains KDE Plasma 6 configuration files for desktop appearance and layout:

- **Desktop Layout**: Configured plasma-org.kde.plasma.desktop-appletsrc with folder view containment
- **Panel Configuration**: Bottom panel with application launcher, task manager, system tray, and clock
- **Wallpaper**: Configured to use Aritim-Dark-Wallpaper-1920x1080.jpg (bundled in this repository)
- **Appearance Settings**: 
  - Look-and-Feel: Utterly-Nord (referenced, not bundled)
  - Plasma Style: blackglass (referenced, not bundled)
  - Color Scheme: Derived from Utterly-Nord
  - Icon Theme: Breeze Dark
  - Cursor Theme: Breeze Cursor
  - Window Decoration: Aurorae engine
  - Application Style: Breeze
  - Font Configuration: System defaults
- **GTK Settings**: Matched Breeze theme for GTK 3.0 and 4.0 applications
- **KWin Configuration**: Effects enabled (blur, translucency, wobbly windows), VSYNC disabled, OpenGL 3.1
- **Keyboard Shortcuts**: Custom shortcuts configured in kglobalshortcutsrc
- **Global Settings**: kdeglobals and plasmashellrc configurations

## Themes

This repository contains **configuration references** to the following third-party themes. The actual theme assets are **NOT bundled** due to redistribution restrictions:

- **Look-and-Feel Package**: [`Utterly-Nord`](https://store.kde.org/p/1266491/)
- **Plasma Style (Desktop Theme)**: [`blackglass`](https://store.kde.org/p/1313929/)
- **Icon Theme**: `Breeze Dark` (typically part of `breeze-icons` package)
- **Cursor Theme**: `Breeze Cursor` (default Plasma theme)

Install these themes via KDE System Settings → Get New Look-and-Feel, or through your distribution's package manager before applying this configuration.

## Bundled Assets

The following assets **ARE included** in this repository:
- Wallpaper: `wallpapers/Aritim-Dark-Wallpaper-1920x1080.jpg`
- All KDE Plasma configuration files in the `config/` directory
- GTK 3.0 and 4.0 settings configuration

## Installation

### Automatic Installation (Recommended)

```bash
git clone https://github.com/TNFX1/TNFX-Plasma.git
cd TNFX-Plasma
./install.sh
```

The installation script will:
1. Verify KDE Plasma 6 availability
2. Backup existing configuration to `~/.config-TNFX-Plasma-backup-<timestamp>/`
3. Copy configuration files to `~/.config/`
4. Replace path placeholders with your actual `$HOME`
5. Provide post-installation instructions

After installation, log out and back in, or run `plasmashell --replace` to apply changes.

### Manual Installation

1. Clone or copy this repository to your machine
2. Backup current KDE config (recommended): `cp -r ~/.config ~/.config.backup`
3. Copy config directory contents: `cp -r config/* ~/.config/` (merge gtk directories correctly)
4. Replace all occurrences of `/home/<username>` in the copied configuration files with your actual `$HOME` path (e.g., `/home/youruser`)
5. Install required themes (see "Themes" section above)
6. Wallpaper is already bundled and configured; additional wallpapers can be added to `$HOME/.local/share/wallpapers/`
7. Restart Plasma: log out and back in, or run `plasmashell --replace`

## Requirements

- KDE Plasma 6 (developed/tested on 6.7.5 on CachyOS)
- Expected compatibility with other KDE Plasma 6 versions
- Qt 6 and KDE Frameworks 6
- Optional: `breeze-icons` for icon theme
- Optional: Aurorae engine for window decoration (built-in)

## Important Notes

- Some settings are machine/display/session dependent and may require adjustment after installation:
  - Monitor-specific configurations
  - Wallpaper paths (if using additional wallpapers)
  - Color profiles
  - KWin behavior affecting multi-monitor setups
  - Hardware-specific behaviors
- The repository does **not** intentionally contain passwords, API keys, private keys, network credentials, or personal data
- This configuration focuses on visual appearance and desktop layout only
- No system-wide changes are made; all modifications are user-specific

## Repository Structure

```
TNFX-Plasma/
├── config/
│   ├── kdeglobals
│   ├── plasmarc
│   ├── plasmashellrc
│   ├── kwinrc
│   ├── plasma-org.kde.plasma.desktop-appletsrc
│   ├── kglobalshortcutsrc
│   ├── gtk-3.0/
│   │   └── settings.ini
│   └── gtk-4.0/
│       └── settings.ini
├── screenshots/
│   └── desktop.png
├── wallpapers/
│   └── Aritim-Dark-Wallpaper-1920x1080.jpg
└── install.sh
```

## License

No license has currently been included for this repository. The configuration is provided as-is for reference and adaptation.