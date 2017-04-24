#!/usr/bin/env bash

__powerline_shell() {
  readonly __ps_branch_indicator='⎇'
  readonly __ps_clean_indicator='✓'
  readonly __ps_dirty_indicator='✗'
  readonly __ps_staged_indicator='+'
  readonly __ps_unstaged_indicator='-'
  readonly __ps_untracked_indicator='?'
  readonly __ps_stash_indicator='¢'
  readonly __ps_push_indicator='⇡'
  readonly __ps_pull_indicator='⇣'
  readonly __ps_color_fg_base="\[$(tput setaf 0)\]"
  readonly __ps_color_bg_base="\[$(tput setab 7)\]"
  readonly __ps_color_bg_exit_nonzero="\[$(tput setab 1)\]"
  readonly __ps_color_bg_exit_zero="\[$(tput setab 2)\]"
  readonly __ps_color_bg_git="\[$(tput setab 3)\]"
  readonly __ps_color_reset="\[$(tput sgr0)\]"

  repository_status() {
    [ -x $(hash git 2>/dev/null) ] || return
    local -r git_en="env LANG=C git"
    local -r branch=$($git_en symbolic-ref --short HEAD 2>/dev/null || $git_en describe --tags --always 2>/dev/null)

    [ -n "$branch" ] || return
    local status_indicators="$__ps_clean_indicator"
    [ -n "$($git_en status --porcelain)" ] && status_indicators="$__ps_dirty_indicator"

    num_status() {
      $git_en status --porcelain | egrep "$1" | wc -l | egrep -o '\d+'
    }

    local -r staged_files=$(num_status '^[A-Z]')
    [ $staged_files -gt 0 ] && status_indicators+=" $__ps_staged_indicator$staged_files"
    local -r unstaged_files=$(num_status '^.[A-Z]')
    [ $unstaged_files -gt 0 ] && status_indicators+=" $__ps_unstaged_indicator$unstaged_files"
    local -r untracked_files=$(num_status '^\?\?')
    [ $untracked_files -gt 0 ] && status_indicators+=" $__ps_untracked_indicator$untracked_files"

    num_stash_items() {
      $git_en stash list | wc -l | egrep -o '\d+'
    }

    local -r stash_items="$(num_stash_items)"
    [ $stash_items -gt 0 ] && status_indicators+=" $__ps_stash_indicator$stash_items"

    num_commit_diffs() {
      $git_en status --branch --porcelain | egrep '^##' | egrep -o "$1 \d+" | egrep -o '\d+'
    }

    local -r commits_ahead="$(num_commit_diffs ahead)"
    [ -n "$commits_ahead" ] && status_indicators+=" $__ps_push_indicator$commits_ahead"
    local -r commits_behind="$(num_commit_diffs behind)"
    [ -n "$commits_behind" ] && status_indicators+=" $__ps_pull_indicator$commits_behind"

    printf " $__ps_branch_indicator  $branch $status_indicators "
  }

  exit_status() {
    printf "$1 $__ps_color_reset"
  }

  ps1() {
    if [ $? -eq 0 ]; then
      PS1="$(exit_status $__ps_color_bg_exit_zero)"
    else
      PS1="$(exit_status $__ps_color_bg_exit_nonzero)"
    fi

    PS1+="$__ps_color_bg_base$__ps_color_fg_base \w $__ps_color_reset"
    PS1+="$__ps_color_bg_git$__ps_color_fg_base"
    # Description: https://github.com/njhartwell/pw3nage
    # Related fix in git-bash: https://github.com/git/git/blob/9d77b0405ce6b471cb5ce3a904368fc25e55643d/contrib/completion/git-prompt.sh#L324
    if shopt -q promptvars; then
      escaped_repository_status="$(repository_status)"
      PS1+="\${escaped_repository_status}"
    else
      PS1+="$(repository_status)"
    fi

    PS1+="$__ps_color_reset\n└─▪ "
  }

  PROMPT_COMMAND="ps1; $PROMPT_COMMAND"
}

__powerline_shell
unset __powerline_shell
