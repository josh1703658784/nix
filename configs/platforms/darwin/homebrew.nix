# options: https://mynixos.com/nix-darwin/options/homebrew
{
    inputs
  , config
  , pkgs
  , vars
  , lib
  , ...
}:

{

nix-homebrew.enable = true;     # installs homebrew
homebrew.enable     = true;     # enables homebrew integration

homebrew.taps = builtins.attrNames config.nix-homebrew.taps;

nix-homebrew                  = {
  # installs/configure homebrew
  # https://github.com/zhaofengli/nix-homebrew
  mutableTaps                   = false;
  enableRosetta                 = true;
  user                          = vars.homebrewUser;
  taps                          = {
    "homebrew/homebrew-bundle"    = inputs.homebrew-bundle;
  };
};

# export HOMEBREW_NO_ANALYTICS=1
# https://nix-darwin.github.io/nix-darwin/manual/#opt-homebrew.enable
homebrew = {
  brews                   = pkgs.lib.mkForce [ ]; # https://github.com/LnL7/nix-darwin/pull/1329
  casks                   = import ./casks.nix;
  masApps                 = import ./mas.nix;
  # brewPrefix              = "${userHomeDir}/opt/homebrew/bin";
  user                    = vars.homebrewUser;
  caskArgs.appdir         = "${vars.userHomeDir}/Applications/Homebrew Apps";
  caskArgs.no_binaries    = true;
  caskArgs.require_sha    = true;
  caskArgs.no_quarantine  = false;
  global.brewfile         = true;
  onActivation.cleanup    = "uninstall";
  # upgrades/updates
  onActivation.upgrade    = false;
  onActivation.autoUpdate = false;
  global.autoUpdate       = false;
};


}
