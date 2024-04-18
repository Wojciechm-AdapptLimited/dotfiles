if (( ! $+commands[bat] )); then
  echo "bat not found. Please install bat from cargo"
  return 1
fi

alias cat='bat'

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
