#
# nova(){
#   real="$(readlink '/Applications/Nix Apps/Nova.app' )"; local -r real
#   bin="${real}/Contents/SharedSupport/nova"; local -r bin
#   "${bin}" ${@}
# }

function docker-compose-recreate-log(){
  # local -r service="${@}"
  docker compose up \
    --detach \
    --force-recreate \
    --renew-anon-volumes \
    ${@}

  docker compose logs \
    --follow "${@}" \
  | tspin \
    --follow
}

docker-compose-up-d-log-colorize(){
  local -r args="${@}"
  docker compose up -d "${args}"
  docker compose logs -f "${args}" | tspin -f
}

docker-compose-inspect(){
  local -r service="${1}"
  docker inspect "$(docker-compose ps -a "${service}" | awk '{ print $1 }' | tail -n 1)"
}

docker-compose-log-colorize(){
  docker compose logs -f "${@}" | tspin -f
}

# # expand aliases to full command
# function expand-alias() {
#     zle _expand_alias
#     zle self-insert
# }
# zle -N expand-alias
# bindkey -M main ' ' expand-alias

n() {
  [ "${NNNLVL:-0}" -eq 0 ] || {
    echo 'nnn is already running'
    return
  }
  # w/ export will *always* cd on quit
  local -r nnnTmpfile="${XDG_CONFIG_HOME:-"${HOME}/.config"}/nnn/.lastd"

  # The command builtin allows one to alias nnn to n, if desired, without
  # making an infinitely recursive alias
  command nnn "${@}"

  [ ! -f "${nnnTmpfile}" ] || {
    # shellcheck source=/dev/null
    . "${nnnTmpfile}"
    rm -f -- "${nnnTmpfile}" > '/dev/null'
  }
}

cdtmp() {
  local -r tmpdir="$(mktemp -d)"
  local -r target_dir="${HOME}/.config/custom.cdtmp"
  local -r history="${target_dir}/history.$(date +%s)"

  mkdir -p "${HOME}/.config/custom.cdtmp"
  ( umask 066
    touch "${history}"
  )

  echo "${tmpdir}" >> "${history}"

  cd "${tmpdir}"
}

__clean-cdtmp-remove-file() {
  local -r filename="${1}"
  local -r content="$( cat "${filename}" )"

  sudo -v
  sudo rm -r "${content}" && sudo rm "${filename}"
}

clean-cdtmp() {
  local -r tmpdir="$(mktemp -d)"
  local -r target_dir="${HOME}/.config/custom.cdtmp"
  local -r history="${target_dir}/history.$(date +%s)"

  local all_paths="$( cat "${target_dir}/history."* )"

  echo '## remove the below file(s)? ########'
  echo "${content}"
  echo '## remove the above file(s)? ########'
  echo '## Y/<any key> (case-sensitive)'
  read -r response

  if [[ "${response}" != "Y" ]]; then
    echo 'EXITING'
    return
  fi

  mkdir -p "${HOME}/.config/custom.cdtmp"

  sudo -v
  for filename in "${target_dir}/"*; do
    [ -e "${filename}" ] || continue
    __clean-cdtmp-remove-file "${filename}" || return
  done
}
