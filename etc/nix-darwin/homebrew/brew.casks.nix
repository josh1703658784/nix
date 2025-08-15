_:

# https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.casks
# {
#   name = "_NAME_";
#   args = { require_sha = false; };
# }

# {
#   name = "_NAME_";
#   args = { appdir = "/Applications"; };
# }


[
  {
    name = "busycontacts";
    args = { require_sha = false; };
  }
  {
    name = "little-snitch";
    args = { appdir = "/Applications"; };
  }
  {
    name = "tailscale-app";           # installs to /Applications
    args = { no_binaries = false; };
  }
  "blockblock"            # installs to /Applications
  "busycal"               # installs to /Applications
  "busycontacts"
  "cocoapacketanalyzer"   # installs to /Applications
  "devonthink@3"
  "nova@12.4"
  "sf-symbols"            # installs to /Applications
  "swinsian"              # need r/w to upgrade to beta
]
