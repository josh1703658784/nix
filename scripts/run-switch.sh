#!/usr/bin/env bash

SCRIPT_DIR="$( dirname "$(realpath "${0}")" )"; readonly SCRIPT_DIR

function _log {
  echo "LOG | ${*}"
}

function info {
  _log "INFO: ${*}"
}

clear
info "AUTHing user with sudo: $(whoami)"
sudo -v
"${SCRIPT_DIR}/switch.sh"
