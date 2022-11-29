# .bashrc_aliases, 2016-12-18

export HISTSIZE=1024
export HISTFILESIZE=4096
export HISTIGNORE=exit
export HISTCONTROL=ignoreboth

export LESSCHARSET="utf-8"
export VISUAL=/usr/bin/vim

umask 0022
set -o ignoreeof
shopt -s cdspell checkjobs checkwinsize extglob histappend globstar

unalias ls &>/dev/null

alias ..='cd ..'
alias ...='cd ../..'
alias cp='/bin/cp -iv'
alias mv='/bin/mv -iv'
alias rm='/bin/rm -v'
alias chmod='chmod -c'
alias grep='grep --color=auto'
alias flush='for s in $(seq 57); do echo; done'
alias ssync='rsync -lrtvP -e ssh -B 8192 --stats'
alias ll='ls -lp --color=auto --group-directories-first'
alias l=':'

mkcd() {
  mkdir -pv "$@" && cd "$1"
}

oma_ip() {
  dig +short myip.opendns.com @resolver1.opendns.com
}

lpgrep() {
  while [ -n "$1" ]; do
    pgrep $1 | ifne xargs ps wu | tail -n +2
    shift
  done
}

if tput setaf 1 &>/dev/null; then
  RST=$(tput sgr0)
  BLU=$(tput setaf 4)
  WHI=$(tput setaf 7)
  PS1="\[$WHI\][\h] \[$BLU\]\w \$\[$RST\] "
fi
