#shellcheck disable=SC2155

# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

# set 0 to disable, set 1 to enable PROMPT_ options
PROMPT_PS1_SIGNATURE=${PROMPT_PS1_SIGNATURE:-𝕬}
PROMPT_PS1_LEFT_ICON=${PROMPT_PS1_LEFT_ICON:-'⧉ '}
PROMPT_NO_COLOR=${PROMPT_NO_COLOR:-0}
PROMPT_NO_MODIFY_LSCOLORS=${PROMPT_NO_MODIFY_LSCOLORS:-0}
PROMPT_ENABLE_HISTORY_APPEND=${PROMPT_ENABLE_HISTORY_APPEND:-0}

# set empty string to disable, set non-empty string to enable GIT_ options
GIT_PS1_SHOWDIRTYSTATE=${GIT_PS1_SHOWDIRTYSTATE:-1}
GIT_PS1_SHOWSTASHSTATE=${GIT_PS1_SHOWSTASHSTATE:-1}
GIT_PS1_SHOWUNTRACKEDFILES=${GIT_PS1_SHOWUNTRACKEDFILES:-1}
GIT_PS1_SHOWCOLORHINTS=${GIT_PS1_SHOWCOLORHINTS:-true}
GIT_PS1_SHOWUPSTREAM=${GIT_PS1_SHOWUPSTREAM:-git}
GIT_PS1_DESCRIBE_STYLE=${GIT_PS1_DESCRIBE_STYLE:-branch}
GIT_PS1_STATESEPARATOR=${GIT_PS1_STATESEPARATOR:-' '}

if [[ "$PROMPT_NO_COLOR" != 1 ]]; then
  export CLICOLOR=1

  if [[ $PROMPT_NO_MODIFY_LSCOLORS != 1 ]]; then
    # BSD LSCOLORS
    export LSCOLORS=exgxFxDxcxdgDEHbHDacad
    # Linux LS_COLORS
    export LS_COLORS='di=34:ln=36:so=1;35:pi=1;33:ex=32:bd=33;46:cd=1;33;1;44:su=1;37;41:sg=1;37;1;43:tw=30;42:ow=30;43'
  fi
fi

source "$(dirname "${BASH_SOURCE[0]}")"/colors.bash

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
  local ecs=$'\e'
  sed -E "s,${ecs}[[0-9]*(;[0-9]+)*m,,g" <<< "$1"
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
    printf '%s' "${__prompt_RED}[😱 $exit_status]"
  fi
}

__ps1_section_jobs() {
  local stopped=$(jobs -sp | wc -l | tr -d ' ')
  local running=$(jobs -rp | wc -l | tr -d ' ')
  local sC=''
  local rC=''
  [[ $stopped -gt 0 ]] && sC="$__prompt_YELLOW"
  [[ $running -gt 0 ]] && rC="$__prompt_GREEN"

  printf '%b' "${__prompt_GREY}[${rC}${running}r${__prompt_GREY}/${sC}${stopped}s${__prompt_GREY}]"
}

__ps1_section_time() {
  printf '%b[T%s]' "${__prompt_YELLOW}" "$(date +'%H:%M:%S')"
}

__ps1_section_left_icon() {
  printf "%b" "${__prompt_GREEN}${PROMPT_PS1_LEFT_ICON}"
}

__ps1_section_cwd() {
  printf '%b' "${__prompt_GREY}[ ${__prompt_GREEN}$(pwd) ${__prompt_GREY}]"
}

__ps1_section_git() {
  if command -v __git_ps1 &>/dev/null ; then
    printf '%b' "${__prompt_BLUE}$(__git_ps1 " (%s)")"
  fi
}

__ps1_section_indicator() {
  printf '%b' "${__prompt_GREEN}${PROMPT_PS1_SIGNATURE}"
}

__ps1_section_fill_middle_spaces() {
  local PS1_left=$1
  local PS1_right=$2
  local PS1_left_plain=$(__trim_str_color "$PS1_left")
  local PS1_right_plain=$(__trim_str_color "$PS1_right")
  local -i doubleByteCharLen=$(grep -oE $'[\u4e00-\u9fa5]' <<< "$PS1_left_plain" | wc -l | tr -d ' ' || echo 0)
  (( doubleByteCharLen > 0 )) && ((doubleByteCharLen-=2))
  local -i COLS=$(( COLUMNS - ${#PS1_left_plain} - ${#PS1_right_plain} - doubleByteCharLen ))

  # For debug
  # echo "COLUMNS=$COLUMNS" >> ~/prompt_debug
  # echo "PS1_left.len=${#PS1_left} PS1_left_plain.len=${#PS1_left_plain}" >> ~/prompt_debug
  # echo "PS1_right.len=${#PS1_right} PS1_right_plain.len=${#PS1_right_plain}" >> ~/prompt_debug
  # echo "doubleByteCharLen=$doubleByteCharLen" >> ~/prompt_debug
  # echo "COLS=$COLS" >> ~/prompt_debug
  # echo -e "PS1_left=$PS1_left" >> ~/prompt_debug
  # echo -e "PS1_right=$PS1_right" >> ~/prompt_debug
  # echo -e "PS1_left_plain=$PS1_left_plain" >> ~/prompt_debug
  # echo -e "PS1_right_plain=$PS1_right_plain" >> ~/prompt_debug

  if [[ -n "${TMUX:-}" ]]; then
    COLS=$(( COLS - 1 ))
  fi

  if (( COLS < 1 )); then
    printf '\n %s' "${__prompt_GREEN}➥"
    return 0
  fi

  local LINE=''
  local CHAR='—'
  while (( ${#LINE} < COLS )); do
    LINE="$LINE$CHAR"
  done

  printf '%b' "${__prompt_GREY}${LINE}"
}

__ps1_section_reset_text() {
  printf '%b' "${__prompt_RESET_ALL}"
}

###############################


##### Command Definitions #####

__ps1_command_append_history() {
  history -a
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
  __ps1_section_reset_text
}

__prompt_command() {
  if [[ -z ${PROMPT_PS1:-} ]]; then
    local __ps1_last_exit_status=$?
    local PS1_right="$(__ps1_right)"
    local PS1_left="$(__ps1_left)"
    local PS1_middle="$(__ps1_section_fill_middle_spaces "${PS1_left}" "${PS1_right}")"
    local _PS1="$PS1_left$PS1_middle$PS1_right\\n$(__ps1_main)${C_RESET_ALL} "

    if [[ $PROMPT_NO_COLOR == 1 ]]; then
      _PS1=$(__trim_str_color "$_PS1")
    fi

    PS1=$_PS1
  else
    PS1=$PROMPT_PS1
  fi

  [[ $PROMPT_ENABLE_HISTORY_APPEND == 1 ]] && history -a
}

__prompt_append __prompt_command
