#!/bin/bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/util.sh

function link_to_homedir() {
    # make backup directory
    print_notice "backup old dotfiles..."

    local tmp_date
    tmp_date=$(date '+%y%m%d-%H%M%S')

    local backupdir="$HOME/.backup/$tmp_date"
    mkdir_not_exist "$backupdir"
    print_info "create backup directory: $backupdir"

    print_info "Creating symlinks"
    local current_dir
	current_dir=$(dirname "${BASH_SOURCE[0]:-$0}")
	local dotfiles_dir
	dotfiles_dir="$(builtin cd "$current_dir" && git rev-parse --show-toplevel)"

    # Load excluded files
    linkignore=()
    if [[ -e "$dotfiles_dir/.linkignore" ]]; then
        while IFS= read -r line; do
            linkignore+=("$line")
        done <"$dotfiles_dir/.linkignore"
    fi

    # make symbolic links
    for f in "$dotfiles_dir"/.??*; do
        local f_filename
        f_filename=$(basename "$f")

        # if excluded file, skip
        [[ ${linkignore[*]} =~ $f_filename ]] && continue

        # .aws make the subordinate config a symbolic link
        if [ "$f_filename" = ".aws" ]; then
            for config in "$f"/*; do
                local config_filename
                config_filename=$(basename "$config")

                # if excluded file, skip
                [[ ${linkignore[*]} =~ $config_filename ]] && continue

                backup_and_link "$config" "$HOME/.aws" "$backupdir"
            done
            continue
        fi

        # .config makes the directory under it a symbolic link
        if [ "$f_filename" = ".config" ]; then
            for config in "$f"/*; do
                local config_filename
                config_filename=$(basename "$config")

                # if excluded file, skip
                [[ ${linkignore[*]} =~ $config_filename ]] && continue

                backup_and_link "$config" "$HOME/.config" "$backupdir"
            done
            continue
        fi

        # Create a symbolic link to the home directory as is otherwise
        backup_and_link "$f" "$HOME" "$backupdir"
    done
}

link_to_homedir