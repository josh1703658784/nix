
nova(){
  real="$(readlink '/Applications/Nix Apps/Nova.app' )"; local -r real
  bin="${real}/Contents/SharedSupport/nova"; local -r bin
  "${bin}" ${@}
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
