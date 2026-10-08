#!/usr/bin/env bash
# TNFX-Plasma installation script
# Installs KDE Plasma 6 appearance configuration

set -e

echo "TNFX-Plasma: Installing KDE Plasma 6 appearance configuration..."

# Check if we are running on a system with KDE Plasma
if ! command -v plasmashell &> /dev/null; then
    echo "Warning: plasmashell not found. Are you running KDE Plasma?"
    echo "Continue anyway? (y/N)"
    read -r answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Define paths
REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="$HOME/.config"
LOCAL_SHARE_DIR="$HOME/.local/share"
BACKUP_DIR="$HOME/.config-TNFX-Plasma-backup-$(date +%Y%m%d-%H%M%S)"

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo "Backup directory: $BACKUP_DIR"

# List of config files and directories to backup and install
declare -a FILES=(
    "kdeglobals"
    "plasmarc"
    "plasmashellrc"
    "kwinrc"
    "plasma-org.kde.plasma.desktop-appletsrc"
    "kglobalshortcutsrc"
    "kcminputrc"
    "gtk-3.0/settings.ini"
    "gtk-4.0/settings.ini"
    "user-dirs.dirs"
)

# Backup existing files
for file in "${FILES[@]}"; do
    src="$CONFIG_DIR/$file"
    if [[ -e "$src" ]]; then
        # Create parent directories in backup
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        cp -r "$src" "$BACKUP_DIR/$file"
        echo "Backed up: $file"
    fi
done

# Backup gtk directories (entire directories? we only backup settings.ini but we'll backup the dir)
for gtkver in 3.0 4.0; do
    src="$CONFIG_DIR/gtk-$gtkver"
    if [[ -d "$src" ]]; then
        mkdir -p "$BACKUP_DIR/gtk-$gtkver"
        cp -r "$src" "$BACKUP_DIR/gtk-$gtkver"
        echo "Backed up: gtk-$gtkver"
    fi
done

# Copy files from repo to config
for file in "${FILES[@]}"; do
    src="$REPO_DIR/config/$file"
    dest="$CONFIG_DIR/$file"
    if [[ -f "$src" ]]; then
        # Ensure destination directory exists
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
        echo "Copied: $file"
    elif [[ -d "$src" ]]; then
        # Copy directory recursively
        cp -r "$src" "$dest"
        echo "Copied directory: $file"
    fi
done

# Copy gtk directories (we already copied via FILES, but ensure)
# Install bundled wallpaper
echo "Installing bundled wallpaper..."
mkdir -p "$LOCAL_SHARE_DIR/wallpapers"
cp "$REPO_DIR/wallpapers/Aritim-Dark-Wallpaper-1920x1080.jpg" "$LOCAL_SHARE_DIR/wallpapers/"
echo "Installed wallpaper: Aritim-Dark-Wallpaper-1920x1080.jpg"
for gtkver in 3.0 4.0; do
    src="$REPO_DIR/config/gtk-$gtkver"
    dest="$CONFIG_DIR/gtk-$gtkver"
    if [[ -d "$src" ]]; then
        mkdir -p "$dest"
        cp -r "$src"/* "$dest/"
        echo "Copied gtk-$gtkver contents"
    fi
done

# Replace placeholder paths with actual home directory
echo "Replacing placeholder paths..."
sed -i "s|/home/<username>|$HOME|g" "$CONFIG_DIR/plasmarc"
sed -i "s|/home/<username>|$HOME|g" "$CONFIG_DIR/plasma-org.kde.plasma.desktop-appletsrc"

# Notify user
echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "1. Replace the ICC profile path in $CONFIG_DIR/kwinoutputconfig.json (if you kept it) with your actual ICC profile."
echo "   Note: kwinoutputconfig.json was not included due to hardware specificity; configure your monitors manually."
echo "2. Install the required themes:"
echo "   - Look-and-Feel: Utterly-Nord (via KDE Store or package manager)"
echo "   - Plasma Style: Breeze (or your preferred theme)"
echo "   - Icon Theme: breeze-dark (usually part of breeze-icons)"
echo "   - Cursor Theme: breeze_cursors (or your preferred cursor theme)"
echo "3. The bundled wallpaper is already installed in $HOME/.local/share/wallpapers/"
echo "   Additional wallpapers can be added to $HOME/.local/share/wallpapers/"
echo "4. Log out and log back in, or run: kglobalaccel --replace && plasmashell --replace"
echo ""
echo "To restore backup, copy files from $BACKUP_DIR back to $CONFIG_DIR"
