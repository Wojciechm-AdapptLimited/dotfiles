# fnm

export PATH="$PATH:$XDG_DATA_HOME/fnm"

if (( ?+command[_evalcache] )); then
  _evalcache fnm env
else
  eval "$(fnm env)"
fi
