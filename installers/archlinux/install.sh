#!/usr/bin/sh
set -e

PKGS="autoconf automake base clang fd fzf git keychain less lua51 luarocks
make neovim ripgrep tmux tree-sitter-cli unzip wget zsh"

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

# SSH keys: github.com uses the default key, growl.foxnet gets its own
SSH_DIR=$HOME/.ssh
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# make_key FILE COMMENT: generate an ed25519 key unless FILE already exists
make_key() {
        if [ -e "$1" ]; then
                echo "SSH key $1 already exists"
        else
                echo "Generating SSH key $1 (enter a passphrase when asked)"
                ssh-keygen -t ed25519 -C "$2" -f "$1"
        fi
}

make_key "$SSH_DIR/id_ed25519" "$(id -un)@$(uname -n) github.com"
make_key "$SSH_DIR/id_ed25519_growl" "$(id -un)@$(uname -n) growl.foxnet"

SSH_CONFIG=$SSH_DIR/config
if [ -e "$SSH_CONFIG" ] && grep -qE '^Host[[:space:]]+growl\.foxnet([[:space:]]|$)' "$SSH_CONFIG"; then
        echo "growl.foxnet already in $SSH_CONFIG"
else
        echo "Adding growl.foxnet to $SSH_CONFIG"
        printf '\nHost growl.foxnet\n\tIdentityFile ~/.ssh/id_ed25519_growl\n\tIdentitiesOnly yes\n' >> "$SSH_CONFIG"
fi
chmod 600 "$SSH_CONFIG"

echo
echo "Add these public keys before running envsetup.sh:"
echo "  github.com:   $(cat "$SSH_DIR/id_ed25519.pub")"
echo "  growl.foxnet: $(cat "$SSH_DIR/id_ed25519_growl.pub")"
