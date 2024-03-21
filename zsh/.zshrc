#!/bin/zsh
#
# .zshrc - Run on interactive Zsh session.
#

# Load all configs.
for _zrc in $ZDOTDIR/config/*.zsh; source $_zrc; unset _zrc

zshrc-post
