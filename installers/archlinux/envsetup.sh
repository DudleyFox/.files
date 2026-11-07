#!/usr/bin/sh
set -e

SCRIPT_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH='' cd -- "$SCRIPT_DIR/../.." && pwd)

if [ "$(id -u)" -eq 0 ]; then
        echo 'Run this script as your normal user, not root' >&2
        exit 1
fi

# Keep the terminal on fd 3 so cp -i can prompt from inside piped loops
exec 3<&0

# copy_file SRC DST: skip if identical, copy if missing, ask if different
copy_file() {
        if [ -e "$2" ] && cmp -s "$1" "$2"; then
                return 0
        fi
        mkdir -p "$(dirname -- "$2")"
        if [ -e "$2" ]; then
                cp -i "$1" "$2" <&3
        else
                echo "Installing $2"
                cp "$1" "$2"
        fi
}

# copy_tree SRCDIR DSTDIR: copy_file every file under SRCDIR
copy_tree() {
        find "$1" -type f | while IFS= read -r src; do
                copy_file "$src" "$2/${src#"$1"/}"
        done
}

copy_file "$REPO_ROOT/.zshrc" "$HOME/.zshrc"
copy_tree "$REPO_ROOT/dot_config" "$HOME/.config"
copy_tree "$REPO_ROOT/dot_local" "$HOME/.local"

# Neovim config
NVIM_DIR=$HOME/.config/nvim
if [ -d "$NVIM_DIR/.git" ]; then
        echo "nvim config already cloned"
else
        git clone git@github.com:DudleyFox/kickstart.nvim.git "$NVIM_DIR"
fi
if [ "$(git -C "$NVIM_DIR" branch --show-current)" != "active" ]; then
        git -C "$NVIM_DIR" switch active
fi

# tmux plugin manager
TPM_DIR=$HOME/.config/tmux/plugins/tpm
if [ -d "$TPM_DIR/.git" ]; then
        echo "tpm already cloned"
else
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# mise
if command -v mise >/dev/null 2>&1 || [ -x "$HOME/.local/bin/mise" ]; then
        echo "mise already installed"
else
        curl https://mise.run | sh
fi

# Login shell
if [ "$(getent passwd "$(id -un)" | cut -d: -f7)" = "/usr/bin/zsh" ]; then
        echo "Shell is already zsh"
else
        echo "Changing shell to zsh..."
        chsh -s /usr/bin/zsh
fi

# git
if [ "$(git config --global --get pull.rebase || true)" = "true" ]; then
        echo "git pull.rebase already set"
else
        git config --global pull.rebase true
fi
