# options: https://mynixos.com/nix-darwin/options/homebrew
{
    inputs
  , config
  , pkgs
  , primaryUser
  , userHomeDir
  , ...
}:

{

nix-homebrew.enable = true;     # installs homebrew
homebrew.enable     = true;     # enables homebrew integration
brew-nix.enable     = true;     # enable nixified brew wrappers

homebrew.taps = builtins.attrNames config.nix-homebrew.taps;

nix-homebrew               = {
  # installs/configure homebrew
  # https://github.com/zhaofengli/nix-homebrew
  mutableTaps                = false;
  enableRosetta              = true;
  user                       = primaryUser;
  taps                       = {
      # "homebrew/homebrew-cask"   = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      "homebrew/homebrew-legacy" = inputs.homebrew-legacy;
    # "josh/homebrew-empty" = inputs.homebrew-empty;
  };
};

nix-homebrew.prefixes = {
  "${userHomeDir}/opt/homebrew" = {
    enable = false;
    library = "${userHomeDir}/opt/homebrew/Library";
    taps = {
      "josh/homebrew-empty" = inputs.homebrew-empty;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      "homebrew/homebrew-legacy" = inputs.homebrew-legacy;
    };
  };
};

# export HOMEBREW_NO_ANALYTICS=1
homebrew = {
  brews                   = pkgs.lib.mkForce [ ]; # https://github.com/LnL7/nix-darwin/pull/1329
  # brewPrefix              = "${userHomeDir}/opt/homebrew/bin";
  # user                    = primaryUser;
  caskArgs.appdir         = "${userHomeDir}/Applications/Homebrew Apps";
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
