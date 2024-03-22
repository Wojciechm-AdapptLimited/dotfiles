#
# __init__: Run this first!
#

# Initialize profiling.
[[ "$ZPROFRC" -ne 1 ]] || zmodload zsh/zprof
alias zprofrc="ZPROFRC=1 zsh"

# Set critical options
setopt extended_glob

# Set critical vars
: ${__zsh_config_dir:=${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}}
: ${__zsh_cache_dir:=${XDG_CACHE_HOME:-$HOME/.cache}/zsh}
: ${__zsh_user_data_dir:=${XDG_DATA_HOME:-$HOME/.local/share}/zsh}

# Define critical functions
##? Cache the results of an eval command
function cached-eval {
  emulate -L zsh; setopt local_options extended_glob
  (( $# >= 2 )) || return 1

  local cmdname=$1; shift
  local memofile=$__zsh_cache_dir/memoized/${cmdname}.zsh
  local -a cached=($memofile(Nmh-20))
  if ! (( ${#cached} )); then
    mkdir -p ${memofile:h}
    "$@" >| $memofile
  fi
  source $memofile
}

# Load .zstyles file.
[[ -r ${ZDOTDIR:-$HOME}/.zstyles ]] && source ${ZDOTDIR:-$HOME}/.zstyles

# Load .zshrc.pre file.
[[ -r ${ZDOTDIR:-$HOME}/.zshrc.pre ]] && source ${ZDOTDIR:-$HOME}/.zshrc.pre

# Init aliases.
[[ -r ${ZDOTDIR:-$HOME}/.zaliases ]] && source ${ZDOTDIR:-$HOME}/.zaliases

# Run local settings.
[[ -r ${ZDOTDIR:-$HOME}/.zshrc.local ]] && source ${ZDOTDIR:-$HOME}/.zshrc.local

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Setup homebrew if it exists on the system.
typeset -aU _brewcmd=(
  $HOME/.homebrew/bin/brew(N)
  $HOME/.linuxbrew/bin/brew(N)
  /opt/homebrew/bin/brew(N)
  /usr/local/bin/brew(N)
  /home/linuxbrew/.linuxbrew/bin/brew(N)
)
if (( $#_brewcmd )); then
  if zstyle -t ':zsh:feature:homebrew' 'use-cache'; then
    cached-eval 'brew_shellenv' $_brewcmd[1] shellenv
  else
    source <($_brewcmd[1] shellenv)
  fi
fi
unset _brewcmd

# Build remaining path.
path=(
  $HOME/{,s}bin(N)
  $HOME/.local/{,s}bin(N)
  /opt/homebrew/{,s}bin(N)
  /usr/local/{,s}bin(N)
  /usr/{,s}bin(N)
  /{,s}bin(N)
)

# macOS
if [[ "$OSTYPE" == darwin* ]]; then
  # Make Apple Terminal behave.
  export SHELL_SESSIONS_DISABLE=1
fi

# Enable less wait time between key presses.
export KEYTIMEOUT=1

# Run this at the very end.
function zshrc-post {
  # Initialize zellij.
  if (( $+commands[zellij] )); then
    eval "$(zellij setup --generate-auto-start zsh)"
  fi

  # Init bindings.
  bindkey '^[OA' history-substring-search-up
  bindkey '^[OB' history-substring-search-down

  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down

  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down

  HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

  # Init prompt.
  if ! (( $#prompt_themes > 0 )); then
    promptinit

    # Set prompt
    if [[ $TERM == dumb ]]; then
      prompt 'off'
    else
      # Set prompt.
      local -a prompt_argv
      zstyle -a ':zsh:feature:prompt' 'theme' 'prompt_argv'
      if (( $#prompt_argv == 0 )); then
        if (( $+commands[starship] )); then
          prompt_argv=(starship zephyr)
        else
          prompt_argv=(off)
        fi
      fi
      prompt "$prompt_argv[@]"
    fi
  fi

  # Finish profiling by calling zprof.
  [[ "$ZPROFRC" -eq 1 ]] && zprof
  [[ -v ZPROFRC ]] && unset ZPROFRC

  # Mark loaded.
  add-zsh-hook -d precmd zshrc-post
}
