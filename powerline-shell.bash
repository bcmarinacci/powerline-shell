#!/usr/bin/env bash

__ps_main() {
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

  readonly git_en="env LANG=C git"
  readonly git_timeout=5

  __ps_repository_status() {
    type git > /dev/null 2>&1 || return

    local -r branch=$($git_en symbolic-ref --short HEAD 2>/dev/null || $git_en describe --tags --always 2>/dev/null)

    [[ -n "$branch" ]] || return

    local FETCH_HEAD="$1/.git/FETCH_HEAD"
    local matches=$("find" "$FETCH_HEAD" -mmin +"$git_timeout" 2> /dev/null)
    if [[ ! -e "$FETCH_HEAD" ]] || [[ -n "$matches" ]]
    then
      if [[ -n $(git remote show) ]]; then
        (
          {
              eval "git fetch --quiet" &> /dev/null
          }&
          disown -h
        )
      fi
    fi

    local -r git_status=$($git_en status --porcelain)
    if [[ -z "$git_status" ]]; then
      local status_indicators="$__ps_clean_indicator"
    else
      local status_indicators="$__ps_dirty_indicator"
    fi

    local -r staged_files=$(echo "$git_status" | egrep '^[A-Z]' | wc -l | egrep -o '\d+')
    [[ $staged_files -gt 0 ]] 2>/dev/null && status_indicators+=" $__ps_staged_indicator$staged_files"
    local -r unstaged_files=$(echo "$git_status" | egrep '^.[A-Z]' | wc -l | egrep -o '\d+')
    [[ $unstaged_files -gt 0 ]] 2>/dev/null && status_indicators+=" $__ps_unstaged_indicator$unstaged_files"
    local -r untracked_files=$(echo "$git_status" | egrep '^\?\?' | wc -l | egrep -o '\d+')
    [[ $untracked_files -gt 0 ]] 2>/dev/null && status_indicators+=" $__ps_untracked_indicator$untracked_files"
    local -r stash_items=$($git_en stash list | wc -l | egrep -o '\d+')
    [[ $stash_items -gt 0 ]] 2>/dev/null && status_indicators+=" $__ps_stash_indicator$stash_items"
    local -r git_status_branch=$($git_en status --porcelain --branch)
    local -r commits_ahead=$(echo "$git_status_branch" | egrep '^##' | egrep -o 'ahead \d+' | egrep -o '\d+')
    [[ -n "$commits_ahead" ]] && status_indicators+=" $__ps_push_indicator$commits_ahead"
    local -r commits_behind=$(echo "$git_status_branch" | egrep '^##' | egrep -o 'behind \d+' | egrep -o '\d+')
    [[ -n "$commits_behind" ]] && status_indicators+=" $__ps_pull_indicator$commits_behind"

    printf " $__ps_branch_indicator  $branch $status_indicators "
  }

  __ps_ps1() {
    if [[ $? -eq 0 ]]; then
      PS1="$__ps_color_bg_exit_zero "
    else
      PS1="$__ps_color_bg_exit_nonzero "
    fi

    PS1+="$__ps_color_reset$__ps_color_bg_base$__ps_color_fg_base "

    local -r prefix=$($git_en rev-parse --show-prefix 2>/dev/null)
    local -r toplevel=$($git_en rev-parse --show-toplevel 2>/dev/null)
    local -r git_dir=$($git_en rev-parse --git-dir 2>/dev/null)
    if [[ -n "$prefix" ]]; then
      PS1+="$(basename $toplevel)/${prefix%/}"
    elif [[ -d "$git_dir" && "$toplevel" = "$(pwd)" ]]; then
      PS1+="\W"
    else
      PS1+="\w"
    fi

    PS1+=" $__ps_color_reset$__ps_color_bg_git$__ps_color_fg_base"

    # Description: https://github.com/njhartwell/pw3nage
    # Related fix in git-bash: https://github.com/git/git/blob/9d77b0405ce6b471cb5ce3a904368fc25e55643d/contrib/completion/git-prompt.sh#L324
    if shopt -q promptvars; then
      escaped_repository_status="$(__ps_repository_status $toplevel)"
      PS1+="\${escaped_repository_status}"
    else
      PS1+="$(__ps_repository_status $toplevel)"
    fi

    PS1+="$__ps_color_reset\n↳ "
  }

  PROMPT_COMMAND="__ps_ps1; $PROMPT_COMMAND"
}

__ps_main
