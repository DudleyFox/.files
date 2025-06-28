# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd nomatch notify PROMPT_SUBST
unsetopt beep extendedglob
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/fox/.zshrc'

autoload -Uz compinit
compinit

function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}

PROMPT='
#--[%B%F{202}%~%f%b]-[%B%F{62}$(parse_git_branch)%f%b]-[%T]-->
'

eval $(keychain --eval --quiet id_ed25519 id_rsa ~/.ssh/githubkey)
eval $(keychain --eval --quiet id_ed25519 id_rsa ~/.ssh/id_ed25519)

# End of lines added by compinstall
eval "$(/home/fox/.local/bin/mise activate zsh)"
