if ((! $+commands[zellij])); then
  echo "zellij not found. Please install zellij using your package manager."
  return 1
fi

named=(nvim nvtop)

zellij_pane_name_update() {
  if [[ -z $ZELLIJ ]]; then
    return 0
  fi

  local pane_name=''
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    pane_name+=$(basename "$(git rev-parse --show-toplevel)")/
    pane_name+=$(git rev-parse --show-prefix)
    pane_name=${pane_name%/}
  else
    pane_name=$PWD
    if [[ $pane_name == $HOME ]]; then
      pane_name="~"
    else
      pane_name=${pane_name##*/}
    fi
  fi

  command nohup zellij action rename-pane $pane_name >/dev/null 2>&1
}

zellij_tab_name_update() {
  local tab_name="zsh"

  if [[ -n $1 ]]; then
    local command=$(echo $1 | awk '{print $1}')

    if (( $named[(I)$command] )); then
      tab_name=$command
    fi
  fi

  command nohup zellij action rename-tab $tab_name >/dev/null 2>&1
}

zellij_tab_name_reset() {
  command nohup zellij action rename-tab zsh > /dev/null 2>&1
}

zellij_tab_name_reset
zellij_pane_name_update
chpwd_functions+=(zellij_pane_name_update)
preexec_functions+=(zellij_tab_name_update)
precmd_functions+=(zellij_tab_name_reset)
