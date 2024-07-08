# Git autocompletion
autoload -Uz compinit && compinit
# Colors in zsh
autoload -U colors && colors
PROMPT="%F{yellow%}%~ %F{white}% "

# Enable spell checker
setopt correct
# Setup prompt
export SPROMPT="Correct %R to %r? [Yes, No, Abort, Edit] "

# ls colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegebagacad

export EDITOR=nvim

alias ls='ls --color=auto'
alias ll='ls -lh'

