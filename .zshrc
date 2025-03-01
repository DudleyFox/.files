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
    in_wd="$(git rev-parse --is-inside-work-tree 2>/dev/null)" || return
    test "$in_wd" = true || return
    state=''
    git update-index --refresh -q >/dev/null # avoid false positives with diff-index
    if git rev-parse --verify HEAD >/dev/null 2>&1; then
        git diff-index HEAD --quiet 2>/dev/null || state='*'
    else
        state='#'
    fi
    (
        d="$(git rev-parse --show-cdup)" &&
        cd "$d" &&
        test -z "$(git ls-files --others --exclude-standard .)"
    ) >/dev/null 2>&1 || state="${state}+"
    branch="$(git symbolic-ref HEAD 2>/dev/null)"
    test -z "$branch" && branch='<detached-HEAD>'
    echo "${branch#refs/heads/}${state}"
}

PROMPT='
#--[%B%F{202}%~%f%b]-[%B%F{62}$(parse_git_branch)%f%b]-[%T]-->
'

# End of lines added by compinstall
