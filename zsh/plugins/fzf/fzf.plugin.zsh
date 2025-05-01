# find $FZF_BASE
if [[ -z "${FZF_BASE}" ]]; then
    local fzfdirs=(
      "${HOME}/.fzf"
      "${HOME}/.nix-profile/share/fzf"
      "${XDG_DATA_HOME:-$HOME/.local/share}/fzf"
      "${MSYSTEM_PREFIX}/share/fzf"
      "/usr/local/opt/fzf"
      "/opt/homebrew/opt/fzf"
      "/usr/share/fzf"
      "/usr/local/share/examples/fzf"
    )
    for dir in ${fzfdirs}; do
      if [[ -d "${dir}" ]]; then
        export FZF_BASE="${dir}"
        break
      fi
    done

    if [[ ! -d "${FZF_BASE}" ]]; then
      return 1
    fi
  fi

# Fix fzf shell directory for Arch Linux, NixOS or Void Linux packages
local fzf_shell
if [[ ! -d "$FZF_BASE/shell" ]]; then
  fzf_shell=$FZF_BASE
else
  fzf_shell="$FZF_BASE/shell"
fi

# Auto-completion
if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
  source "${fzf_shell}/completion.zsh" 2> /dev/null
fi

# Key bindings
if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
  source "${fzf_shell}/key-bindings.zsh"
fi

# Underlying command
if [[ -z "$FZF_DEFAULT_COMMAND" ]]; then
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  elif (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
  elif (( $+commands[ag] )); then
    export FZF_DEFAULT_COMMAND='ag -l --hidden -g "" --ignore .git'
  else
    export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.*"'
  fi
fi

export FZF_COMPLETION_TRIGGER="**"

export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

export FZF_ALT_C_OPTS="--preview 'eza -lT --color=always {}'"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

bindkey "^E" fzf-cd-widget
