#!/bin/bash

# SETUP PARAMETERS
app_name="home-config"
REPO_PATH="$HOME/.my-config"
REPO_URI="https://github.com/cirias/home-config.git"
REPO_BRANCH="master"

# BASIC SETUP TOOLS
msg() {
  printf '%b\n' "$1" >&2
}

success() {
  if [ "$ret" -eq '0' ]; then
    msg "\33[32m[✔]\33[0m ${1}${2}"
  fi
}

error() {
  msg "\33[31m[✘]\33[0m ${1}${2}"
  exit 1
}

program_exists() {
    local ret='0'
    command -v $1 >/dev/null 2>&1 || { local ret='1'; }

    # fail on non-zero return value
    if [ "$ret" -ne 0 ]; then
        return 1
    fi

    return 0
}

program_must_exist() {
    program_exists $1

    # throw error on non-zero return value
    if [ "$?" -ne 0 ]; then
        error "You must have '$1' installed to continue."
    fi
}

variable_set() {
    if [ -z "$1" ]; then
        error "You must have your HOME environmental variable set to continue."
    fi
}

lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
    ret="$?"
}

# SETUP FUNCTIONS
sync_repo() {
  local repo_path="$1"
  local repo_uri="$2"
  local repo_branch="$3"
  local repo_name="$4"

  msg "Trying to update $repo_name"

  if [ ! -e "$repo_path" ]; then
    mkdir -p "$repo_path"
    git clone -b "$repo_branch" "$repo_uri" "$repo_path"
    ret="$?"
    success "Successfully cloned $repo_name."
  else
    cd "$repo_path" && git pull origin "$repo_branch"
    ret="$?"
    success "Successfully updated $repo_name"
  fi
}

create_symlinks() {
  local source_path="$1"
  local target_path="$2"

  lnif "$source_path/.Xkbmap"              "$target_path/.Xkbmap"
  lnif "$source_path/.Xresources"          "$target_path/.Xresources"
  lnif "$source_path/.Xresources.d"        "$target_path/.Xresources.d"
  lnif "$source_path/.i3"                  "$target_path/.i3"
  lnif "$source_path/.i3status.conf"       "$target_path/.i3status.conf"
  lnif "$source_path/.vimrc.before.local"  "$target_path/.vimrc.before.local"
  lnif "$source_path/.vimrc.bundles.local" "$target_path/.vimrc.bundles.local"
  lnif "$source_path/.vimrc.local"         "$target_path/.vimrc.local"

  ret="$?"
  success "Setting up symlinks."
}

# MAIN()
variable_set "$HOME"
program_must_exist "git"

sync_repo "$REPO_PATH" \
          "$REPO_URI" \
          "$REPO_BRANCH" \
          "$app_name"

create_symlinks "$REPO_PATH" \
                "$HOME"

msg "\nDone!"
