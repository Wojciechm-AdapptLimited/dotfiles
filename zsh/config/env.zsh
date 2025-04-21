#
# env: Ensure common environment variables are set.
#

 # Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export VISUAL='vim'
else
  export VISUAL='nvim'
fi

export EDITOR="$VISUAL"

if (( $+commands[most] )); then
  export PAGER=${PAGER:-most}
else
  export PAGER=${PAGER:-less}
fi

export LANG=${LANG:-en_US.UTF-8}

# Setup GPG
export GPG_TTY=$(tty)

# Setup GTK
export GTK_THEME=Adwaita:dark

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi
export LESS="${LESS:--g -i -M -R -S -w -z-4}"

# macOS
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER=${BROWSER:-open}
fi
