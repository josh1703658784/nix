#!/usr/bin/env bash

#:echo has('clipboard') shellcheck enable=all
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
readonly ALLOW_BINS_ARR=(
  '/bin/cp'
  '/bin/rm'
  '/nix/store/*-coreutils-9.5/bin/env'
  '/nix/store/*-setup-homebrew'
  '/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util'
  '/usr/sbin/installer'
  '/Volumes/nix-homebrew/opt/homebrew/Caskroom/blockblock/*/BlockBlock\ Installer.app/Contents/MacOS/BlockBlock\ Installer'
  '/Volumes/nix-homebrew/opt/homebrew/Caskroom/reikey/*/ReiKey\ Installer.app/Contents/MacOS/ReiKey\ Installer'
)
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly NOCOLOR='\033[0m'  # reset colour attribues
ALLOW_BINS="$( echo "${ALLOW_BINS_ARR[@]}" | sed -e 's#\([^\]\) #\1,#g' )"; readonly ALLOW_BINS
REAL_DIRPATH="$( mktemp -d )"; 		              readonly REAL_DIRPATH
REAL_FILEPATH="${REAL_DIRPATH}/$( date +%s )";  readonly REAL_FILEPATH
THIS_SCRIPT="$( realpath "${0}" )";             readonly THIS_SCRIPT
readonly CONTENT="${TARGET_USER} ALL=(root) SETENV: ${ALLOW_BINS}"


function _log {
  echo -e "LOG | ${*}"
}

function info {
  _log "${BLUE}INFO:${NOCOLOR} ${*}"
}

function info_success {
  _log "${GREEN}INFO [SUCCESS]: ${*}${NOCOLOR}"
}


function error {
  _log "${RED}!!! ERROR: ${*}${NOCOLOR}"
}

function enforce_meta_perms {
  info 'fixing/setting permissions on this script'
  sudo chown "${RUN_AS_USER}:${RUN_AS_GROUP}" "${THIS_SCRIPT}"
  sudo chmod 740 "${THIS_SCRIPT}"
}

function cleanup {
  info 'removing elevated permissions'
  sudo rm -f "${TARGET_FILEPATH}" "${REAL_FILEPATH}"

  if [[ ! -f "${TARGET_FILEPATH}" ]]; then
    info_success "temporary sudoers symlink removed SUCCESSFULLY | ${TARGET_FILEPATH}"
  else
    error '*************************************'
    error "temporary sudoers symlink not removed from disk at ${TARGET_FILEPATH}"
    error 'address this issue ***IMMEDIATELY***'
    error "SEE PATH: ${TARGET_FILEPATH}"
    error '*************************************'
  fi
  if [[ ! -f "${REAL_FILEPATH}" ]]; then
    info_success "temporary sudoers file removed SUCCESSFULLY | ${REAL_FILEPATH}"
  else
    error '*************************************'
    error "temporary sudoers file not removed from disk at ${REAL_FILEPATH}"
    error 'address this issue ***IMMEDIATELY***'
    error "SEE PATH: ${REAL_FILEPATH}"
    error '*************************************'
  fi

  info 'VALIDATING (lack of) SUDO ACCESS'
  sudo -iu "${TARGET_USER}" bash -c '! sudo -v'
  local -r sudo_status="${?}"
  if [[ "${sudo_status}" ]]; then
    info_success "permissions removed, user '${TARGET_USER}' does not have sudo permissions"
  else
    error "!! user '${TARGET_USER}' still has sudo access"
    error '*************************************'
    error 'elevated permissions retained'
    error 'address this issue ***IMMEDIATELY***'
    error "SEE PATH: ${REAL_FILEPATH}"
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

function give_sudo {
  info 'giving elevated permissions to user'

  sudo sh -c "echo '${CONTENT}' > ${REAL_FILEPATH}"
  sudo ln -s "${REAL_FILEPATH}" "${TARGET_FILEPATH}"

  sudo chown -R root:wheel "${REAL_DIRPATH}"
  sudo chown    root:wheel "${TARGET_FILEPATH}"

  sudo chmod 400 "${REAL_FILEPATH}" "${TARGET_FILEPATH}"
}

function rebuild {
  info "AUTHing target user: ${TARGET_USER}"
  sudo -iu "${TARGET_USER}" bash -c 'sudo -v'

  info 'EXECUTING rebuild'
  sudo -iu "${TARGET_USER}" bash -c 'darwin-rebuild switch'
}

function main {
  trap cleanup EXIT
  enforce_meta_perms
  check_user
  give_sudo
  rebuild
}
main
