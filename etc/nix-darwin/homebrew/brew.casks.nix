_:

# https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.casks
# {
#   name = "_NAME_";
#   args = { require_sha = false; };
# }

[
  {
    name = "busycontacts";
    args = { require_sha = false; };
  }
  {
    name = "powerphotos";
    args = { require_sha = false; };
  }
  {
    name = "suspicious-package";
    args = { require_sha = false; };
  }
  {
    name = "tailscale-app";
    args = { no_binaries = false; };
  }
  {
    name = "yate";
    args = { require_sha = false; };
  }
  # "1password"
  "alfred"
  "appcleaner"    # <nixpkg>
  # "beeper"
  "blockblock"
  "boop"          # <brewCask>
  "busycal"               # installs to /Applications
  "busycontacts"
  "cocoapacketanalyzer"   # installs to /Applications
  "coteditor"     # <brewCask>
  "devonthink"    # <brewCask>
  "dhs"           # <brewCask>
  "exactscan"     # <brewCask>
  "firefox"       # <brewCask>
  "fork"          # <brewCask>
  "halloy"
  "hazel"         # <brewCask>
  "hookmark"
  "iina"          # <nixpkg>
  "imageoptim"
  "iterm2"        # <nixpkg>
  # "jordanbaird-ice"
  "kaleidoscope@3"
  "keepassxc"
  "kextviewr"     # <brewCask>
  "knockknock"    # <brewCask>
  # "macpass"
  "marta"         # <brewCask>
  "meta"          # <brewCask>
  "mullvad-browser"
  # "neo-network-utility"
  "netnewswire"   # <nixpkg>
  "nova"
  "orion"         # <brewCask>
  "qbittorrent"   # <nixpkg>
  "sf-symbols"            # installs to /Applications
  "signal"        # <nixpkg>
  "steermouse"
  "swinsian"      # need r/w to upgrade to beta
  "syncthing-app"
  "textual"       # <brewCask>
  "thingsmacsandboxhelper"
  "tor-browser"
  "xld"
  "yubico-authenticator"
]
