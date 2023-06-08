# A Bash Prompt

A Bash prompt written by pure Bash script. Make Bash great again!

All prompt sections are configurable, extendable and easy to use.

## Preview

### Responsive prompt (Auto fit to window width).

![responsive-prompt.png](https://media.githubusercontent.com/media/adoyle-h/_imgs/master/github/a-bash-prompt/responsive-prompt.png)

### Show last command exit status

![exit-status.png](https://media.githubusercontent.com/media/adoyle-h/_imgs/master/github/a-bash-prompt/exit-status.png)

### Highlight Backgound jobs:

![jobs-labels.png](https://media.githubusercontent.com/media/adoyle-h/_imgs/master/github/a-bash-prompt/jobs-labels.png)

### Bubble Style and Block Style

![bubble-and-block-styles.png](https://media.githubusercontent.com/media/adoyle-h/_imgs/master/github/a-bash-prompt/bubble-and-block-styles.png)

### Quick preview in container

You can easily preview it in container.

```sh
# build docker image (default bash 4.4)
./build
# run and enter container (default bash 4.4)
./run

# or build with specific bash version
./build 5.0
./run 5.0
```

## Prerequisites

### Supported Platform

| Supported | Platform | Version | Main Reasons                       |
|:---------:|:---------|:--------|:-----------------------------------|
|     ✅    | MacOS    | *       | -                                  |
|     ✅    | Linux    | *       | -                                  |
|     ✅    | BSD      | *       | -                                  |
|     🚫    | Windows  | -       | Never and ever supported.          |

### Supported Shells

| Supported | Shell | Version          | Main Reasons                                |
|:---------:|:------|:-----------------|:--------------------------------------------|
|     ❔    | Zsh   | v5 and higher    | Not tested yet.                             |
|     ✅    | Bash  | v5 and higher    | -                                           |
|     ✅    | Bash  | v4.2 and higher  | -                                           |
|     🚫    | Bash  | v3.x, v4.0, v4.1 | Associative array not supported  until v4.0 |

## Versions

Read [tags][].
The versions follows the rules of [SemVer 2.0.0](http://semver.org/).

## Install

```sh
git clone https://github.com/adoyle-h/a-bash-prompt.git
echo "source $PWD/a-bash-prompt/a.prompt.bash" > ~/.bahsrc
```

## Default Options

You can set these variables before and after `source a.prompt.bash` to override defaults options.

You can modify `PROMPT_NO_COLOR`, `PROMPT_COLOR_*` and `PROMPT_STYLE_*` variables to change the display in runtime.

Available colors: RED GREEN YELLOW BLUE PURPLE CYAN WHITE BLACK GREY
Available styles: bubble block square none
(Case-sensitive)

Belows are default options.

### Others

```sh
PROMPT_NO_COLOR=0               # If set 1, no color printed
PROMPT_NO_MODIFY_LSCOLORS=0
PROMPT_PS1=''                   # If `PROMPT_PS1` is not empty, the PS1 in framework will be override.
```

### Layout

You can rearrange the layout.

```sh
PROMPT_LAYOUT_RIGHT=( exit_status jobs python_virtualenv time )
PROMPT_LAYOUT_LEFT=( left_icon user hostname cwd )
PROMPT_LAYOUT_MAIN=( indicator git reset_text )
```

### Time Clock

```sh
PROMPT_ENABLE_TIME=1
PROMPT_STYLE_TIME=block
PROMPT_COLOR_TIME=YELLOW
PROMPT_FORMAT_TIME='T%s'        # You can set ' %s'
PROMPT_PS1_TIME_DATE_FORMAT='+%H:%M:%S' # date +%H:%M:%S
```

### Front and Backgound Jobs

```sh
PROMPT_ENABLE_JOB=1
PROMPT_STYLE_JOB=block
PROMPT_COLOR_JOB=CYAN
PROMPT_FORMAT_JOB='Jobs %s'
```

### Process Exit Status Code

```sh
PROMPT_ENABLE_EXIT_STATUS=1
PROMPT_STYLE_EXIT_STATUS=block
PROMPT_COLOR_EXIT_STATUS=RED
PROMPT_FORMAT_EXIT_STATUS='😱 %s'
```

### Current Work Directory

```sh
PROMPT_ENABLE_CWD=1
PROMPT_STYLE_CWD=block
PROMPT_COLOR_CWD=GREEN
PROMPT_FORMAT_CWD=' %s '
```

### Current User

```sh
PROMPT_ENABLE_USER=0
PROMPT_STYLE_USER=square
PROMPT_COLOR_USER=CYAN
PROMPT_FORMAT_USER='%s'
```

### Hostname

```sh
PROMPT_ENABLE_HOSTNAME=0
PROMPT_STYLE_HOSTNAME=square
PROMPT_COLOR_HOSTNAME=PURPLE
PROMPT_FORMAT_HOSTNAME='%s'
```

### Git branch and status

```sh
PROMPT_ENABLE_GIT=1
PROMPT_COLOR_GIT=BLUE
PROMPT_STYLE_GIT=none
PROMPT_FORMAT_GIT='%b'
# See https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWUPSTREAM=git
GIT_PS1_DESCRIBE_STYLE=branch
GIT_PS1_STATESEPARATOR=' '
```

### Python Virtual Environment

```sh
PROMPT_ENABLE_PYTHON_VENV=1
PROMPT_STYLE_PYTHON_VENV=block
PROMPT_COLOR_PYTHON_VENV=PURPLE
PROMPT_FORMAT_PYTHON_VENV='%s'
PROMPT_PYTHON_VIRTUALENV_LEFT='venv:'
```

### Left Icon

```sh
PROMPT_ENABLE_LEFT_ICON=1
PROMPT_STYLE_LEFT_ICON=none
PROMPT_COLOR_LEFT_ICON=GREEN
PROMPT_FORMAT_LEFT_ICON='%s '
PROMPT_PS1_LEFT_ICON='⧉ '
```

### Indicator

```sh
PROMPT_ENABLE_INDICATOR=1
PROMPT_STYLE_INDICATOR=none
PROMPT_COLOR_INDICATOR=GREEN
PROMPT_FORMAT_INDICATOR='%s '
PROMPT_PS1_INDICATOR='𝕬'
```

### History Append

call `history -a` each time.

```sh
PROMPT_ENABLE_HISTORY_APPEND=0
```

## Advanced Usage

### Write section to extend prompt

```sh
__ps1_section_hello() {
  [[ ${PROMPT_ENABLE_HELLO:-1} == 0 ]] && return
  local PROMPT_STYLE_HELLO=${PROMPT_STYLE_HELLO:-block}
  local PROMPT_COLOR_HELLO=${PROMPT_COLOR_HELLO:-GREEN}
  local PROMPT_FORMAT_HELLO=${PROMPT_FORMAT_HELLO:-'%s'}
  __ps1_print_section HELLO "hello world"
}

PROMPT_LAYOUT_RIGHT+=( hello )
```

Then you will get these.

![write-your-section.png](https://media.githubusercontent.com/media/adoyle-h/_imgs/master/github/a-bash-prompt/write-your-section.png)

### Git-prompt is slow

If you feel slow in git directory. Disable these options will make it faster.

```sh
GIT_PS1_SHOWDIRTYSTATE=
GIT_PS1_SHOWSTASHSTATE=
GIT_PS1_SHOWUNTRACKEDFILES=
```

See https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh

You can also disable git-prompt completely by `unset __git_ps1`.

### Override PS1

If `PROMPT_PS1` set, the PS1 in framework will be override.

```sh
PROMPT_PS1='\u@\h:\w\$ '
```

### Disable prompt color

Set `PROMPT_NO_COLOR=1`.

![no-color.png](https://media.githubusercontent.com/media/adoyle-h/_imgs/master/github/a-bash-prompt/no-color.png)

### Do not modify LS_COLORS variable

a-bash-prompt will modify `LSCOLORS` and `LS_COLORS` by default.

Set `PROMPT_NO_MODIFY_LSCOLORS=1` to disable it.

### Refresh bash_history

bash_history file will not be refreshed before exit shell by default.

If you use tmux, it may cause some troubles.
Set `PROMPT_ENABLE_HISTORY_APPEND=1` to refresh bash_history each command.

## Suggestion, Bug Reporting, Contributing

**Before opening new Issue/Discussion/PR and posting any comments**, please read [Contributing Guidelines](https://gcg.adoyle.me/CONTRIBUTING).

## Copyright and License

Copyright 2019-2023 ADoyle (adoyle.h@gmail.com). Some Rights Reserved.
The project is licensed under the **BSD 3-clause License**.

See the [LICENSE][] file for the specific language governing permissions and limitations under the License.

See the [NOTICE][] file distributed with this work for additional information regarding copyright ownership.

## Other Projects

- [shell-general-colors](https://github.com/adoyle-h/shell-general-colors): To generate [colors.bash](./colors.bash).
- [one.share](https://github.com/one-bash/one.share)
- [Other shell projects](https://github.com/adoyle-h?tab=repositories&q=&type=source&language=shell&sort=stargazers) created by me.


<!-- links -->

[LICENSE]: ./LICENSE
[NOTICE]: ./NOTICE
[tags]: https://github.com/adoyle-h/a-bash-prompt/tags
