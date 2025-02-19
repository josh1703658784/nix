 { inputs, username, config, pkgs, ... }:

# NIX PACKAGES SEARCH
# https://search.nixos.org

# NIX-DARWIN CONFIG OPTIONS
# https://daiderd.com/nix-darwin/manual/index.html

# HOMEBREW CASK SEARCH
# https://formulae.brew.sh/cask/nova#default

{

# pkgs.brewCasks.busycal = newbusycal;


users.users = {
  "${username}" = {
    home = "/Users/${username}";
  };
};

fonts.packages = with pkgs; [
  nerdfonts
  inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
];



programs.nixvim.enable = true;
programs.nixvim = {
  viAlias = true;
  vimAlias = true;
  colorschemes.dracula-nvim.enable = true;
  plugins.lualine.enable = true;
  extraConfigVim = ''
    set number relativenumber
  '';
};

brew-nix.enable = true;
environment.systemPackages = with pkgs; [
  # cli
  pkgs.git
  pkgs.mas

  # nixpkgs gui
  pkgs.iterm2
  pkgs.appcleaner
  pkgs.iina
  pkgs.net-news-wire
  pkgs.qbittorrent
  pkgs.signal-desktop
  pkgs.syncthing
  pkgs.xld


  # brewCasks gui
  brewCasks.arq
  brewCasks.boop
  # brewCasks.cocoapacketanalyzer
  brewCasks.coteditor
  brewCasks.devonthink
  brewCasks.dhs
  brewCasks.exactscan
  brewCasks.firefox
  brewCasks.fork
  brewCasks.hazel
  brewCasks.kextviewr
  brewCasks.knockknock
  # brewCasks.little-snitch           # ! requires /Applications location
  brewCasks.marta
  brewCasks.meta
  brewCasks.nova
  brewCasks.orbstack
  brewCasks.orion
  brewCasks.steermouse
  # brewCasks.swinsian                # ! can't update to beta
  brewCasks.textual
  #brewCasks.

  # brewCasks.blockblock              # ! install required
  # brewCasks.busycal                 # ! weird collisions
  # brewCasks.hiddenbar
  # brewCasks.imageoptim
  # brewCasks.neo-network-utility     # ! cannot undmg non-hfs
  # brewCasks.photosweeper-x
  # brewCasks.reikey                  # ! install required
  # brewCasks.sf-symbols              # ! install required
  # brewCasks.tor-browser
  # brewCasks.yubico-yubikey-manager  # ! install required

  # overrides
  # (brewCasks.busycal.overrideAttrs (o: {
  #   unpackPhase = "undmg $src";
  #   src = pkgs.fetchurl {
  #     url = (builtins.replaceStrings [".zip"] [".dmg" ] o.src.url);
  #     sha256 = "sha256-4reNiGyU2Woc+4OIVhQexVZYqdPeyg3Ff3qtkA8ZE4E=";
  #   };
  # }))
  (brewCasks.alfred.overrideAttrs (o: {
    nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.gnutar ];
    unpackPhase = "tar -xvzf $src";
  }))
  (brewCasks.imageoptim.overrideAttrs (o: {
    nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.gnutar ];
    unpackPhase = "tar -xvf $src";
  }))
  # (brewCasks.neo-network-utility.overrideAttrs (o: {
  #   nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.gnutar ];
  #   unpackPhase = ''
  #   unzip -c "''${src}"
  #   dmgsrc="$(echo "''${src}" | sed 's/\.zip$//g')"
  #   undmg "''${dmgsrc}"
  #   # echo
  #   '';
  #   # url = (builtins.replaceStrings [".zip"] [""] o.src.url);
  # }))
  (brewCasks.powerphotos.overrideAttrs (o: {
    src = pkgs.fetchurl {
      url = builtins.head o.src.urls;
      hash = "sha256-YqCtMiim1B48XzKJcnJ5yUI7qVUquY6FTltF+Jf6Y/A=";
    };
  }))
  (brewCasks.suspicious-package.overrideAttrs (o: {
    src = pkgs.fetchurl {
      url = builtins.head o.src.urls;
      hash = "sha256-//iL7BRdox+KA1CJnGttUQiUfskuBeMGrf1YUNt/m90=";
    };
  }))

  # (brewCasks.PACKAGE.overrideAttrs (o: {
  #   src = pkgs.fetchurl {
  #     url = builtins.head o.src.urls;
  #     hash = lib.fakeHash; # Replace me with real hash after building once
  #   };
  # }))
];

#
# # @ TODO look at using orbstack as a "nix.linux-bulder"
#
#
# # nix.settings.allowed-users = ["josh" "admin" "root"];
# nix.checkConfig = true;
# brew-nix.enable = true;
# environment.systemPackages = pkgs.callPackage ./darwin-pkgs.nix {};
#
# # networking.computerName = "mbp";
# # networking.hostName = "mbp";
# networking.knownNetworkServices = [
#   "Wi-Fi"
#   "Tailscale" # this might break if TS doesn't exist yet?
# ];
#
# # networking.search = [
# #   "stonecat-shark.ts.net"
# #   "local"
# # ];
#
# # networking.wakeOnLan.enable = false;
# #
# #
# # networking.dns = [
# #   # all quad 9
# #   "9.9.9.9"
# #   "149.112.112.112"
# #   "2620:fe::fe"
# #   "2620:fe::9"
# # ];
  security.pam.enableSudoTouchIdAuth = true;
#
# # # List packages installed in system profile. To search by name, run:
# # # $ nix-env -qaP | grep wget
# # environment.systemPackages =
# #   [ pkgs.vim
# #   ];
#
# # Set Git commit hash for darwin-version.
# # system.configurationRevision = self.rev or self.dirtyRev or null;
#
# # Used for backwards compatibility, please read the changelog before changing.
# system.stateVersion = 5;
#
# # The platform the configuration will be used on.
# nixpkgs.hostPlatform = "aarch64-darwin";
#
# services.nix-daemon.enable = true;
#
# # fonts.packages
#
# nix = {
#   package                       = pkgs.nix;
#   gc.automatic                  = true;
#   gc.interval                   = { Weekday = 0; Hour = 0; Minute = 0; };
#   gc.options                    = "--delete-older-than 30d";
#   optimise.automatic            = true;
#   settings                      = {
#     extra-experimental-features = [ "nix-command" "flakes" ];
#     experimental-features       = "nix-command flakes";
#   };
# };
#
 programs           = {
#   gnupg.agent.enable = true;
   zsh.enable         = true;  # default shell on catalina
 };


# *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*\
# [[ macos system configuration]] \ | / - \ | / - \ | / - \ | / - \ | / -*|
# *=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/
system.startup.chime                                            = false;
system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
# enable Stage Manager
system.defaults.WindowManager.GloballyEnabled                   = false;
# window margins when tiling windows
system.defaults.WindowManager.EnableTiledWindowMargins          = false;

system.defaults.dock = {
  autohide                = true; # automatically hide and show the dock
  orientation             = "left"; # position of the dock on screen
  show-process-indicators = false;
  show-recents            = false;
  static-only             = false;  # show only open applications, disables dirs
  tilesize                = 32;     # size of the icons
  magnification           = false;
  mineffect               = "suck";
  minimize-to-application = true;
  expose-group-apps       = true;   # group windows by application in Mission Control
  mru-spaces              = false;  # automatically rearrange spaces based on most recent use
  persistent-apps         = [];     # persistent applications
  persistent-others       = [       # persistent folders
    "/Users/josh/Documents/workdir/running.txt"
    "/Volumes/Data"
    "/Users/josh/Downloads"
  ];
};

system.defaults.ActivityMonitor = {
  SortColumn = "CPUUsage";
  SortDirection = 0; # 0 = decending
};

system.defaults.NSGlobalDomain = {
  AppleICUForce24HourTime              = true;  # use 24-hour or 12-hour time
  AppleInterfaceStyle                  = "Dark";
  AppleScrollerPagingBehavior          = true;  # jump to the spot that's clicked on the scroll bar
  AppleShowAllExtensions               = true;  # show all file extensions in Finder
  AppleShowAllFiles                    = true;  # always show hidden files
  AppleShowScrollBars                  = "Always";    # when to show the scrollbars
  AppleWindowTabbingMode               = "always";    # sets the window tabbing when opening a new document
  NSAutomaticCapitalizationEnabled     = false; # enable automatic capitalization
  NSAutomaticDashSubstitutionEnabled   = false; # enable smart dash substitution
  NSAutomaticInlinePredictionEnabled   = false; # enable inline predictive text
  NSAutomaticPeriodSubstitutionEnabled = false; # enable smart period substitution
  NSAutomaticQuoteSubstitutionEnabled  = false; # enable smart quote substitution
  NSAutomaticSpellingCorrectionEnabled = true;  # enable automatic spelling correction
  NSDisableAutomaticTermination        = false; # disable the automatic termination of inactive apps
  NSDocumentSaveNewDocumentsToCloud    = false; # save new documents to iCloud by default
  NSNavPanelExpandedStateForSaveMode   = true;  # use expanded save panel by default.
  NSNavPanelExpandedStateForSaveMode2  = true;  # use expanded save panel by default.
  NSTableViewDefaultSizeMode           = 1;     # 1 = small; sets the size of the finder sidebar icons
  NSWindowShouldDragOnGesture          = true;  # enable moving window by holding anywhere
  "com.apple.sound.beep.feedback"      = 0;     # 0 = off; feedback sound when the system volume changed
  "com.apple.trackpad.forceClick"      = true;  # enable trackpad force click
  "com.apple.trackpad.scaling"         = 3.0;   # 3 = fastest; trackpad tracking speed
  "com.apple.sound.beep.volume"        = 0.4345982;   # sets the beep/alert volume level
};

system.defaults.finder = {
  AppleShowAllExtensions          = true;     # show file extensions
  AppleShowAllFiles               = true;     #  show hidden files
  CreateDesktop                   = true;    # show icons on the desktop
  FXDefaultSearchScope            = "SCcf";   # SCcf = current dir; default search scope
  FXEnableExtensionChangeWarning  = false;    # show warnings when changing a file extension
  FXPreferredViewStyle            = "clmv";   # clmv = column view; default finder view
  FXRemoveOldTrashItems           = false;    # let hazel clean the trash; remove items in trash after 30 days
  NewWindowTarget                 = "Other";  # default folder shown in Finder windows
  NewWindowTargetPath             = "file:///Volumes/josh"; # URI to open when NewWindowTarget is "Other"
  ShowExternalHardDrivesOnDesktop = false;    # show external disks on desktop
  ShowHardDrivesOnDesktop         = false;    # show hard disks on desktop
  ShowMountedServersOnDesktop     = false;    # show connected servers on desktop
  ShowPathbar                     = true;     # show path breadcrumbs in finder
  ShowRemovableMediaOnDesktop     = false;    # show removable media (CDs...) on desktop
  ShowStatusBar                   = false;    # show status bar at bottom of finder windows
  _FXShowPosixPathInTitle         = false;    # show the full POSIX filepath in the window title
  _FXSortFoldersFirst             = true;     # keep folders on top when sorting by name
};

system.defaults.loginwindow = {
  GuestEnabled  = false;
  SleepDisabled = true; # hides the Sleep button on the login screen
};

system.defaults.menuExtraClock = {
  Show24Hour     = true;  # show a 24-hour clock
  ShowDate       = 2;     # 2 = never
  ShowDayOfMonth = false;
  ShowDayOfWeek  = true;
  ShowSeconds    = false;
};

system.defaults.screencapture = {
  include-date = true; # include date and time in screenshot filenames.
  location     = "/Users/josh/Downloads"; # where to save screenshots
};

system.defaults.trackpad = {
  FirstClickThreshold      = 0; # 0 = light click/pressure
  SecondClickThreshold     = 0; # 0 = light click/pressure
  TrackpadRightClick       = true;
  TrackpadThreeFingerDrag  = true;
};

system.keyboard = {
  enableKeyMapping      = true;
  remapCapsLockToEscape = true;
};

system.defaults.alf = {
  globalstate                = 0; # 0=disable; disable the internal firewall
  # little snitch acts as the outbound+inbound firewall

  # allows any downloaded application that has been signed to accept incoming requests
  allowdownloadsignedenabled = 0; # 0 = false

  # allows any signed Application to accept incoming requests
  allowsignedenabled         = 0; # 0 = false

  # drops incoming requests via ICMP
  stealthenabled             = 1;
};

system.defaults.controlcenter = {
  AirDrop               = false;
  BatteryShowPercentage = false;
  Bluetooth             = false;
  Display               = false; # screen brightness
  FocusModes            = false;
  NowPlaying            = false;
  Sound                 = true;
};

# https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.CustomSystemPreferences
#system.defaults.CustomSystemPreferences = {}; # sets custom system preferences
#system.defaults.CustomUserPreferences = {};

}
