{
    username
  , userHomeDir
  , primaryUser
  , userDataVolume
  , configName
  , ...
}:

{
  system.primaryUser = primaryUser;

  programs.tmux.enable      = true;
  programs.direnv.enable    = true;
  programs.man.enable       = true;
  programs.nix-index.enable = false;

  programs.tmux = {
    enableMouse   = true;
    enableVim     = true;
  };

  programs.direnv   = {
    loadInNixShell    = true;
    nix-direnv.enable = true;
    # settings        = {};
  };

  documentation = {
    enable        = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-documentation.enable
    doc.enable    = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-documentation.doc.enable
    man.enable    = true;
  };

  users.users = {
    "${username}" = {
      home = userHomeDir;
    };
  };

  networking                      = import macos/networking.nix       { inherit configName; };
  power                           = import macos/power.nix            {};
  security                        = import macos/security.nix         {};
  system.defaults.ActivityMonitor = import macos/activity-monitor.nix {};
  system.defaults.controlcenter   = import macos/control-center.nix   {};
  system.defaults.dock            = import macos/dock.nix             { inherit userHomeDir; };
  system.defaults.finder          = import macos/finder.nix           { inherit userDataVolume; };
  system.defaults.loginwindow     = import macos/login-window.nix     {};
  system.defaults.menuExtraClock  = import macos/menu-clock.nix       {};
  system.defaults.NSGlobalDomain  = import macos/global.nix           {};
  system.defaults.screencapture   = import macos/screen-capture.nix   { inherit userHomeDir; };
  system.defaults.smb             = import macos/smb.nix              { inherit configName; };
  system.defaults.SoftwareUpdate  = import macos/software-update.nix  {};
  system.defaults.trackpad        = import macos/trackpad.nix         {};
  system.defaults.WindowManager   = import macos/window-manager.nix   {};
  system.keyboard                 = import macos/keyboard.nix         {};
  system.startup                  = import macos/startup.nix          {};

  # disable system LLM
  system.defaults.CustomSystemPreferences."com.apple.CloudSubscriptionFeatures.optIn" = {
    # https://macos-defaults.com/misc/apple-intelligence.html#toggle-apple-intelligence
    "545129924" = "false";
  };
}
