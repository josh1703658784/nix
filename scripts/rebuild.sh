#!/usr/bin/env bash



set -T # inherit DEBUG and RETURN trap for functions
set -C # prevent file overwrite by > &> <>
set -E # inherit -e
set -e # exit immediately on errors
set -u # exit on not assigned variables
set -o pipefail # exit on pipe failure
set -f # fully disable globbing, can be disabled as needed
# shopt -s failglob # fail when globbing fails
#set -x

readonly TARGET_DIRPATH='/private/etc/sudoers.d'
readonly TARGET_FILENAME='temp-grant-nixos-rebuild'
readonly TARGET_FILEPATH="${TARGET_DIRPATH}/${TARGET_FILENAME}"
readonly RUN_AS_USER='admin'
readonly RUN_AS_GROUP='staff'
readonly TARGET_USER='josh'
#readonly CONTENT="${TARGET_USER} ALL=(root) ALL"
readonly ALLOW_BIN_0='/nix/store/*-coreutils-9.5/bin/env'
readonly ALLOW_BIN_1='/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util'
readonly CONTENT="${TARGET_USER} ALL=(root) ${ALLOW_BIN_0},${ALLOW_BIN_1}"

THIS_SCRIPT="$( realpath "${0}" )"; readonly THIS_SCRIPT
NOW="$(date +%s)"; readonly NOW


function _log {
  echo "LOG | ${@}"
}

function info {
  _log "INFO: ${@}"
}

function error {
  _log "ERROR: ${@}"
}

function enforce_meta_perms {
  info 'fixing/setting permissions on this script'
  sudo chown "${RUN_AS_USER}:${RUN_AS_GROUP}" "${THIS_SCRIPT}"
  sudo chmod 700 "${THIS_SCRIPT}"
}

function cleanup {
  info 'removing elevated permissions'
  if [[ -f "${TARGET_FILEPATH}" ]]; then
    sudo rm "${TARGET_FILEPATH}"
  fi

  if [[ ! -f "${TARGET_FILEPATH}" ]]; then
    info 'permissions removed SUCCESSFULLY'
  else
    error '*************************************'
    error 'elevated permissions retained'
    error 'address this issue ***IMMEDIATELY***'
    error "SEE PATH: ${TARGET_FILEPATH}"
    error '*************************************'
  fi
 }

function check_user {
  info "checking correct user (${RUN_AS_USER}) is logged in"
  if [[ "$(whoami)" != "${RUN_AS_USER}" ]]; then
    error "must be ran as '${RUN_AS_USER}' user"
    error 'ERROR: exiting immediately'
    exit 1
  fi
}

function rebuild {
  info 'giving elevated permissions to user'
  sudo sh -c "echo '${CONTENT}' > ${TARGET_FILEPATH}"

  info "AUTHing target user: ${TARGET_USER}"
  sudo -iu "${TARGET_USER}" bash -c 'sudo -v'

  info 'EXECUTING rebuild'
  #sudo -iu "${TARGET_USER}" bash -c 'darwin-rebuild switch -I darwin="~/.nix-defexpr/channels/darwin"'
  sudo -iu "${TARGET_USER}" bash -c 'darwin-rebuild switch'

  #sudo -iu "${TARGET_USER}" bash -c 'export NIX_PATH='"${NIX_PATH}:${HOME}/.nix-defexpr/channels"'; darwin-rebuild switch'
}

function main {
  trap cleanup EXIT
  enforce_meta_perms
  check_user
  rebuild
}
main
