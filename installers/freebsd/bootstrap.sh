#!/usr/bin/sh
set -e

if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi

# Run pkg once to get it installed on the system
pkg

# now install git to get the /user/ports tree
pkg install -y git

# get the ports
git clone --depth 1 https://git.FreeBSD.org/ports.git /usr/ports

#install portmaster
cd /usr/ports/ports-mgmt/portmaster

make install clean

cd ../..

# fix the dumb perl default
echo "DEFAULT_VERSIONS+= perl5=5.40" > /etc/make.conf

portmaster -o lang/perl5.40 lang/perl5.36

portmaster -f `pkg shlib -qR libperl.so.5.36`

rm /etc/make.conf

# install with default options
export BATCH=yes

# add the needed shells
portmaster -G --no-confirm shells/bash 
portmaster -G --no-confirm shells/zsh 

# add everything else
portmaster -G --no-confirm sysutils/tmux
portmaster -G --no-confirm sysutils/fd
portmaster -G --no-confirm sysutils/mise
portmaster -G --no-confirm security/keychain
portmaster -G --no-confirm textproc/ripgrep
portmaster -G --no-confirm textproc/fzf
portmaster -G --no-confirm lang/lua51
portmaster -G --no-confirm devel/luarocks
portmaster -G --no-confirm ftp/wget

portmaster -G --no-confirm editors/neovim

echo "Set up the private keys"


