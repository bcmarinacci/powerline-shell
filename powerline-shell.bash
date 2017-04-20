#!/usr/bin/env bash

__powerline() {
  readonly branch_indicator='⎇'
  readonly clean_indicator='✓'
  readonly dirty_indicator='✗'
  readonly staged_indicator='+'
  readonly unstaged_indicator='-'
  readonly untracked_indicator='?'
  readonly push_indicator='⇡'
  readonly pull_indicator='⇣'
  readonly color_fg_base="\[$(tput setaf 0)\]"
  readonly color_bg_base="\[$(tput setab 7)\]"
  readonly color_bg_exit_nonzero="\[$(tput setab 1)\]"
  readonly color_bg_exit_zero="\[$(tput setab 2)\]"
  readonly color_bg_git="\[$(tput setab 3)\]"
  readonly color_reset="\[$(tput sgr0)\]"

  __num_files() {
    $git_en status --porcelain | egrep "$1" | wc -l | egrep -o '\d+'
  }

  __branch_status() {
    $git_en status --branch --porcelain | egrep '^##' | egrep -o "$1 \d+" | egrep -o '\d+'
  }

  __repository_status() {
    [ -x $(hash git 2>/dev/null) ] || return
    local -r git_en="env LANG=C git"
    local -r branch=$($git_en symbolic-ref --short HEAD 2>/dev/null || $git_en describe --tags --always 2>/dev/null)

    [ -n "$branch" ] || return
    local status_indicators="$clean_indicator"
    [ -n "$($git_en status --porcelain)" ] && status_indicators="$dirty_indicator"

    local -r staged_files=$(__num_files '^[A-Z]')
    [ $staged_files -gt 0 ] && status_indicators+=" $staged_indicator$staged_files"
    local -r unstaged_files=$(__num_files '^.[A-Z]')
    [ $unstaged_files -gt 0 ] && status_indicators+=" $unstaged_indicator$unstaged_files"
    local -r untracked_files=$(__num_files '^\?\?')
    [ $untracked_files -gt 0 ] && status_indicators+=" $untracked_indicator$untracked_files"

    local -r commits_ahead="$(__branch_status ahead)"
    [ -n "$commits_ahead" ] && status_indicators+=" $push_indicator$commits_ahead"
    local -r commits_behind="$(__branch_status behind)"
    [ -n "$commits_behind" ] && status_indicators+=" $pull_indicator$commits_behind"
    printf " $branch_indicator  $branch $status_indicators "
  }

  __exit_status() {
    printf "$1 $color_reset"
  }

  __ps1() {
    if [ $? -eq 0 ]; then
      PS1="$(__exit_status $color_bg_exit_zero)"
    else
      PS1="$(__exit_status $color_bg_exit_nonzero)"
    fi

    PS1+="$color_bg_base$color_fg_base \w $color_reset"
    PS1+="$color_bg_git$color_fg_base"
    # Description: https://github.com/njhartwell/pw3nage
    # Related fix in git-bash: https://github.com/git/git/blob/9d77b0405ce6b471cb5ce3a904368fc25e55643d/contrib/completion/git-prompt.sh#L324
    if shopt -q promptvars; then
      escaped_repository_status="$(__repository_status)"
      PS1+="\${escaped_repository_status}"
    else
      PS1+="$(__repository_status)"
    fi

    PS1+="$color_reset\n└─▪ "
  }

  PROMPT_COMMAND="__ps1; $PROMPT_COMMAND"
}

__powerline
unset __powerline
