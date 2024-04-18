function fzf_setup_using_base_dir() {
  local fzf_base fzf_shell fzfdirs dir

  test -d "${FZF_BASE}" && fzf_base="${FZF_BASE}"

  if [[ -z "${fzf_base}" ]]; then
    fzfdirs=(
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
        fzf_base="${dir}"
        break
      fi
    done

    if [[ -z "${fzf_base}" ]]; then
      if (( ${+commands[fzf-share]} )) && dir="$(fzf-share)" && [[ -d "${dir}" ]]; then
        fzf_base="${dir}"
      elif (( ${+commands[brew]} )) && dir="$(brew --prefix fzf 2>/dev/null)"; then
        if [[ -d "${dir}" ]]; then
          fzf_base="${dir}"
        fi
      fi
    fi
  fi

  if [[ ! -d "${fzf_base}" ]]; then
    return 1
  fi

  # Fix fzf shell directory for Arch Linux, NixOS or Void Linux packages
  if [[ ! -d "${fzf_base}/shell" ]]; then
    fzf_shell="${fzf_base}"
  else
    fzf_shell="${fzf_base}/shell"
  fi

  # Setup fzf binary path
  if (( ! ${+commands[fzf]} )) && [[ "$PATH" != *$fzf_base/bin* ]]; then
    export PATH="$PATH:$fzf_base/bin"
  fi

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source "${fzf_shell}/completion.zsh" 2> /dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
    source "${fzf_shell}/key-bindings.zsh"
  fi
}


function fzf_setup_using_debian() {
  if (( ! $+commands[apt] && ! $+commands[apt-get] )); then
    # Not a debian based distro 
    return 1
  fi

  # NOTE: There is no need to configure PATH for debian package, all binaries
  # are installed to /usr/bin by default

  local completions key_bindings

  case $PREFIX in
    *com.termux*)
      if [[ ! -f "${PREFIX}/bin/fzf" ]]; then
        # fzf not installed
        return 1
      fi
      # Support Termux package
      completions="${PREFIX}/share/fzf/completion.zsh"
      key_bindings="${PREFIX}/share/fzf/key-bindings.zsh"
      ;;
    *)
      if [[ ! -d /usr/share/doc/fzf/examples ]]; then
        # fzf not installed
        return 1
      fi
      # Determine completion file path: first bullseye/sid, then buster/stretch
      completions="/usr/share/doc/fzf/examples/completion.zsh"
      [[ -f "$completions" ]] || completions="/usr/share/zsh/vendor-completions/_fzf"
      key_bindings="/usr/share/doc/fzf/examples/key-bindings.zsh"
      ;;
  esac

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source $completions 2> /dev/null
  fi

  # Key bindings
  if [[ ! "$DISABLE_FZF_KEY_BINDINGS" == "true" ]]; then
    source $key_bindings
  fi

  return 0
}

function fzf_setup_using_opensuse() {
  # OpenSUSE installs fzf in /usr/bin/fzf
  # If the command is not found, the package isn't installed
  (( $+commands[fzf] )) || return 1

  # The fzf-zsh-completion package installs the auto-completion in
  local completions="/usr/share/zsh/site-functions/_fzf"
  # The fzf-zsh-completion package installs the key-bindings file in
  local key_bindings="/etc/zsh_completion.d/fzf-key-bindings"

  # If these are not found: (1) maybe we're not on OpenSUSE, or
  # (2) maybe the fzf-zsh-completion package isn't installed.
  if [[ ! -f "$completions" || ! -f "$key_bindings" ]]; then
    return 1
  fi

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source "$completions" 2>/dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
    source "$key_bindings" 2>/dev/null
  fi

  return 0
}

function fzf_setup_using_openbsd() {
  # openBSD installs fzf in /usr/local/bin/fzf
  if [[ "$OSTYPE" != openbsd* ]] || (( ! $+commands[fzf] )); then
    return 1
  fi

  # The fzf package installs the auto-completion in
  local completions="/usr/local/share/zsh/site-functions/_fzf_completion"
  # The fzf package installs the key-bindings file in
  local key_bindings="/usr/local/share/zsh/site-functions/_fzf_key_bindings"

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source "$completions" 2>/dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
    source "$key_bindings" 2>/dev/null
  fi

  return 0
}

function fzf_setup_using_cygwin() {
  # Cygwin installs fzf in /usr/local/bin/fzf
  if [[ "$OSTYPE" != cygwin* ]] || (( ! $+commands[fzf] )); then
    return 1
  fi

  # The fzf-zsh-completion package installs the auto-completion in
  local completions="/etc/profile.d/fzf-completion.zsh"
  # The fzf-zsh package installs the key-bindings file in
  local key_bindings="/etc/profile.d/fzf.zsh"

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source "$completions" 2>/dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
    source "$key_bindings" 2>/dev/null
  fi

  return 0
}

function fzf_setup_using_macports() {
  # If the command is not found, the package isn't installed
  (( $+commands[fzf] )) || return 1

  # The fzf-zsh-completion package installs the auto-completion in
  local completions="/opt/local/share/fzf/shell/completion.zsh"
  # The fzf-zsh-completion package installs the key-bindings file in
  local key_bindings="/opt/local/share/fzf/shell/key-bindings.zsh"

  if [[ ! -f "$completions" || ! -f "$key_bindings" ]]; then
    return 1
  fi

  # Auto-completion
  if [[ -o interactive && "$DISABLE_FZF_AUTO_COMPLETION" != "true" ]]; then
    source "$completions" 2>/dev/null
  fi

  # Key bindings
  if [[ "$DISABLE_FZF_KEY_BINDINGS" != "true" ]]; then
    source "$key_bindings" 2>/dev/null
  fi

  return 0
}

# Indicate to user that fzf installation not found if nothing worked
function fzf_setup_error() {
  cat >&2 <<'EOF'
[oh-my-zsh] fzf plugin: Cannot find fzf installation directory.
Please add `export FZF_BASE=/path/to/fzf/install/dir` to your .zshrc
EOF
}

fzf_setup_using_openbsd \
  || fzf_setup_using_debian \
  || fzf_setup_using_opensuse \
  || fzf_setup_using_cygwin \
  || fzf_setup_using_macports \
  || fzf_setup_using_base_dir \
  || fzf_setup_error

unset -f -m 'fzf_setup_*'

if [[ -z "$FZF_DEFAULT_COMMAND" ]]; then
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  elif (( $+commands[rg] )); then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
  elif (( $+commands[ag] )); then
    export FZF_DEFAULT_COMMAND='ag -l --hidden -g "" --ignore .git'
  fi
fi

if [[ $# -eq 1 ]]; then
  branches() {
    git branch "$@" --sort=-committerdate --sort=-HEAD --format=$'%(HEAD) %(color:yellow)%(refname:short) %(color:green)(%(committerdate:relative))\t%(color:blue)%(subject)%(color:reset)' --color=always | column -ts$'\t'
  }
  refs() {
    git for-each-ref --sort=-creatordate --sort=-HEAD --color=always --format=$'%(refname) %(color:green)(%(creatordate:relative))\t%(color:blue)%(subject)%(color:reset)' |
      eval "$1" |
      sed 's#^refs/remotes/#\x1b[95mremote-branch\t\x1b[33m#; s#^refs/heads/#\x1b[92mbranch\t\x1b[33m#; s#^refs/tags/#\x1b[96mtag\t\x1b[33m#; s#refs/stash#\x1b[91mstash\t\x1b[33mrefs/stash#' |
      column -ts$'\t'
  }
  case "$1" in
    branches)
      echo $'CTRL-O (open in browser) ╱ ALT-A (show all branches)\n'
      branches
      ;;
    all-branches)
      echo $'CTRL-O (open in browser)\n'
      branches -a
      ;;
    refs)
      echo $'CTRL-O (open in browser) ╱ ALT-E (examine in editor) ╱ ALT-A (show all refs)\n'
      refs 'grep -v ^refs/remotes'
      ;;
    all-refs)
      echo $'CTRL-O (open in browser) ╱ ALT-E (examine in editor)\n'
      refs 'cat'
      ;;
    nobeep) ;;
    *) exit 1 ;;
  esac
elif [[ $# -gt 1 ]]; then
  set -e

  branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ $branch = HEAD ]]; then
    branch=$(git describe --exact-match --tags 2> /dev/null || git rev-parse --short HEAD)
  fi

  # Only supports GitHub for now
  case "$1" in
    commit)
      hash=$(grep -o "[a-f0-9]\{7,\}" <<< "$2")
      path=/commit/$hash
      ;;
    branch|remote-branch)
      branch=$(sed 's/^[* ]*//' <<< "$2" | cut -d' ' -f1)
      remote=$(git config branch."${branch}".remote || echo 'origin')
      branch=${branch#$remote/}
      path=/tree/$branch
      ;;
    remote)
      remote=$2
      path=/tree/$branch
      ;;
    file) path=/blob/$branch/$(git rev-parse --show-prefix)$2 ;;
    tag)  path=/releases/tag/$2 ;;
    *)    exit 1 ;;
  esac

  remote=${remote:-$(git config branch."${branch}".remote || echo 'origin')}
  remote_url=$(git remote get-url "$remote" 2> /dev/null || echo "$remote")

  if [[ $remote_url =~ ^git@ ]]; then
    url=${remote_url%.git}
    url=${url#git@}
    url=https://${url/://}
  elif [[ $remote_url =~ ^http ]]; then
    url=${remote_url%.git}
  fi

  case "$(uname -s)" in
    Darwin) open "$url$path"     ;;
    *)      xdg-open "$url$path" ;;
  esac
  exit 0
fi

if [[ $- =~ i ]]; then
# -----------------------------------------------------------------------------

# Redefine this function to change the options
_fzf_git_fzf() {
  fzf-tmux -p80%,60% -- \
    --layout=reverse --multi --height=50% --min-height=20 --border \
    --border-label-pos=2 \
    --color='header:italic:underline,label:blue' \
    --preview-window='right,50%,border-left' \
    --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
}

_fzf_git_check() {
  git rev-parse HEAD > /dev/null 2>&1 && return

  [[ -n $TMUX ]] && tmux display-message "Not in a git repository"
  return 1
}

__fzf_git=${BASH_SOURCE[0]:-${(%):-%x}}
__fzf_git=$(readlink -f "$__fzf_git" 2> /dev/null || /usr/bin/ruby --disable-gems -e 'puts File.expand_path(ARGV.first)' "$__fzf_git" 2> /dev/null)

if [[ -z $_fzf_git_cat ]]; then
  # Sometimes bat is installed as batcat
  export _fzf_git_cat="cat"
  _fzf_git_bat_options="--style='${BAT_STYLE:-full}' --color=always --pager=never"
  if command -v batcat > /dev/null; then
    _fzf_git_cat="batcat $_fzf_git_bat_options"
  elif command -v bat > /dev/null; then
    _fzf_git_cat="bat $_fzf_git_bat_options"
  fi
fi

_fzf_git_files() {
  _fzf_git_check || return
  (git -c color.status=always status --short --no-branch
   git ls-files | grep -vxFf <(git status -s | grep '^[^?]' | cut -c4-; echo :) | sed 's/^/   /') |
  _fzf_git_fzf -m --ansi --nth 2..,.. \
    --border-label '📁 Files' \
    --header $'CTRL-O (open in browser) ╱ ALT-E (open in editor)\n\n' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git file {-1}" \
    --bind "alt-e:execute:${EDITOR:-vim} {-1} > /dev/tty" \
    --preview "git diff --no-ext-diff --color=always -- {-1} | sed 1,4d; $_fzf_git_cat {-1}" "$@" |
  cut -c4- | sed 's/.* -> //'
}

_fzf_git_branches() {
  _fzf_git_check || return
  bash "$__fzf_git" branches |
  _fzf_git_fzf --ansi \
    --border-label '🌲 Branches' \
    --header-lines 2 \
    --tiebreak begin \
    --preview-window down,border-top,40% \
    --color hl:underline,hl+:underline \
    --no-hscroll \
    --bind 'ctrl-/:change-preview-window(down,70%|hidden|)' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git branch {}" \
    --bind "alt-a:change-prompt(🌳 All branches> )+reload:bash \"$__fzf_git\" all-branches" \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' "$@" |
  sed 's/^..//' | cut -d' ' -f1
}

_fzf_git_tags() {
  _fzf_git_check || return
  git tag --sort -version:refname |
  _fzf_git_fzf --preview-window right,70% \
    --border-label '📛 Tags' \
    --header $'CTRL-O (open in browser)\n\n' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git tag {}" \
    --preview 'git show --color=always {}' "$@"
}

_fzf_git_hashes() {
  _fzf_git_check || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  _fzf_git_fzf --ansi --no-sort --bind 'ctrl-s:toggle-sort' \
    --border-label '🍡 Hashes' \
    --header $'CTRL-O (open in browser) ╱ CTRL-D (diff) ╱ CTRL-S (toggle sort)\n\n' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git commit {}" \
    --bind 'ctrl-d:execute:grep -o "[a-f0-9]\{7,\}" <<< {} | head -n 1 | xargs git diff > /dev/tty' \
    --color hl:underline,hl+:underline \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | head -n 1 | xargs git show --color=always' "$@" |
  awk 'match($0, /[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]*/) { print substr($0, RSTART, RLENGTH) }'
}

_fzf_git_remotes() {
  _fzf_git_check || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  _fzf_git_fzf --tac \
    --border-label '📡 Remotes' \
    --header $'CTRL-O (open in browser)\n\n' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git remote {1}" \
    --preview-window right,70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {1}/"$(git rev-parse --abbrev-ref HEAD)"' "$@" |
  cut -d$'\t' -f1
}

_fzf_git_stashes() {
  _fzf_git_check || return
  git stash list | _fzf_git_fzf \
    --border-label '🥡 Stashes' \
    --header $'CTRL-X (drop stash)\n\n' \
    --bind 'ctrl-x:execute-silent(git stash drop {1})+reload(git stash list)' \
    -d: --preview 'git show --color=always {1}' "$@" |
  cut -d: -f1
}

_fzf_git_lreflogs() {
  _fzf_git_check || return
  git reflog --color=always --format="%C(blue)%gD %C(yellow)%h%C(auto)%d %gs" | _fzf_git_fzf --ansi \
    --border-label '📒 Reflogs' \
    --preview 'git show --color=always {1}' "$@" |
  awk '{print $1}'
}

_fzf_git_each_ref() {
  _fzf_git_check || return
  bash "$__fzf_git" refs | _fzf_git_fzf --ansi \
    --nth 2,2.. \
    --tiebreak begin \
    --border-label '☘️  Each ref' \
    --header-lines 2 \
    --preview-window down,border-top,40% \
    --color hl:underline,hl+:underline \
    --no-hscroll \
    --bind 'ctrl-/:change-preview-window(down,70%|hidden|)' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git {1} {2}" \
    --bind "alt-e:execute:${EDITOR:-vim} <(git show {2}) > /dev/tty" \
    --bind "alt-a:change-prompt(🍀 Every ref> )+reload:bash \"$__fzf_git\" all-refs" \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {2}' "$@" |
  awk '{print $2}'
}

if [[ -n "${BASH_VERSION:-}" ]]; then
  __fzf_git_init() {
    bind '"\er": redraw-current-line'
    local o
    for o in "$@"; do
      bind '"\C-g\C-'${o:0:1}'": "`_fzf_git_'$o'`\e\C-e\er"'
      bind '"\C-g'${o:0:1}'": "`_fzf_git_'$o'`\e\C-e\er"'
    done
  }
elif [[ -n "${ZSH_VERSION:-}" ]]; then
  __fzf_git_join() {
    local item
    while read item; do
      echo -n "${(q)item} "
    done
  }

  __fzf_git_init() {
    local o
    for o in "$@"; do
      eval "fzf-git-$o-widget() { local result=\$(_fzf_git_$o | __fzf_git_join); zle reset-prompt; LBUFFER+=\$result }"
      eval "zle -N fzf-git-$o-widget"
      eval "bindkey '^g^${o[1]}' fzf-git-$o-widget"
      eval "bindkey '^g${o[1]}' fzf-git-$o-widget"
    done
  }
fi
__fzf_git_init files branches tags remotes hashes stashes lreflogs each_ref

# -----------------------------------------------------------------------------
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

export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
