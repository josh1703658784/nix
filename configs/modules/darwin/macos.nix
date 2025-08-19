###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://nix-darwin.github.io/nix-darwin/manual/
#    https://mynixos.com/nix-darwin/options
#
# See also
# https://macos-defaults.com
# https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.CustomSystemPreferences
###################################################################################

{
    userHomeDir
  , userDataVolume
  , configName
  , primaryUser
  , ...
}:

{

system.defaults.smb.NetBIOSName                                 = configName;
system.defaults.smb.ServerDescription                           = configName;
system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
system.startup.chime                                            = false;

networking                      = import macos/networking.nix       { inherit configName; };
power                           = import macos/power.nix            {};
security                        = import macos/security.nix         {};
system.defaults.ActivityMonitor = import macos/activity-monitor.nix {};
system.defaults.controlcenter   = import macos/control-center.nix   {};
system.defaults.dock            = import macos/dock.nix             { inherit userHomeDir; };
system.defaults.finder          = import macos/finder.nix           { inherit userDataVolume; };
system.defaults.loginwindow     = import macos/login-window.nix     {};
system.defaults.menuExtraClock  = import macos/menu-clock.nix       {};
system.defaults.screencapture   = import macos/screen-capture.nix   { inherit userHomeDir; };
system.defaults.trackpad        = import macos/trackpad.nix         {};
system.defaults.WindowManager   = import macos/window-manager.nix   {};
system.keyboard                 = import macos/keyboard.nix         {};
system.defaults.NSGlobalDomain  = import macos/global.nix           {};


# disable system LLM
system.defaults.CustomSystemPreferences."com.apple.CloudSubscriptionFeatures.optIn" = {
  # https://macos-defaults.com/misc/apple-intelligence.html#toggle-apple-intelligence
  "545129924" = "false";
};

system.defaults.CustomUserPreferences."com.swinsian.Swinsian" = {
  "WatchedFolders" = [{
    "Relative Directory Path" = "/foo";
  }];
};

}
