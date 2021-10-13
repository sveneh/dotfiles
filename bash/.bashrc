# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# https://unix.stackexchange.com/a/556267
# each command only once saved. start with `space` to not save in history, e.g. for pwds
HISTCONTROL=ignorespace:erasedups
# append to the history file, don't overwrite it:Wq
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=2000
function _historymerge {
    history -n; history -w; history -c; history -r;
}
trap _historymerge EXIT
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#### integrations

# wsl-specific settings
if [[ $(uname --kernel-release) =~ [Mm]icrosoft ]] ; then
    export PATH=~/bin:$PATH
    # put Shortcut into `shell:startup`:
    # "C:\Program Files\VcXsrv\vcxsrv.exe" :0 -ac -multiwindow -clipboard -wgl
    # WSL 2 only  
    export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0
    # openshift
    which oc > /dev/null && source <(oc completion bash)
    # vscode
    export DONT_PROMPT_WSL_INSTALL=1

    # Windows Tools mappings
    alias nmap='"/mnt/c/Program Files (x86)/Nmap/nmap.exe"'
fi

# homebrew
[[ -f /home/linuxbrew/.linuxbrew/bin/brew ]] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# snapcraft
which snapcraft > /dev/null && export SNAPCRAFT_BUILD_ENVIRONMENT=lxd

# byobu
[ -r ~/.byobu/prompt ] && source ~/.byobu/prompt

# docker buildkit option
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# autojump
[ -r /usr/share/autojump/autojump.sh ] && source /usr/share/autojump/autojump.sh

# fzf
[ -d /snap/fzf/current/shell ] && source /snap/fzf/current/shell/completion.bash && source /snap/fzf/current/shell/key-bindings.bash

# git
export PS1='$(__git_ps1 " (%s)") '$PS1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1

# kubectl krew + Wuerth plugins
export PATH="${PATH}:${HOME}/.krew/bin:${HOME}/wuerth/code/infrastructure/plugins"

# kube_ps1
if [ -e  /home/linuxbrew/.linuxbrew/opt/kube-ps1/share/kube-ps1.sh ] ; then 
  kube_ps1_cluster_short () {
      [[ "$1" =~ api-(.+)-squeegee ]] && echo ${BASH_REMATCH[1]} ;
  }
  source "/home/linuxbrew/.linuxbrew/opt/kube-ps1/share/kube-ps1.sh"
  KUBE_PS1_BINARY=oc
  KUBE_PS1_CLUSTER_FUNCTION=kube_ps1_cluster_short
  export PS1='$(kube_ps1)'$PS1
fi

# kube prompt
# oc krew install prompt
if command oc prompt &> /dev/null ; then
  export KUBECTL_CLUSTER_PROMPT="api-prod01-squeegee-cloud:6443"
  oc () {
      kube=$(which oc)
      $kube prompt "${@}" && command $kube "${@}"
  }
fi

# npm
[ -d ~/.npm-global ] && export PATH=~/.npm-global/bin:$PATH

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion" 

# Perl cpanm
if [ -d  ~/perl5/lib/perl5 ] ; then
  eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
  export MANPATH=$HOME/perl5/man:$MANPATH
fi
