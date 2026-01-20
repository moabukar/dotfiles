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
    
    # Link configs from config directory
    if [ -f "$dotfiles_dir/config/git/.gitconfig" ]; then
        backup_and_link "$dotfiles_dir/config/git/.gitconfig" "$HOME" "$backupdir"
        print_success "Git config linked"
    fi
    
    if [ -f "$dotfiles_dir/config/git/.gitignore_global" ]; then
        backup_and_link "$dotfiles_dir/config/git/.gitignore_global" "$HOME" "$backupdir"
    fi
    
    if [ -f "$dotfiles_dir/config/vim/.vimrc" ]; then
        backup_and_link "$dotfiles_dir/config/vim/.vimrc" "$HOME" "$backupdir"
        print_success "Vim config linked"
    fi
    
    if [ -f "$dotfiles_dir/config/tmux/.tmux.conf" ]; then
        backup_and_link "$dotfiles_dir/config/tmux/.tmux.conf" "$HOME" "$backupdir"
        print_success "Tmux config linked"
    fi
    
    if [ -f "$dotfiles_dir/config/ssh_config" ]; then
        mkdir -p "$HOME/.ssh"
        if [ -f "$HOME/.ssh/config" ]; then
            cp "$HOME/.ssh/config" "$backupdir/ssh_config.backup"
        fi
        ln -sf "$dotfiles_dir/config/ssh_config" "$HOME/.ssh/config"
        print_success "SSH config linked"
    fi
}

link_to_homedir