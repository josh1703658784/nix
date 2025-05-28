#!/usr/bin/env bash
(
  set -T # inherit DEBUG and RETURN trap for functions
  set -C # prevent file overwrite by > &> <>
  set -e # exit immediately on errors
  set -u # exit on not assigned variables
  set -o pipefail # exit on pipe failure
  #set -f # fully disable globbing, can be disabled as needed
  shopt -s failglob # fail when globbing fails
  #set -x

  # Set up applications.
  readonly SRC_DIRPATH='/Applications/Nix Apps'
  readonly DST_DIRPATH='/Applications/Nix Apps [Aliases]'

  echo 'setting up /Applications...' >&2
  mkdir -p "${DST_DIRPATH}"
  rm -rf "${DST_DIRPATH}/"*

  if [[ -d "${SRC_DIRPATH}" ]]; then
    find "${SRC_DIRPATH}" -maxdepth 1 -type l -exec readlink '{}' + |
    while read -r SRC; do
      APP_NAME="$(basename "${SRC}")"; #readonly APP_NAME
      echo "creating alias from ''${SRC}" >&2
      ${pkgs.mkalias}/bin/mkalias "${SRC}" "${DST_DIRPATH}/${APP_NAME}"
    done
  fi
)
