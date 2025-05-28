{
    inputs
  , config
  , pkgs
  , pkgs-unstable
  , username
  , user-home-dir
  , homebrew-prefix
  , nix-homebrew
  , homebrew-volume
  , ...
}:

{

nix-homebrew.enable = true; # installs homebrew
homebrew.enable     = true;      # enables homebrew integration

# installation config
nix-homebrew = {
  #@todo don't install at default location
  mutableTaps = false;
  enableRosetta = false;
  taps = {
        # "homebrew/homebrew-core" = inputs.homebrew-core;
    # "homebrew/homebrew-cask" = inputs.homebrew-cask;
    "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
  };
  user = username;
  prefixes = {
    "${homebrew-prefix}" = {
      enable = true;
      library = "${homebrew-prefix}/Library";
      taps = {
        # "homebrew/homebrew-core" = inputs.homebrew-core;
        # "homebrew/homebrew-cask" = inputs.homebrew-cask;
        "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      };
    };
  };
};

environment.systemPath = [ "${homebrew-prefix}/bin" ];
homebrew = {
  brewPrefix              = "${homebrew-prefix}/bin";
  caskArgs.appdir         = "${homebrew-volume}/Applications"; #/nix-homebrew";
  caskArgs.no_binaries    = true;
  caskArgs.no_quarantine  = false;
  caskArgs.require_sha    = true;
  global.autoUpdate       = true;
  global.brewfile         = false;
  onActivation.autoUpdate = true;
  onActivation.upgrade    = true;
  onActivation.cleanup    = "uninstall"; # set 'zap' global and uninstall per 'app'?
  brews                   = pkgs.lib.mkForce [ ]; # https://github.com/LnL7/nix-darwin/pull/1329
};


homebrew.casks = [
  # # https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.casks
  "alfred"
  # "arq"           # <brewCask>
  "beeper"
  "boop"          # <brewCask>
  "busycal"               # installs to /Applications
  # "clop"
  "cocoapacketanalyzer"   # installs to /Applications
  "coteditor"     # <brewCask>
  "devonthink"    # <brewCask>
  "dhs"           # <brewCask>
  "exactscan"     # <brewCask>
  "firefox"       # <brewCask>
  "fork"          # <brewCask>
  "hazel"         # <brewCask>
  # "hiddenbar"
  "hookmark"
  "iina"          # <nixpkg>
  "imageoptim"
  "iterm2"        # <nixpkg>
  {
    name = "kaleidoscope@3";
    # args = { onActivation.update = true; };
  }
  "jordanbaird-ice"
  "kextviewr"     # <brewCask>
  "knockknock"    # <brewCask>
  "marta"         # <brewCask>
  "meta"          # <brewCask>
  "mullvad-browser"
  "neo-network-utility"
  "netnewswire"   # <nixpkg>
  "nova"
  {
    name = "orbstack";
    args = { no_binaries = false; };
  }
  "orion"         # <brewCask>
  "qbittorrent"   # <nixpkg>
  # "reikey"                # installs to /Applications
  "sf-symbols"            # installs to /Applications
  "signal"        # <nixpkg>
  "swinsian"        # need r/w to upgrade to beta
  "syncthing"
  {
    name = "tailscale";
    args = { no_binaries = false; };
  }
  "textual"       # <brewCask>
  "thingsmacsandboxhelper"
  "tor-browser"
  "xld"
  "yubico-authenticator"
  "appcleaner"    # <nixpkg>
  {
    name = "blockblock";
    args = { appdir = "/Applications"; };
  }
  {
    name = "mailmate@beta";
    args = { require_sha = false; };
  }
  {
    name = "busycontacts";
    args = { require_sha = false; };
  }
  {
    name = "suspicious-package";
    args = { require_sha = false; };
  }
  {
    name = "powerphotos";
    args = { require_sha = false; };
  }
  # {
  #   name = "little-snitch";
  #   args = { appdir = "/Applications"; };
  # }
  {
    name = "steermouse";
    args = { appdir = "/Applications"; };
  }     # <nixpkg>
];

homebrew.masApps = {
  # "1blocker"                = 1365531024;
#   # "actions"                 = 1586435171;
#   # "amphetamine"             = 937984704;
#   "anybox"                  = 1593408455;
#   "bear"                    = 1091189122;
#   "controllerforhomekit"    = 1198176727;
#   "dark reader for safari"  = 1438243180;
#   "data jar"                = 1453273600;
#   "infuse"                  = 1136220934;
#   "kagi for safari"         = 1622835804;
  # "link unshortener"        = 1506953658;
#   "logger"                  = 1479321094;
#   "mapper"                  = 1589391989;
#   "micro snitch"            = 972028355;
#   "monodraw"                = 920404675;
#   "musicbox"                = 1614730313;
#   "musicharbor"             = 1440405750;
#   "noir"                    = 1592917505;
#   "numbers"                 = 409203825;
#   "ok json"                 = 1576121509;
#   "pages"                   = 409201541;
  # "parcel"                  = 639968404;
#   "photomator"              = 1444636541;
#   "pixelmator pro"          = 1289583905;
#  # " "pushover
#   "redirect web for safari" = 1571283503;
#  # " "regexp
#   "rippple"                 = 1309894528;
#   "soulver 3"               = 1508732804;
#   "stopthefonts"            = 1671452642;
#   "stopthemadness pro"      = 2118554294;
#   "strongbox"               = 1481853033;
#   "surfed"                  = 1591590700;
#   "things"                  = 904280696;
  # "utm"                     = 1538878817;
  # "wifi explorer"           = 494803304;
};


}
