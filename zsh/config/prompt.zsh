#
# prompt: Setup Zsh prompt.
#

setopt prompt_subst       # Expand parameters in prompt variables.
setopt transient_rprompt  # Remove right prompt artifacts from prior commands.

function prompt_starship_setup {
  # When loaded through the prompt command, these prompt_* options will be enabled
  prompt_opts=(cr percent sp subst)

  if [[ -n "$1" ]]; then
    local -a configs=(
      $__zsh_config_dir/themes/$1.toml(N)
      ${XDG_CONFIG_HOME:-$HOME/.config}/starship/$1.toml(N)
    )
    (( $#configs )) && export STARSHIP_CONFIG=$configs[1]
  fi

  export STARSHIP_CONFIG=${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml

  # Initialize starship.
  if zstyle -t ':zsh:feature:prompt' 'use-cache'; then
    cached-eval 'starship-init-zsh' starship init zsh
  else
    source <(starship init zsh)
  fi
}

# Wrap promptinit.
function promptinit {
  # Initialize real built-in prompt system.
  unfunction promptinit
  autoload -Uz promptinit && promptinit

  # Hook starship into Zsh's prompt system.
  if (( $+commands[starship] )); then
    prompt_themes+=( starship )
  else
    unfunction prompt_starship_setup
  fi

  # Keep prompt array sorted.
  prompt_themes=( "${(@on)prompt_themes}" )
}
