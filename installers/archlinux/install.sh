#!/usr/bin/sh
set -e

PKGS="autoconf automake base clang fd fzf git keychain less lua51 luarocks
make neovim ripgrep tmux unzip wget zsh"

# pacman -T prints only the packages that are not installed
# shellcheck disable=SC2086
missing=$(pacman -T $PKGS || true)
if [ -n "$missing" ]; then
        echo "Installing:" $missing
        # shellcheck disable=SC2086
        sudo pacman -Syu --needed --noconfirm $missing
else
        echo "All packages already installed"
fi

echo "Set up the private keys"
