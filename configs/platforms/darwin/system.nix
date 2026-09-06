{
  vars
  , ...
}:

{
  system.primaryUser = vars.primaryUser;

  programs.tmux.enable      = true;
  programs.direnv.enable    = true;
  programs.man.enable       = true;
  programs.nix-index.enable = false;

  programs.zsh         = {
    # patches "Ignore insecure directories and files and continue [y] or abort compinit [n]?"
    # due to nix-darwin not properly supporting multi-user installs
    enableBashCompletion = false;
    enableCompletion     = false;
    enableGlobalCompInit = false;
    # enableSyntaxHighlighting = true;
    enableFastSyntaxHighlighting = true;
  };



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
    "${vars.username}" = {
      home = vars.userHomeDir;
    };
  };

  networking                      = import system/networking.nix       { inherit vars; };
  power                           = import system/power.nix            {};
  security                        = import system/security.nix         {};
  system.defaults.ActivityMonitor = import system/activity-monitor.nix {};
  system.defaults.controlcenter   = import system/control-center.nix   {};
  system.defaults.dock            = import system/dock.nix             { inherit vars; };
  system.defaults.finder          = import system/finder.nix           { inherit vars; };
  system.defaults.loginwindow     = import system/login-window.nix     {};
  system.defaults.menuExtraClock  = import system/menu-clock.nix       {};
  system.defaults.NSGlobalDomain  = import system/global.nix           {};
  system.defaults.screencapture   = import system/screen-capture.nix   { inherit vars; };
  system.defaults.smb             = import system/smb.nix              { inherit vars; };
  system.defaults.SoftwareUpdate  = import system/software-update.nix  {};
  system.defaults.trackpad        = import system/trackpad.nix         {};
  system.defaults.WindowManager   = import system/window-manager.nix   {};
  system.keyboard                 = import system/keyboard.nix         {};
  system.startup                  = import system/startup.nix          {};

  # disable system LLM
  system.defaults.CustomSystemPreferences."com.apple.CloudSubscriptionFeatures.optIn" = {
    # https://macos-defaults.com/misc/apple-intelligence.html#toggle-apple-intelligence
    "545129924" = "false";
  };
  system.defaults.CustomUserPreferences."com.lowtechguys.MusicDecoy" = {
    "mediaAppPath" = "${vars.userHomeDir}/Applications/Homebrew Apps/Swinsian.app";
  };

  # https://binarynights.com/manual#fileviewer
  # defaults write -g NSFileViewer -string com.binarynights.ForkLift;
  # defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType="public.folder";LSHandlerRoleAll="com.binarynights.ForkLift";}'
}
