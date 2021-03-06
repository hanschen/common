#------------------------------------------------------------------------------
# Functions
#------------------------------------------------------------------------------

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
    local message_color="%{$fg_bold[blue]%}"

    local staged=$(git status --porcelain 2>/dev/null | grep -e "^M " -e "^A ")
    local unstaged=$(git status --porcelain 2>/dev/null | grep -e "^ M" -e "^??")

    if [[ -n ${staged} ]]; then
        message_color="%{$fg_bold[red]%}"
    elif [[ -n ${unstaged} ]]; then
        message_color="%{$fg_bold[yellow]%}"
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

#------------------------------------------------------------------------------
# Options
#------------------------------------------------------------------------------

# Prompt symbol
COMMON_PROMPT_SYMBOL="$"

# Vi indicator
MODE_INDICATOR="%{$fg_bold[magenta]%}-- NORMAL -- %{$reset_color%}"

# Left Prompt
PROMPT='$(common_host)$(common_current_dir)$(common_bg_jobs)$(common_return_status)'

# Right Prompt
RPROMPT=""
function zle-line-init zle-keymap-select {
RPS1="${${KEYMAP/vicmd/${MODE_INDICATOR}}/(main|viins)/} $(common_git_status)"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# vim: filetype=sh
