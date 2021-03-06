#shellcheck disable=SC2155

# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

# Set 0 to disable, set 1 to enable PROMPT_ options
PROMPT_PS1_SIGNATURE=${PROMPT_PS1_SIGNATURE:-𝕬}
PROMPT_PS1_LEFT_ICON=${PROMPT_PS1_LEFT_ICON:-'⧉ '}
PROMPT_NO_COLOR=${PROMPT_NO_COLOR:-0}
PROMPT_NO_MODIFY_LSCOLORS=${PROMPT_NO_MODIFY_LSCOLORS:-0}
PROMPT_ENABLE_HISTORY_APPEND=${PROMPT_ENABLE_HISTORY_APPEND:-0}
PROMPT_PYTHON_VIRTUALENV_LEFT=${PROMPT_PYTHON_VIRTUALENV_LEFT:-venv:}

# Set empty string to disable, set non-empty string to enable GIT_ options
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

__prompt_os_kernel=$(uname -s)


#######################################################################
#                          Helper Fcuntions                           #
#######################################################################

if [[ $__prompt_os_kernel == Darwin ]]; then
  # grep not support unicode well in MacOS. So use perl instead of.
  __prompt_fix_middle_length() {
    local raw=$1
    # Match Chinese and Emoji characters
    local l=$(perl -CS -pe 's/[\x{4E00}-\x{9FA5}\x{1F601}-\x{1F64F}]+//g' <<< "$raw");
    printf '%s\n' "$(( ${#raw} - ${#l} ))"
  }
else
  __prompt_fix_middle_length() {
    grep -oE $'[\u4e00-\u9fa5😱]' <<< "$plain" | wc -l | tr -d ' ' || true
  }
fi

__prompt_debug() {
  echo "$@" >> ~/prompt_debug
}

# http://jafrog.com/2013/11/23/colors-in-terminal.html
__prompt_trim_str_color() {
  local ecs=$'\e'
  if [[ $__prompt_os_kernel == Darwin ]]; then
    # awful BSD sed
    sed -E "s,\\${ecs}[[0-9]*(;[0-9]+)*m,,g" <<< "$1"
  else
    sed -E "s,${ecs}[[0-9]*(;[0-9]+)*m,,g" <<< "$1"
  fi
}

# Wrapping in \[ \] is recommended by the Bash man page.
# This helps Bash ignore non-printable characters so that it correctly calculates the size of the prompt.
__prompt_wrap_color() {
  local ecs=$'\e'
  local start='\\['
  local end='\\]'
  if [[ $__prompt_os_kernel == Darwin ]]; then
    sed -E "s,\\${ecs}[[0-9]*(;[0-9]+)*m,${start}&${end},g" <<< "$1"
  else
    sed -E "s,${ecs}[[0-9]*(;[0-9]+)*m,${start}\\0${end},g" <<< "$1"
  fi
}

__prompt_check_precmd_conflict() {
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
    if ! __prompt_check_precmd_conflict "${1}" ; then
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

    if [[ ${PROMPT_COMMAND:-} =~ ${prompt_re} ]]; then
      return
    elif [[ -z ${PROMPT_COMMAND:-} ]]; then
      PROMPT_COMMAND="${1}"
    else
      PROMPT_COMMAND="${1};${PROMPT_COMMAND}"
    fi
  fi
}


#######################################################################
#                         Section Definitions                         #
#######################################################################

__ps1_section_exit_status() {
  local exit_status=$__ps1_last_exit_status
  if [[ $exit_status != 0 ]]; then
    printf '%b' "${__prompt_RED}[😱 $exit_status]"
  fi
}

__ps1_section_jobs() {
  local stopped=$(jobs -sp | wc -l | tr -d ' ')
  local running=$(jobs -rp | wc -l | tr -d ' ')

  if (( running > 0 )) || (( stopped > 0 )); then
    printf '%b' "${__prompt_GREY}[${__prompt_GREEN}Jobs ${running}${__prompt_GREY}|${__prompt_CYAN}${stopped}${__prompt_GREY}]"
  fi
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
  # For debug
  # local left=$1
  # local right=$2
  # local left_plain=$(__prompt_trim_str_color "$left")
  # local right_plain=$(__prompt_trim_str_color "$right")
  # local -i leftDbCharLen=$(grep -oE $'[\u4e00-\u9fa5]' <<< "$left_plain" | wc -l | tr -d ' ' || true)
  # local -i rightDbCharLen=$(grep -oE $'[\u4e00-\u9fa5]' <<< "$right_plain" | wc -l | tr -d ' ' || true)
  # local -i COLS=$(( COLUMNS - ${#left_plain} - ${#right_plain} - leftDbCharLen - rightDbCharLen ))

  # __prompt_debug "COLUMNS=$COLUMNS"
  # __prompt_debug "left.len=${#left} left_plain.len=${#left_plain}"
  # __prompt_debug "right.len=${#right} right_plain.len=${#right_plain}"
  # __prompt_debug "leftDbCharLen=$leftDbCharLen rightDbCharLen=$rightDbCharLen"
  # __prompt_debug "COLS=$COLS"
  # __prompt_debug -e "left=$left"
  # __prompt_debug -e "right=$right"
  # __prompt_debug -e "left_plain=$left_plain"
  # __prompt_debug -e "right_plain=$right_plain"

  local plain=$(__prompt_trim_str_color "$1$2")
  local fixLen=$(__prompt_fix_middle_length "$plain")
  local -i COLS=$(( COLUMNS - ${#plain} - fixLen ))

  if (( COLS < 1 )); then
    printf '\n %b' "${__prompt_GREEN}➥"
  else
    local LINE=''
    local CHAR='—'
    while (( ${#LINE} < COLS )); do
      LINE="$LINE$CHAR"
    done

    printf '%b' "${__prompt_GREY}${LINE}"
  fi
}

__ps1_section_reset_text() {
  printf '%b' "${__prompt_RESET_ALL}"
}

__ps1_section_python_virtualenv() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    printf '%b%s' "$__prompt_PURPLE" "[$PROMPT_PYTHON_VIRTUALENV_LEFT ${VIRTUAL_ENV##*/}]"
  fi
}

#######################################################################
#                         Command Definitions                         #
#######################################################################

__ps1_command_append_history() {
  [[ $PROMPT_ENABLE_HISTORY_APPEND == 1 ]] && history -a
}

#######################################################################
#                            Presentation                             #
#######################################################################

__ps1_right() {
  __ps1_section_exit_status
  __ps1_section_jobs
  __ps1_section_python_virtualenv
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
  # This line must be first
  local __ps1_last_exit_status=$?

  if [[ -z ${PROMPT_PS1:-} ]]; then
    local right="$(__ps1_right)"
    local left="$(__ps1_left)"
    local middle="$(__ps1_section_fill_middle_spaces "${left}" "${right}")"
    local main=$(__ps1_main)
    local _PS1="$left$middle$right\\n$(__prompt_wrap_color "$main") "

    if [[ $PROMPT_NO_COLOR == 1 ]]; then
      _PS1=$(__prompt_trim_str_color "$_PS1")
    fi

    PS1=$_PS1
  else
    PS1=$PROMPT_PS1
  fi

  __ps1_command_append_history
}

__prompt_append __prompt_command
