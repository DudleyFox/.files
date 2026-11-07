#!/usr/bin/sh
set -e

USER_NAME=fox
PKGS="sudo openssh"

if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi

# User
if id "$USER_NAME" >/dev/null 2>&1; then
        echo "User $USER_NAME already exists"
else
        useradd -m "$USER_NAME"
fi

# Packages (pacman -T prints only the ones not installed)
# shellcheck disable=SC2086
missing=$(pacman -T $PKGS || true)
if [ -n "$missing" ]; then
        # shellcheck disable=SC2086
        pacman -Syu --needed --noconfirm $missing
else
        echo "Packages already installed: $PKGS"
fi

# Sudoers
SUDOERS_FILE=/etc/sudoers.d/$USER_NAME
if grep -qE "^$USER_NAME[[:space:]]" /etc/sudoers || [ -e "$SUDOERS_FILE" ]; then
        echo "sudo already configured for $USER_NAME"
else
        mkdir -p /etc/sudoers.d
        echo "$USER_NAME   ALL=(ALL:ALL) ALL" > "$SUDOERS_FILE"
        chmod 0440 "$SUDOERS_FILE"
        if ! visudo -cf "$SUDOERS_FILE" >/dev/null; then
                rm -f "$SUDOERS_FILE"
                echo "Generated sudoers file failed validation; removed it" >&2
                exit 1
        fi
fi

# Password (status field P = usable password set)
if [ "$(passwd -S "$USER_NAME" | awk '{print $2}')" = "P" ]; then
        echo "Password already set for $USER_NAME"
else
        echo "Set the password for $USER_NAME:"
        passwd "$USER_NAME"
fi

echo "Run the install.sh script next as the user $USER_NAME"
