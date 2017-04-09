# /etc/bashrc

# System wide functions and aliases
# Environment stuff goes in /etc/profile

# It's NOT a good idea to change this file unless you know what you
# are doing. It's much better to create a custom.sh shell script in
# /etc/profile.d/ to make custom changes to your environment, as this
# will prevent the need for merging in future updates.

# are we an interactive shell?
if [ "$PS1" ]; then
  if [ -z "$PROMPT_COMMAND" ]; then
    case $TERM in
    xterm*|vte*)
      if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
      elif [ "${VTE_VERSION:-0}" -ge 3405 ]; then
          PROMPT_COMMAND="__vte_prompt_command"
      else
          PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
      fi
      ;;
    screen*)
      if [ -e /etc/sysconfig/bash-prompt-screen ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
      else
          PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
      fi
      ;;
    *)
      [ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default
      ;;
    esac
  fi
  # Turn on parallel history
  shopt -s histappend
  history -a
  # Turn on checkwinsize
  shopt -s checkwinsize
  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
  # You might want to have e.g. tty in prompt (e.g. more virtual machines)
  # and console windows
  # If you want to do so, just add e.g.
  # if [ "$PS1" ]; then
  #   PS1="[\u@\h:\l \W]\\$ "
  # fi
  # to your custom modification shell script in /etc/profile.d/ directory
fi

if ! shopt -q login_shell ; then # We're not a login shell
    # Need to redefine pathmunge, it get's undefined at the end of /etc/profile
    pathmunge () {
        case ":${PATH}:" in
            *:"$1":*)
                ;;
            *)
                if [ "$2" = "after" ] ; then
                    PATH=$PATH:$1
                else
                    PATH=$1:$PATH
                fi
        esac
    }

    # By default, we want umask to get set. This sets it for non-login shell.
    # Current threshold for system reserved uid/gids is 200
    # You could check uidgid reservation validity in
    # /usr/share/doc/setup-*/uidgid file
    if [ $UID -gt 199 ] && [ "`id -gn`" = "`id -un`" ]; then
       umask 002
    else
       umask 022
    fi

    SHELL=/bin/bash
    # Only display echos from profile.d scripts if we are no login shell
    # and interactive - otherwise just process them to set envvars
    for i in /etc/profile.d/*.sh; do
        if [ -r "$i" ]; then
            if [ "$PS1" ]; then
                . "$i"
            else
                . "$i" >/dev/null
            fi
        fi
    done

    unset i
    unset -f pathmunge
fi

#something for the smiely. 

## Colors?  Used for the prompt.
#Regular text color
BLACK='\[\e[0;30m\]'
#Bold text color
BBLACK='\[\e[1;30m\]'
#background color
BGBLACK='\[\e[40m\]'
RED='\[\e[0;31m\]'
BRED='\[\e[1;31m\]'
BGRED='\[\e[41m\]'
GREEN='\[\e[0;32m\]'
BGREEN='\[\e[1;32m\]'
BGGREEN='\[\e[1;32m\]'
YELLOW='\[\e[0;33m\]'
BYELLOW='\[\e[1;33m\]'
BGYELLOW='\[\e[1;33m\]'
BLUE='\[\e[0;34m\]'
BBLUE='\[\e[1;34m\]'
BGBLUE='\[\e[1;34m\]'
MAGENTA='\[\e[0;35m\]'
BMAGENTA='\[\e[1;35m\]'
BGMAGENTA='\[\e[1;35m\]'
CYAN='\[\e[0;36m\]'
BCYAN='\[\e[1;36m\]'
BGCYAN='\[\e[1;36m\]'
WHITE='\[\e[0;37m\]'
BWHITE='\[\e[1;37m\]'
BGWHITE='\[\e[1;37m\]'

PROMPT_COMMAND=smile_prompt

function smile_prompt
{
if [ "$?" -eq "0" ]
then
#smiley
SC="${GREEN}:)"
else
#frowney
SC="${RED}:("
fi
if [ $UID -eq 0 ]
then
#root user color
UC="${RED}"
else
#normal user color
UC="${BWHITE}"
fi
#hostname color
HC="${BYELLOW}"
#regular color
RC="${BWHITE}"
#default color
DF='\[\e[0m\]'




PS1="\[\033[0;37m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\h'; else echo '\[\033[0;33m\]\u\[\033[0;37m\]@\[\033[0;96m\]\h'; fi)\[\033[0;37m\]]\342\224\200[\[\033[0;32m\]\w\e[0m \T\[\033[0;37m\]\e[97m  ${SC}${DF} \n\[\033[0;37m\]\342\224\224\342\224\200\342\224\200> \[\033[0m\]"

}
# vim:ts=4:sw=4
