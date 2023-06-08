# Changelog

All notable changes to this project will be documented in this file.

The format is inspired by [Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/).

The versions follow the rules of [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

[Full Changes](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/compare/v2.0.0...HEAD)


<a name="v2.0.0"></a>
## v2.0.0 (2023-06-08 17:12:17 +08:00)

[Full Changes](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/compare/v1.3.1...v2.0.0)

### Breaking Changes

Have 1 breaking changes. Check below logs with ⚠️ .

### New Features

- support PROMPT_PS1_TIME_DATE_FORMAT ([a50bb66](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/a50bb6616eb2c8d0b83c460a09cb05e8520822b6))
  > Defaults to '+%H:%M:%S'. It is used for `date +%H:%M:%S`.
- user can change the section layout ([8d258e3](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/8d258e3c93336e4c26ceb7636b88697ec01ec065))
  > Default Layout:
  > - PROMPT_LAYOUT_RIGHT=( exit_status jobs python_virtualenv time )
  > - PROMPT_LAYOUT_LEFT=( left_icon user hostname cwd )
  > - PROMPT_LAYOUT_MAIN=( indicator git reset_text )
- ⚠️  add INDICATOR ([14df408](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/14df408312023bf84af188e31e59cd87d36162b0))
  > - support PROMPT_ENABLE_INDICATOR. Is is enabled by default.
  > 
  > Breaking Change:
  > 
  > - using PROMPT_PS1_INDICATOR instead of PROMPT_PS1_SIGNATURE
  > - using PROMPT_COLOR_INDICATOR instead of PROMPT_COLOR_SIGNATURE
- add USER ([a0bba0b](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/a0bba0b6e403b47fd08afc29ce3d4c14c8480bfc))
  > - Enable it via `PROMPT_ENABLE_USER=1`. It is disabled by default.
- add HOSTNAME and PROMPT_COLOR_BG ([29cec72](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/29cec72bc990c47813436f35d4bcb5a8b92cfe2b))
  > - Set `PROMPT_ENABLE_HOSTNAME=1` to enable it. default to 0.
  > - `PROMPT_STYLE_HOSTNAME=square`. support square or bubble or block
  > - `PROMPT_COLOR_HOSTNAME=PURPLE`
  > - User can change the background color of prompt via `PROMPT_COLOR_BG=BLACK`

### Document Changes

- better document ([c2cefe6](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/c2cefe6e8a2e2ed008366aeb029a3cbd03e9b574))

<a name="v1.3.1"></a>
## v1.3.1 (2023-02-10 14:59:56 +08:00)

[Full Changes](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/compare/v1.3.0...v1.3.1)

### Document Changes

- renew license date && update contributing ([46c7037](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/46c703789d08a2bea42bac493476794484defc84))
- add docs and Github Issue Templates ([cac9c46](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/cac9c46586b6a16223aa2db9f3b67155698e6069))

<a name="v1.3.0"></a>
## v1.3.0 (2022-11-22 20:23:30 +08:00)

[Full Changes](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/compare/v1.2.1...v1.3.0)

### New Features

- support user defined FORMAT ([1fb1c05](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/1fb1c0524d0507145b9662c287a250ba1b3775ea))
  > add PROMPT_FORMAT_CWD PROMPT_FORMAT_TIME PROMPT_FORMAT_EXIT_STATUS PROMPT_FORMAT_JOB

<a name="v1.2.1"></a>
## v1.2.1 (2022-11-10 16:49:39 +08:00)

[Full Changes](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/compare/v1.2.0...v1.2.1)

### Bug Fixes

- use RESET_BG instead of BG_BLACK ([474ca8a](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/474ca8a277922c254726a01c53fa1f4f59a39cdf))

<a name="v1.2.0"></a>
## v1.2.0 (2022-10-27 19:55:50 +08:00)

[Full Changes](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/compare/v1.1.0...v1.2.0)

### New Features

- support PROMPT_COLOR_* variables ([bb08887](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/bb088870665853daef52fca90456ed20a100a6bb))

<a name="v1.1.0"></a>
## v1.1.0 (2022-10-18 11:37:40 +08:00)

[Full Changes](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/compare/v1.0.1...v1.1.0)

### New Features

- new prompt style "bubble" ([f346948](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/f346948df03ee6c7c334374dc0ade95bdae62c6d))
  > You can set variables PROMPT_STYLE_CWD, PROMPT_STYLE_TIME, PROMPT_STYLE_EXIT_STATUS, PROMPT_STYLE_JOB.
  > Old style named "block".
- add python virtualenv section ([2181415](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/2181415fd18bf057342077ae354592db696bcdaa))

### Bug Fixes

- change jobs section presentation && update README ([b6e9eff](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/b6e9eff82c47a90c4c7be906d89494eefdbb8bae))
- shell throw error when set -u ([1cdc677](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/1cdc677579620e2e0c9772dd99c3d08fd021394f))

### Document Changes

- renew copyright date ([e45de5d](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/e45de5d38c5b2b28ccee9d7a8ef99b20961fa521))

<a name="v1.0.1"></a>
## v1.0.1 (2019-06-16 15:22:53 +08:00)

[Full Changes](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/compare/v1.0.0...v1.0.1)

### Bug Fixes

- compatible with BSD sed ([943a0ae](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/943a0ae7df3cc5d8e029774e91fccd4d3a71456e))

### Document Changes

- add no-color image ([b29861a](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/b29861aec51858454767475150188312b43dd570))
- update README ([9ea6e8d](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/9ea6e8d864063b7d2aaedb9efca05f46c77185b5))

<a name="v1.0.0"></a>
## v1.0.0 (2019-06-15 15:53:51 +08:00)


### Bug Fixes

- wrong middle line width because Chinese and Emoji are double width characters ([ee58237](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/ee582371319122543b6db2cfc5a69668a99b13cb))
- long input not clean when pressed ctrl-u ([883e12d](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/883e12d4ed1a5013a96cad437f66b8d43fd2d404))

### Document Changes

- update README ([5515e88](https://github.com/https://github.com/adoyle-h/a-bash-prompt.git/commit/5515e88b41957a3749f789e1a0e5e6a78e827599))
