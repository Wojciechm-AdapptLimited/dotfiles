#
# directory: Set options and aliases related to Zsh directories and dirstack.
#

# Changing Directories
setopt auto_pushd         # Make cd push the old directory onto the dirstack.
setopt pushd_minus        # Exchanges meanings of +/- when navigating the dirstack.
setopt pushd_silent       # Do not print the directory stack after pushd or popd.
setopt pushd_to_home      # Push to home directory when no argument is given.

# Expansion and Globbing
setopt extended_glob      # Use more awesome globbing features.
setopt glob_dots          # Include dotfiles when globbing.

# Input/Output
setopt path_dirs          # Perform path search even on command names with slashes.
setopt NO_clobber         # Don't overwrite files with >. Use >| to bypass.
setopt NO_rm_star_silent  # Ask for confirmation for `rm *' or `rm path/*'

# Scripts and Functions
setopt multios        # Write to multiple descriptors.
