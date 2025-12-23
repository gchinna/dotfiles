#!/usr/bin/env bash
set -euo pipefail

usage() {
	cat <<'EOF'
Usage: install.sh [--nobashrc] [--nozshrc] [--nocshrc] [--novimrc] [-h|--help]

Options:
	--nobashrc     Skip installing bashrc
	--nozshrc      Skip installing zshrc
	--nocshrc      Skip installing cshrc
	--novimrc      Skip installing vimrc
	--nogitignore  Skip installing gitignore
	--noctags      Skip installing ctags
	--force        Force overwriting existing *rc files.
	-d, --dryrun   Dry run mode; show what would be done without making changes.
	-h, --help     Show this help.

Notes:
	If no flags are provided the script installs all components (bashrc, zshrc, vimrc).
	If conflicting options are provided, the last one wins.
EOF
}


# dotfiles dir: $HOME/dotfiles
DOTFILES_DIR="$HOME/dotfiles"
# dotfiles list to install by default
DOTFILES_LIST=(.bashrc .zshrc .cshrc .vimrc .gitignore .ctags)
DRYRUN=false
FORCE=false


# helper to link if source exists
safe_link() {
    local src="$1"
    local dst="$2"
    if [[ ! -e "$src" ]]; then
        echo "ERROR: source missing: $src" >&2
        return 1
    fi
    ## create parent dir for dst if necessary
    # mkdir -p "$(dirname "$dst")"
    # TODO: prompt before overwriting existing dst?
    if [[ -e "$dst" ]]; then
        echo "WARNING: $dst file exists!"
        if [[ "$FORCE" != true ]]; then
            return 0
        fi
    fi
    if [[ "$DRYRUN" == true ]]; then
        echo "[DRYRUN] ln -sf \"$src\" \"$dst\""
        return 0
    fi
    ln -sf "$src" "$dst"
    echo "Linked: $dst -> $src"
}

# define remove_dotfile function after declaring DOTFILES_LIST
remove_dotfile() { 
    # dotfile to remove
    local dfile_to_remove="$1"
    
    # New array to store elements after removal
    local updated_list=()
    
    # Iterate through the original array
    for dfile in "${DOTFILES_LIST[@]}"; do
      # If the current element is not the value to remove, add it to the new array
      if [[ "$dfile" != "$dfile_to_remove" ]]; then
        updated_list+=("$dfile")
      fi
    done
    
    # Replace the original dotfiles list with the updated array
    DOTFILES_LIST=("${updated_list[@]}")
    
    # Print the updated array
    echo "Updated list: ${DOTFILES_LIST[@]}"
}


if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "ERROR: dotfiles directory $DOTFILES_DIR not found" >&2
    exit 1
fi

while [[ $# -gt 0 ]]; do
	case "$1" in
        -d|--dryrun)
            DRYRUN=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
		--nobashrc|--nobash)
			remove_dotfile ".bashrc"; shift ;;
		--nozshrc|--nozsh)
			remove_dotfile ".zshrc"; shift ;;
		--nocshrc|--nocsh)
			remove_dotfile ".cshrc"; shift ;;
		--novimrc|--novim)
			remove_dotfile ".vimrc"; shift ;;
		--nogitignore|--nogit)
			remove_dotfile ".gitignore"; shift ;;
		--noctags|--noct)
			remove_dotfile ".ctags"; shift ;;
		-h|--help)
			usage
			exit 0
			;;
		*)
			echo "ERROR: Unknown option: $1" >&2
			usage
			exit 2
			;;
	esac
done


# create symlinks for DOTFILES_LIST from DOTFILES_DIR to HOME
for dfile in "${DOTFILES_LIST[@]}"; do
    safe_link "$DOTFILES_DIR/$dfile" "$HOME/$dfile"
done

exit 0
