{
  inputs
  , pkgs
  , ...
}:

let
  overrides = import ./software.casks-overrides.nix { inherit pkgs; };
in
{

homebrew.casks = [
  {
    name = "little-snitch";
    args = { appdir = "/Applications"; };
  }
  {
    name = "steermouse";
    args = { appdir = "/Applications"; };
  }
  # {
  #   name = "tailscale";           # uses installer; installs to /Applications
  #   args = { no_binaries = false; };
  # }
  "blockblock"            # installs to /Applications
  "devonthink@3"
  "sf-symbols"            # installs to /Applications
];

environment.systemPackages = [
  pkgs.mas

  overrides.alfred
  overrides.busycal
  overrides.busycontacts
  overrides.cocoapacketanalyzer
  overrides.hookmark
  overrides.imageoptim
  overrides.mullvad-browser
  overrides.powerphotos
  overrides.suspicious-package
  overrides.tor-browser
  overrides.yate
  pkgs.appcleaner
  pkgs.brewCasks."kaleidoscope@3"
  pkgs.brewCasks.boop
  pkgs.brewCasks.coteditor
  pkgs.brewCasks.dhs
  pkgs.brewCasks.exactscan
  pkgs.brewCasks.firefox
  pkgs.brewCasks.fork
  pkgs.brewCasks.halloy
  pkgs.brewCasks.hazel
  pkgs.brewCasks.jordanbaird-ice
  pkgs.brewCasks.kextviewr
  pkgs.brewCasks.knockknock
  pkgs.brewCasks.macpass
  pkgs.brewCasks.marta
  pkgs.brewCasks.meta
  pkgs.brewCasks.monodraw
  pkgs.brewCasks.mp3tag
  pkgs.brewCasks.netiquette
  pkgs.brewCasks.nova
  pkgs.brewCasks.orbstack
  pkgs.brewCasks.orion
  pkgs.brewCasks.proxyman
  pkgs.brewCasks.signal
  pkgs.brewCasks.swinsian
  pkgs.brewCasks.syncthing-app
  pkgs.brewCasks.taskexplorer
  # pkgs.brewCasks.tableplus
  pkgs.brewCasks.textual
  pkgs.brewCasks.thingsmacsandboxhelper
  pkgs.brewCasks.yubico-authenticator
  # pkgs.arq
  pkgs.iina
  pkgs.iterm2
  pkgs.keepassxc
  pkgs.net-news-wire
  pkgs.qbittorrent
  pkgs.xld
];

homebrew.masApps = {
  "1blocker"                = 1365531024;
  "actions"                 = 1586435171;
  "amphetamine"             = 937984704;
  "anybox"                  = 1593408455;
  "apple configurator"      = 1037126344;
  "autostarter"             = 6444444273;
  "banktivity"              = 1480779512;
  "beagleim"                = 1445349494;
  "bear"                    = 1091189122;
  "dnsecure"                = 1533413232;
  "goodlinks"               = 1474335294;
  "hush"                    = 1544743900;
  "hyperspace"              = 6739505345;
  "infuse"                  = 1136220934;
  "js blocker"              = 6661025087;
  "kagi for safari"         = 1622835804;
  "mapper"                  = 1589391989;
  "mela"                    = 1568924476;
  "musicharbor"             = 1440405750;
  "noir"                    = 1592917505;
  "numbers"                 = 409203825;
  "ok json"                 = 1576121509;
  "pages"                   = 409201541;
  "parcel"                  = 639968404;
  "photomator"              = 1444636541;
  "photosweeper"            = 463362050;
  "pixelmator pro"          = 1289583905;
  "redirect web for safari" = 1571283503;
  "rippple"                 = 1309894528;
  "shortery"                = 1594183810;
  "soulver 3"               = 1508732804;
  "stopthefonts"            = 1671452642;
  "tailscale"               = 1475387142;
  "things"                  = 904280696;
  "toothfairy"              = 1191449274;
  "tot"                     = 1491071483;
  "utm"                     = 1538878817;
  "wifi explorer"           = 494803304;
  "xcode"                   = 497799835;
  # "pushover"                = 506088175;
  # "singlefile"              = 6444322545;
  # "strongbox"               = 1481853033;
};

}
