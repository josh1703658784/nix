# NIX PACKAGES SEARCH
# https://search.nixos.org

# NIX-DARWIN CONFIG OPTIONS
# https://daiderd.com/nix-darwin/manual/index.html

# VARIOUS OPTIONS
# https://mynixos.com/options

# HOMEBREW CASK SEARCH
# https://formulae.brew.sh/cask/nova#default

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
  , config-name
  , ...
}:

{

networking.computerName               = config-name;
networking.hostName                   = config-name;
networking.localHostName              = config-name;
system.defaults.smb.NetBIOSName       = config-name;
system.defaults.smb.ServerDescription = config-name;

programs.nixvim.enable = true;
programs.zsh.enable    = true;
# programs.tmux.enable = true;

users.users = {
  "${username}" = {
    home = user-home-dir;
  };
};

programs.tmux = {
  enableMouse = true;
  enableVim = true;
};


programs.nixvim = {
  viAlias = true;
  vimAlias = true;
  colorschemes.dracula-nvim.enable = true;
  plugins.lualine.enable = true;
  extraConfigVim = ''
    set number relativenumber
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
    set expandtab
  '';
};

# touchid in terminal
security.pam.services.sudo_local.touchIdAuth = true;

system.primaryUser = "admin";

# networking.applicationFirewall.enable = false; # use little-snitch
networking.wakeOnLan.enable = false;
# networking.applicationFirewall = {
#   allowSigned = true;
#   allowSignedApp = false;
#   blockAllIncoming = true;
#   enableStealthMode = true;
# };

# networking.knownNetworkServices = [
#   "Wi-Fi"
#   "Tailscale" # this might break if TS doesn't exist yet?
#   "NextDNS"
# ];
# networking.search = [
#   "stonecat-shark.ts.net"
#   "local"
# ];
#
# networking.dns = [
#   "192.168.10.34"
#   # all quad 9
#   "9.9.9.9"
#   "149.112.112.112"
#   "2620:fe::fe"
#   "2620:fe::9"
# ];


# # Set Git commit hash for darwin-version.
# # system.configurationRevision = self.rev or self.dirtyRev or null;
#
# # Used for backwards compatibility, please read the changelog before changing.
# system.stateVersion = 5;
#
# # The platform the configuration will be used on.
# nixpkgs.hostPlatform = "aarch64-darwin";
#

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
  AppleShowAllFiles                    = false;  # always show hidden files
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
  NSTableViewDefaultSizeMode           = 2;     # 1 = small; sets the size of the finder sidebar icons
  NSWindowShouldDragOnGesture          = true;  # enable moving window by holding anywhere
  "com.apple.sound.beep.feedback"      = 0;     # 0 = off; feedback sound when the system volume changed
  "com.apple.trackpad.forceClick"      = true;  # enable trackpad force click
  "com.apple.trackpad.scaling"         = 3.0;   # 3 = fastest; trackpad tracking speed
  "com.apple.sound.beep.volume"        = 0.4345982;   # sets the beep/alert volume level
};

system.defaults.finder = {
  AppleShowAllExtensions          = true;     # show file extensions
  AppleShowAllFiles               = false;     #  show hidden files
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



system.defaults.controlcenter = {
  AirDrop               = false;
  BatteryShowPercentage = false;
  Bluetooth             = false;
  Display               = false; # screen brightness
  FocusModes            = false;
  NowPlaying            = false;
  Sound                 = true;
};

# https://macos-defaults.com
# https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.CustomSystemPreferences

system.defaults.CustomSystemPreferences."com.apple.CloudSubscriptionFeatures.optIn" = {
  # https://macos-defaults.com/misc/apple-intelligence.html#toggle-apple-intelligence
  "545129924" = "false";
};


# system.defaults.CustomSystemPreferences = {}; # sets custom system preferences
# system.defaults.CustomUserPreferences = {};

# system.defaults.CustomUserPreferences."com.apple.Safari" = {
#   # vv enable develop menu
#   "WebKitDeveloperExtrasEnabledPreferenceKey" = 1;
#   "WebKitPreferences.developerExtrasEnabled"  = 1;
#   "IncludeDevelopMenu"                        = 1;
#   "PreferencesModulesMinimumWidths.DeveloperMenuVisibility" = 1;
#   # ^^ enable develop menu
# };

}
