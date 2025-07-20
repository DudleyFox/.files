#!/usr/bin/sh
set -e

cd ~

mkdir -p github/DudleyFox
cd github/DudleyFox
git clone git@github.com:DudleyFox/.files.git

cp ~/github/DudleyFox/.files/.zshrc ~/.zshrc

mkdir -p ~/.config/nvim
cp -R -i .files/dot_config/* ~/.config/.

mkdir -p ~/.local
cp -R -i .files/dot_local/* ~/.local/.

cd ~/.config/nvim
git clone git@github.com:DudleyFox/kickstart.nvim.git .
git switch active

mkdir -p ~/.config/tmux/plugins/tpm
cd ~/.config/tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm .

curl https://mise.run | sh

echo "Changing shell to zsh..."
chsh -s /usr/bin/zsh








