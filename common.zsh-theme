# vim: filetype=sh

# Prompt symbol
COMMON_PROMPT_SYMBOL="❯"

# Left Prompt
PROMPT='$(common_host)$(common_current_dir)$(common_bg_jobs)$(common_return_status)'

# Right Prompt
RPROMPT='$(common_git_status)'

# Host
common_host() {
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[green]%}$me%{$reset_color%}:"
  fi
  if [[ $AWS_VAULT ]]; then
    echo "%{$fg[yellow]%}$AWS_VAULT%{$reset_color%} "
  fi
}

# Current directory
common_current_dir() {
  echo -n "%{$fg_bold[blue]%}%3~ "
}

# Prompt symbol
common_return_status() {
  echo -n "%(?.%F{magenta}.%F{red})$COMMON_PROMPT_SYMBOL%f "
}

# Git status
common_git_status() {
    local message=""
    local message_color="%F{green}"

    local staged=$(git status --porcelain 2>/dev/null | grep -e "^M " -e "^A ")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^ M" -e "^??")

    if [[ -n ${staged} ]]; then
        message_color="%F{red}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%F{yellow}"
    fi

    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n ${branch} ]]; then
        message+="${message_color}${branch}%f"
    fi

    echo -n "${message}"
}

# Background Jobs
common_bg_jobs() {
  bg_status="%{$fg[yellow]%}%(1j.↓%j .)"
  echo -n $bg_status
}
