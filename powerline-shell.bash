#!/usr/bin/env bash

__powerline() {
  readonly branch_indicator='⎇'
  readonly clean_indicator='✓'
  readonly dirty_indicator='✗'
  readonly push_indicator='⇡'
  readonly pull_indicator='⇣'
  readonly color_fg_base="\[$(tput setaf 0)\]"
  readonly color_bg_base="\[$(tput setab 7)\]"
  readonly color_bg_git="\[$(tput setab 1)\]"
  readonly color_reset="\[$(tput sgr0)\]"

  __repository_status() {
    [ -x $(hash git 2>/dev/null) ] || return
    local -r git_en="env LANG=C git"
    local -r branch=$($git_en symbolic-ref --short HEAD 2>/dev/null || $git_en describe --tags --always 2>/dev/null)

    [ -n "$branch" ] || return
    local indicators=" $clean_indicator"
    [ -n "$($git_en status --porcelain)" ] && indicators=" $dirty_indicator"

    __branch_status() {
      $git_en status --branch --porcelain | egrep '^##' | egrep -o "$1 \d+" | egrep -o '\d'
    }

    local -r commits_ahead="$(__branch_status ahead)"
    [ -n "$commits_ahead" ] && indicators+=" $push_indicator$commits_ahead"
    local -r commits_behind="$(__branch_status behind)"
    [ -n "$commits_behind" ] && indicators+=" $pull_indicator$commits_behind"
    printf " $branch_indicator  $branch$indicators "
  }

  __ps1() {
    PS1="$color_bg_base$color_fg_base \w $color_reset"
    PS1+="$color_bg_git$color_fg_base$(__repository_status)$color_reset\n└─▪ "
  }

  PROMPT_COMMAND="__ps1 ; $PROMPT_COMMAND"
}

__powerline
unset __powerline
