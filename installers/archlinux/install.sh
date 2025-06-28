
#!/usr/bin/sh
set -e

sudo pacman -Sy --noconfirm autoconf
sudo pacman -Sy --noconfirm automake
sudo pacman -Sy --noconfirm base
sudo pacman -Sy --noconfirm clang
sudo pacman -Sy --noconfirm fd
sudo pacman -Sy --noconfirm fzf
sudo pacman -Sy --noconfirm git
sudo pacman -Sy --noconfirm keychain
sudo pacman -Sy --noconfirm less
sudo pacman -Sy --noconfirm lua51
sudo pacman -Sy --noconfirm luarocks
sudo pacman -Sy --noconfirm make
sudo pacman -Sy --noconfirm neovim
sudo pacman -Sy --noconfirm openssh
sudo pacman -Sy --noconfirm ripgrep
sudo pacman -Sy --noconfirm tmux
sudo pacman -Sy --noconfirm unzip
sudo pacman -Sy --noconfirm wget
sudo pacman -Sy --noconfirm zsh

sudo systemctl start sshd
sudo systemctl enable sshd
sudo ufw allow 22/tcp

echo "Set up the private keys"
