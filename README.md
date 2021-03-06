# A Bash Prompt

A Bash prompt written by pure Bash script. Make Bash great again!

It is a part of my [Bash dotfiles framework](https://github.com/adoyle-h/dotfiles).

## Preview

### Responsive prompt (Auto fit to window width).

![responsive-prompt.png](https://media.githubusercontent.com/media/adoyle-h/_imgs/master/github/a-bash-prompt/responsive-prompt.png)

### Show last command exit status

![exit-status.png](https://media.githubusercontent.com/media/adoyle-h/_imgs/master/github/a-bash-prompt/exit-status.png)

### Highlight Backgound jobs:

![jobs-labels.png](https://media.githubusercontent.com/media/adoyle-h/_imgs/master/github/a-bash-prompt/jobs-labels.png)

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
|     ❔    | BSD      | -       | Not tested yet. Maybe not support. |
|     🚫    | Windows  | -       | Never and ever supported.          |

### Supported Shells

| Supported | Shell | Version          | Main Reasons                                |
|:---------:|:------|:-----------------|:--------------------------------------------|
|     ❔    | Zsh   | v5 and higher    | Not tested yet.                             |
|     ✅    | Bash  | v5 and higher    | -                                           |
|     ✅    | Bash  | v4.2 and higher  | -                                           |
|     🚫    | Bash  | v3.x, v4.0, v4.1 | Associative array not supported  until v4.0 |

## Usage

Put this line in your `.bahsrc`.

`source <absolute-path>/a.prompt.bash`

## Advanced Usage

### Default options

Belows are default options:

```sh
PROMPT_PS1_SIGNATURE=𝕬
PROMPT_PS1_LEFT_ICON='⧉ '
PROMPT_NO_COLOR=0
PROMPT_ENABLE_HISTORY_APPEND=0
PROMPT_NO_MODIFY_LSCOLORS=0
PROMPT_PS1=
PROMPT_PYTHON_VIRTUALENV_LEFT='venv:'

# See https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWUPSTREAM=git
GIT_PS1_DESCRIBE_STYLE=branch
GIT_PS1_STATESEPARATOR=' '
```

You can set the variables to override defaults before source `a.prompt.bash`.

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

If `PROMPT_PS1` set, the PS1 in framework will be override by `PROMPT_PS1`.

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

Any suggestions and contributions are always welcome. Please open an [issue][] to talk with me.

## Versioning

See git [release tags][].

The versioning follows the rules of SemVer 2.0.0.

**Attentions**: anything may have **BREAKING CHANGES** at **ANY TIME** when major version is zero (0.y.z), which is for initial development and the public API should be considered unstable.

For more information on SemVer, please visit http://semver.org/.

## Copyright and License

Copyright (c) 2019-2020 ADoyle. The project is licensed under the **BSD 3-clause License**.

See the [LICENSE][] file for the specific language governing permissions and limitations under the License.

See the [NOTICE][] file distributed with this work for additional information regarding copyright ownership.

## Related Projects

- [shell-general-colors](https://github.com/adoyle-h/shell-general-colors): To generate [colors.bash](./colors.bash).

<!-- links -->

[issue]: https://github.com/adoyle-h/a-bash-prompt/issues
[release tags]: https://github.com/adoyle-h/a-bash-prompt/releases
[LICENSE]: ./LICENSE
[NOTICE]: ./NOTICE
