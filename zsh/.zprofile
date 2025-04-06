# Initialize hyprland environment
if (( $+commands[uwsm] )) && uwsm check may-start; then
  exec uwsm start hyprland.desktop
fi
