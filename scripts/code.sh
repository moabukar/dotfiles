#!/bin/bash

source $(dirname "${BASH_SOURCE[0]:-$0}")/util.sh

function setting_vscode() {
  print_notice "backup old setting.json..."

  local tmp_date
  tmp_date="$(date '+%y%m%d-%H%M%S')/vscode"

  local backupdir="$HOME/.backup/$tmp_date"
  mkdir_not_exist "$backupdir"
  print_info "create backup directory: $backupdir"

  print_info "Creating symlinks"
  local current_dir
  current_dir=$(dirname "${BASH_SOURCE[0]:-$0}")
  local root_dir
  root_dir="$(builtin cd "$current_dir" && git rev-parse --show-toplevel)"
  local vscode_dir="${HOME}/Library/Application Support/Code/User"

  # Link settings.json
  backup_and_link "${root_dir}/vscode/settings.json" "${vscode_dir}" "${backupdir}"

  # Install extensions using the code command
  if [ "$(which code)" != "" ]; then
    cat < "${root_dir}/vscode/extensions" | while read -r line
    do
      code --install-extension "$line"
    done
  else
    print_error "Install the code command from the command palette to add your extensions."
  fi
}

setting_vscode