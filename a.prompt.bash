#shellcheck disable=SC2155

PS1_SIGNATURE=${PS1_SIGNATURE:-𝕬}
PS1_LEFT_ICON=${PS1_LEFT_ICON:-'⧉ '}
FORCE_COLOR_PROMPT=${FORCE_COLOR_PROMPT:-}
DEFAULT_PS1='\u@\h:\w\$'

export CLICOLOR=1
# Preview https://geoff.greer.fm/lscolors/
# BSD LSCOLORS
export LSCOLORS=exgxFxDxcxdgDEHbHDacad
# Linux LS_COLORS
export LS_COLORS='di=34:ln=36:so=1;35:pi=1;33:ex=32:bd=33;46:cd=1;33;1;44:su=1;37;41:sg=1;37;1;43:tw=30;42:ow=30;43'

GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWUPSTREAM="git"
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_STATESEPARATOR=" "

# if tput setaf 1 &> /dev/null; then
#     if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
#       MAGENTA=$(tput setaf 9)
#       ORANGE=$(tput setaf 172)
#       GREEN=$(tput setaf 190)
#       PURPLE=$(tput setaf 141)
#       WHITE=$(tput setaf 0)
#     else
#       MAGENTA=$(tput setaf 5)
#       ORANGE=$(tput setaf 4)
#       GREEN=$(tput setaf 2)
#       PURPLE=$(tput setaf 1)
#       WHITE=$(tput setaf 7)
#     fi
#     BOLD=$(tput bold)
#     RESET=$(tput sgr0)
# else
#     MAGENTA="\033[1;31m"
#     ORANGE="\033[1;33m"
#     GREEN="\033[1;32m"
#     PURPLE="\033[1;35m"
#     WHITE="\033[1;37m"
#     BOLD=""
#     RESET="\033[m"
# fi

# \[ \] are necessary. Refer to http://apple.stackexchange.com/a/258965
BLACK='\[\e[0;30m\]'
GREY='\[\e[0;90m\]'
RED='\[\e[0;31m\]'
GREEN='\[\e[0;32m\]'
YELLOW='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
PURPLE='\[\e[0;35m\]'
CYAN='\[\e[0;36m\]'
WHITE='\[\e[0;37;1m\]'

BOLD_BLACK='\[\e[30;1m\]'
BOLD_RED='\[\e[31;1m\]'
BOLD_GREEN='\[\e[32;1m\]'
BOLD_YELLOW='\[\e[33;1m\]'
BOLD_BLUE='\[\e[34;1m\]'
BOLD_PURPLE='\[\e[35;1m\]'
BOLD_CYAN='\[\e[36;1m\]'
BOLD_WHITE='\[\e[37;1m\]'

NORMAL_STYLE='\[\e[0m\]'
RESET_COLOR='\[\e[39m\]'

E_BLACK='\[\033[0;30m\]'
# E_GREY=$(tput setaf 8)
E_GREY='\[\033[0;90m\]'
E_RED='\[\033[0;31m\]'
E_GREEN='\[\033[0;32m\]'
E_YELLOW='\[\033[0;33m\]'
E_BLUE='\[\033[0;34m\]'
E_PURPLE='\[\033[0;35m\]'
E_CYAN='\[\033[0;36m\]'
E_WHITE='\[\033[0;37;1m\]'

E_BOLD_BLACK='\[\033[30;1m\]'
E_BOLD_RED='\[\033[31;1m\]'
E_BOLD_GREEN='\[\033[32;1m\]'
E_BOLD_YELLOW='\[\033[33;1m\]'
E_BOLD_BLUE='\[\033[34;1m\]'
E_BOLD_PURPLE='\[\033[35;1m\]'
E_BOLD_CYAN='\[\033[36;1m\]'
E_BOLD_WHITE='\[\033[37;1m\]'

E_NORMAL_STYLE='\[\033[0m\]'
E_RESET_COLOR='\[\033[39m\]'

if [[ -n "$FORCE_COLOR_PROMPT" ]]; then
  color_prompt=yes
else
  case "$TERM" in
    xterm-color | xterm-256color) color_prompt=yes;;
    screen-color | screen-256color) color_prompt=yes;;
    *) color_prompt=false;;
  esac
fi

##### Helper Functions #####

l.cursor_pos() {
  local CURPOS
  read -sdR -p $'\E[6n' CURPOS
  CURPOS=${CURPOS#*[} # Strip decoration characters <ESC>[
  echo "${CURPOS}"    # Return position in "row;col" format
}

l.cursor_row() {
  local COL
  local ROW
  IFS=';' read -sdR -p $'\E[6n' ROW COL
  echo "${ROW#*[}"
}

l.cursor_col() {
  local COL
  local ROW
  IFS=';' read -sdR -p $'\E[6n' ROW COL
  echo "${COL}"
}

# http://jafrog.com/2013/11/23/colors-in-terminal.html
__trim_str_color() {
  # \x1B does not work
  local ecs=$(printf '%b' '\033')
  local reg="s,\\\[${ecs}\[[0-9]*;?[0-9]*m\\\],,g"
  # local reg='s,\['$'\033''\[[0-9]*;?[0-9]*m\],,g'

  # printf '%b' "$1" | sed -E "$reg"
  sed -E "$reg" <<< "$1"
}

__check_precmd_conflict() {
  local f
  for f in "${precmd_functions[@]}"; do
    if [[ "${f}" == "${1}" ]]; then
      return 0
    fi
  done
  return 1
}

# Copy from bash-it. https://github.com/Bash-it/bash-it/blob/master/themes/base.theme.bash
__prompt_append() {
  local prompt_re

  if [ "${__bp_imported:-}" == "defined" ]; then
    # We are using bash-preexec
    if ! __check_precmd_conflict "${1}" ; then
      precmd_functions+=("${1}")
    fi
  else
    # Set OS dependent exact match regular expression
    if [[ ${OSTYPE} == darwin* ]]; then
      # macOS
      prompt_re="[[:<:]]${1}[[:>:]]"
    else
      # Linux, FreeBSD, etc.
      prompt_re="\\<${1}\\>"
    fi

    if [[ ${PROMPT_COMMAND} =~ ${prompt_re} ]]; then
      return
    elif [[ -z ${PROMPT_COMMAND} ]]; then
      PROMPT_COMMAND="${1}"
    else
      PROMPT_COMMAND="${1};${PROMPT_COMMAND}"
    fi
  fi
}

############################

##### Section Definitions #####

__ps1_section_exit_status() {
  local exit_status=$__ps1_last_exit_status
  if [[ $exit_status != 0 ]]; then
    printf '%s' "${E_RED}[😱 $exit_status]"
  fi
}

__ps1_section_jobs() {
  local stopped=$(jobs -sp | wc -l | tr -d ' ')
  local running=$(jobs -rp | wc -l | tr -d ' ')
  local sC=''
  local rC=''
  [[ $stopped -gt 0 ]] && sC="$E_YELLOW"
  [[ $running -gt 0 ]] && rC="$E_GREEN"

  printf '%b' "${E_GREY}[${rC}${running}r${E_GREY}/${sC}${stopped}s${E_GREY}]"
}

__ps1_section_time() {
  printf '%b[T%s]' "${E_YELLOW}" "$(date +'%H:%M:%S')"
}

__ps1_section_left_icon() {
  printf "%b" "${E_GREEN}${PS1_LEFT_ICON}"
}

__ps1_section_cwd() {
  printf '%b' "${E_GREY}[ ${E_GREEN}$(pwd) ${E_GREY}]"
}

__ps1_section_git() {
  if command -v __git_ps1 &>/dev/null ; then
    printf '%b' "${E_BLUE}$(__git_ps1 " (%s)")"
  fi
}

__ps1_section_indicator() {
  printf '%b' "${E_GREEN}${PS1_SIGNATURE}"
}

__ps1_mid() {
  IFS=';' c_pos=( $(l.cursor_pos) )
  local c_row="${c_pos[0]}"
  local c_col="${c_pos[1]}"
  local COLS=$(tput cols)

  local LINE=''
  local CHAR='—'
  while (( ${#LINE} < COLS )); do
    LINE="$LINE$CHAR"
  done

  # tput init
  tput sc
  tput cup "$c_row" 0
  printf '%b' "${E_GREY}$LINE"
  tput rep - "$COLS"
  tput cup "$(( c_row ))" 0
  # tput rc
  return 0
}

__ps1_section_fill_middle_spaces() {
  local PS1_left=$1
  local PS1_right=$2
  local LINE=''
  local CHAR='—'
  local PS1_left_plain=$(__trim_str_color "$PS1_left")
  local PS1_right_plain=$(__trim_str_color "$PS1_right")
  local -i doubleByteCharLen=$(grep -oE $'[\u4e00-\u9fa5]' <<< "$PS1_left_plain" | wc -l | tr -d ' ' || echo 0)
  ((doubleByteCharLen-=2))
  local COLS=$(( $(tput cols) - ${#PS1_left_plain} - ${#PS1_right_plain} - doubleByteCharLen ))

  # For debug
  # echo -e PS1_left=$PS1_left >> ~/debug
  # echo -e PS1_right=$PS1_right >> ~/debug
  # echo -e PS1_left_plain=$PS1_left_plain >> ~/debug
  # echo -e PS1_right_plain=$PS1_right_plain >> ~/debug

  if [[ -n "$TMUX" ]]; then
    COLS=$(( COLS - 1 ))
  fi

  if (( COLS < 1 )); then
    printf '\n%s' "${E_GREEN} ➥"
    return 0
  fi

  while (( ${#LINE} < COLS )); do
    LINE="$LINE$CHAR"
  done

  printf '%b' "${E_GREY}${LINE}"
}

###############################

__ps1_right() {
  # __ps1_section_exit_status must be first, because $? used
  __ps1_section_exit_status
  __ps1_section_jobs
  __ps1_section_time
}

__ps1_left() {
  __ps1_section_left_icon
  __ps1_section_cwd
}

__ps1_main() {
  __ps1_section_indicator
  __ps1_section_git
}

__prompt_command() {
  local __ps1_last_exit_status=$?
  local PS1_right="$(__ps1_right)"
  local PS1_left="$(__ps1_left)"
  local PS1_middle="$(__ps1_section_fill_middle_spaces "${PS1_left}" "${PS1_right}")"
  # local PS1_middle=""
  local _PS1="$PS1_left$PS1_middle$PS1_right\\n$(__ps1_main)${E_NORMAL_STYLE} "

  if [[ $color_prompt != yes ]]; then
    _PS1=$(__trim_str_color "$_PS1")
  fi

  # PS1=$DEFAULT_PS1
  PS1=$_PS1

  history -a
}

__prompt_append __prompt_command
