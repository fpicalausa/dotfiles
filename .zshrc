_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1  # Because we didn't really complete anything
}

zstyle ':completion:*' auto-description '%d'
zstyle ':completion:*:warnings' format '%BSorry, no matches for %d%b'
zstyle ':completion:*' completer _expand _complete _ignored  _correct _match _approximate _prefix _force_rehash
zstyle ':completion:*' completions 1
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format 'Matches for %d'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' match-original both
zstyle ':completion:*' matcher-list '' '' '+m:{a-z}={A-Z} m:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=** l:|=*'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' menu select=1
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' prompt '%e errors recovered'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/fpicalausa/.zshrc'

zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

bindkey -v
bindkey '' backward-delete-char
bindkey '[3~' delete-char
bindkey '[1~' beginning-of-line
bindkey '[4~' end-of-line
bindkey 'OH' beginning-of-line
bindkey 'OF' end-of-line
bindkey '' history-incremental-pattern-search-backward
bindkey '' end-of-line
bindkey '' beginning-of-line

autoload -Uz compinit
compinit

autoload -U promptinit
promptinit

autoload -U colors
colors

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
ZLS_COLORS=$LS_COLORS
setopt incappendhistory autocd extendedglob notify histignoredups histignorealldups correctall sharehistory VI autopushd histreduceblanks
# End of lines configured by zsh-newuser-install

alias ls='ls -G'
alias lla='ls -G -la'
alias grep='grep --color=force'
alias less='less -R'

alias tmux='tmux -2'
alias emacs='TERM=xterm-256color emacs'

alias halt='sudo shutdown -h now'
alias reboot='sudo shutdown -r now'

alias chmox='chmod u+x'

alias clojure='clojure1.3'

foreach cmd (cat vim rm)
    alias su$cmd="sudo $cmd"
end
foreach cmd (locate find wget)
    alias $cmd="noglob $cmd"
end
foreach cmd (mkdir)
    alias $cmd="nocorrect $cmd"
end

export EDITOR="vim"
export LSCOLORS=cxExcxdxbxegedbHdHacag 
export PATH=$PATH:~/bin

################################################################################
# Prompt (powerline style, or plain)
################################################################################
function nofunkyprompt() {
    export PS1="%{$fg_bold[green]%}%n@%m %# %{$fg_no_bold[default]%}"
    export RPROMPT="%{$fg_bold[blue]%}%~%{$fg_no_bold[default]%}"
}

function funkyprompt() {
    ARROW_RIGHT=$'\u2b80'
    ARROW_LEFT=$'\u2b82'

    export PS1="%{$bg_bold[green]%}%T %{$reset_color$fg_no_bold[green]%}$ARROW_RIGHT%{$reset_color%} "
    export RPROMPT="%{$fg_no_bold[white]%}$ARROW_LEFT%{$bg_bold[white]$fg_bold[black]%}%~%{$reset_color%}"
}

funkyprompt
################################################################################

if [ -r ~/.zsh_local ] 
then
    source ~/.zsh_local
fi
