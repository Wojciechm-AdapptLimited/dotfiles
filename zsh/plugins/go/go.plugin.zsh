export GOENV_ROOT=$XDG_DATA_HOME/goenv

eval "$(goenv init -)"

export GOPATH=$XDG_DATA_HOME/go
export GOMODCACHE=$XDG_CACHE_HOME/go/pkg/mod
export PATH=$PATH:$GOPATH/bin
