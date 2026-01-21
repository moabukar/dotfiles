#!/bin/bash

function print_info() {
	printf "\033[1;36m%s\033[m\n" "$*" # cyan
}

function print_notice() {
	printf "\033[1;35m%s\033[m\n" "$*" # magenta
}

function print_success() {
	printf "\033[1;32m%s\033[m\n" "$*" # green
}

function print_warning() {
	printf "\033[1;33m%s\033[m\n" "$*" # yellow
}

function print_error() {
	printf "\033[1;31m%s\033[m\n" "$*" # red
}

function print_debug() {
	printf "\033[1;34m%s\033[m\n" "$*" # blue
}

function mkdir_not_exist() {
	if [ ! -d "$1" ]; then
		mkdir -p "$1"
	fi
}

function check_macos() {
	if [ "$(uname)" != "Darwin" ] ; then
		print_error "Not macOS!"
		exit 1
	fi
}

function check_command() {
	if ! command -v "$1" >/dev/null 2>&1; then
		print_error "$1 command not found!"
		exit 1
	fi
}

function backup_and_link() {
	local link_src_file=$1
	local link_dest_dir=$2
	local backupdir=$3
	local f_filename

	f_filename=$(basename "$link_src_file")
	local f_filepath="$link_dest_dir/$f_filename"

	# Delete if already exists as a symbolic link
	if [[ -L "$f_filepath" ]]; then
		command rm -f "$f_filepath"
	fi

	# Backup if it is a real file, not a symbolic link
	if [[ -e "$f_filepath" && ! -L "$f_filepath" ]]; then
		command mv "$f_filepath" "$backupdir"
	fi

	echo "Creating symlink for $link_src_file -> $link_dest_dir"
	command ln -snf "$link_src_file" "$link_dest_dir"
}
