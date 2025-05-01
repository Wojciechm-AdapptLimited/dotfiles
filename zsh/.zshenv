#!/bin/zsh
#
# .zshenv: Zsh environment file, loaded always.
#

export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_LIB_HOME=${XDG_LIB_HOME:-$HOME/.local/lib}

if [[ "$OSTYPE" != darwin* ]]; then
  export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
fi

export XDG_PROJECTS_HOME=${XDG_PROJECTS_HOME:-$HOME/Projects}
export XDG_AREAS_HOME=${XDG_AREAS_HOME:-$HOME/Areas}
export XDG_ARCHIVE_HOME=${XDG_ARCHIVE_HOME:-$HOME/Archive}
export XDG_MUSIC_HOME=${XDG_MUSIC_HOME:-$HOME/Music}

# Fish-like dirs
: ${__zsh_config_dir:=${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}}
: ${__zsh_user_data_dir:=${XDG_DATA_HOME:-$HOME/.local/share}/zsh}
: ${__zsh_cache_dir:=${XDG_CACHE_HOME:-$HOME/.cache}/zsh}

# Ensure Zsh directories exist.
() {
  local zdir
  for zdir in $@; do
    [[ -d "${(P)zdir}" ]] || mkdir -p -- "${(P)zdir}"
  done
} __zsh_{config,user_data,cache}_dir XDG_{CONFIG,CACHE,DATA,STATE,LIB,PROJECTS,AREAS,ARCHIVE}_HOME # XDG_RUNTIME_DIR
