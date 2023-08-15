# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# free cache  !!
#echo "confirm elevated drop cache:"
#sudo sh -c "sync; echo 1 > /proc/sys/vm/drop_caches"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# 12 sets this to disable the stop key (prevent freezing output on C-s)
stty stop ""

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi
# ${debian_chroot:+($debian_chroot)}

# set a fancy prompt (non-color, unless we know we "want" color)
color_prompt=yes
force_color_prompt=yes

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

case $TERM in
	xterm*)
		function git_branch {
			if [ -f ~/.__git_branch ]; then
				local branch="`~/.__git_branch`"
				branch="${branch##ref: refs/heads/}"
			fi
		}
		function esc {
			echo "\[\e$1\]$2"
		}
		PS1=""
		PS1+="`esc ']0;\u: \w\a'       `" # set window title
		PS1+="`esc '[0;4;38;5;22m' '${debian_chroot:+($debian_chroot)}'`" # reset attributes, underline, dark blue.
		PS1+="`esc '[1;34m'        '\w'`" # bold, blue.  Current Path
		PS1+="`esc '[39;22m'       '>' `" # reset color, reset bold.  ">"
		PS1+="`esc '[m'            ' ' `" # reset attribytes.  Space
		unset -f esc

		# magic function which prints a newline before printing prompt
		# if the cursor is not at the start of the row
		if [ "`tput u6`" = $'\e[%i%d;%dR' ]
		then
			PROMPT_COMMAND=_my_prompt_command
			function _my_prompt_command {
				local curpos
				IFS=';' read -p"`tput u7`" -d'R' -s -t5 _ curpos
				((curpos!=1)) && echo
				tput sgr0 el #reset colors, clear row
			}
		fi
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# nicer LS colors
eval "$(dircolors /etc/dircolors.ansi-dark)"

# Alias definitions.
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

# terminal settings
export COLORTERM=truecolor
export TERM=ms-terminal

export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
#export XDG_RUNTIME_DIR=~/
export RUNLEVEL=3
#sudo /etc/init.d/dbus
export PULSE_SERVER=tcp:localhost
export DTK_PROGRAM=espeak

# use homedir (encryption support) tmp
export TMPDIR=$HOME/tmp

# wt fast emacs
alias emacs='emacsclient -a "" -c'
export EDITOR=emacs

# start emacs server if not already running
if [ $(emacsclient -a false -e 't') ]
then echo 'emacs already running'
else emacsclient -a "" -c -e '(delete-frame)'
fi

# add some program locations to path
if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
	PATH=$PATH:"/mnt/c/Windows;/mnt/c/Windows/System32;"; export PATH;
fi
# rust installed programs
PATH="~/.cargo/bin:$PATH"; export PATH
