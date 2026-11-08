#!/usr/bin/env bash
# TNFX-Plasma installer: copies KDE Plasma 6 config, themes and widgets into $HOME.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
SHARE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
BACKUP_DIR="$HOME/.config-TNFX-Plasma-backup-$(date +%Y%m%d-%H%M%S)"

if ! command -v plasmashell &>/dev/null; then
    read -rp "plasmashell not found. Are you running KDE Plasma 6? Continue anyway? (y/N) " answer
    [[ "$answer" =~ ^[Yy]$ ]] || exit 1
fi

# Back up every config file this repo will overwrite.
mkdir -p "$BACKUP_DIR"
(cd "$REPO_DIR/config" && find . -type f) | while read -r f; do
    if [[ -e "$CONFIG_DIR/$f" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$f")"
        cp -a "$CONFIG_DIR/$f" "$BACKUP_DIR/$f"
    fi
done
echo "Backup: $BACKUP_DIR"

# Desktops are bound to an activity UUID that differs per user; read this user's before copying.
activity_id="$(qdbus6 org.kde.ActivityManager /ActivityManager/Activities CurrentActivity 2>/dev/null || true)"
if [[ -z "$activity_id" ]]; then
    activity_id="$(sed -n '/^\[activities\]/,/^\[/{s/^\([0-9a-f-]\{36\}\)=.*/\1/p}' "$CONFIG_DIR/kactivitymanagerdrc" 2>/dev/null | head -n1)"
fi

# plasmashell rewrites its panel/desktop config on exit, so it must be stopped before copying.
was_running=false
if pgrep -x plasmashell >/dev/null; then
    was_running=true
    echo "Stopping plasmashell..."
    systemctl --user stop plasma-plasmashell.service 2>/dev/null || kquitapp6 plasmashell 2>/dev/null || pkill -x plasmashell || true
    for _ in $(seq 20); do pgrep -x plasmashell >/dev/null || break; sleep 0.5; done
fi

mkdir -p "$CONFIG_DIR" "$SHARE_DIR/wallpapers"
cp -r "$REPO_DIR/config/." "$CONFIG_DIR/"
cp -r "$REPO_DIR/local-share/." "$SHARE_DIR/"
cp "$REPO_DIR/wallpapers/"* "$SHARE_DIR/wallpapers/"

# Configs store absolute paths; point them at this user's home.
grep -rlF "/home/<username>" "$REPO_DIR/config" | while read -r f; do
    sed -i "s|/home/<username>|$HOME|g" "$CONFIG_DIR/${f#"$REPO_DIR/config/"}"
done

# Empty activityId makes Plasma attach the desktop to the current activity.
sed -i "s|<activity-id>|$activity_id|g" "$CONFIG_DIR/plasma-org.kde.plasma.desktop-appletsrc"

# Reload open kitty windows with the new config.
pkill -USR1 -x kitty 2>/dev/null || true

# Make KWin and kded pick up the new settings without a relogin where possible.
qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true

if $was_running; then
    echo "Starting plasmashell..."
    systemctl --user start plasma-plasmashell.service 2>/dev/null || (setsid plasmashell &>/dev/null &)
fi

cat <<EOF

Done. Log out and back in to apply everything (cursor, GTK, shortcuts).
Weather widget: set your location from its settings.
To undo: cp -r "$BACKUP_DIR/." "$CONFIG_DIR/"
EOF
