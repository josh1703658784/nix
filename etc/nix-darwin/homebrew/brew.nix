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

nix-homebrew.enable = true;     # installs homebrew
homebrew.enable     = true;     # enables homebrew integration

nix-homebrew = {
  # installs/configure homebrew
  # https://github.com/zhaofengli/nix-homebrew
  mutableTaps = false;
  enableRosetta = true;
  user = "admin";
  taps = {
    "homebrew/homebrew-core" = inputs.homebrew-core;
    "homebrew/homebrew-cask" = inputs.homebrew-cask;
    "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
  };
};

homebrew = {
  brews                   = pkgs.lib.mkForce [ ]; # https://github.com/LnL7/nix-darwin/pull/1329
  caskArgs.appdir         = "${user-home-dir}/Applications/nix-homebrew";
  caskArgs.no_binaries    = true;
  caskArgs.require_sha    = true;
  caskArgs.no_quarantine  = false;
  global.brewfile         = true;
  onActivation.cleanup    = "uninstall";
  casks                   = pkgs.callPackage ./brew.casks.nix {};
  # masApps                 = pkgs.callPackage ./brew.mas.nix {};

  # upgrades/updates
  onActivation.upgrade    = false;
  onActivation.autoUpdate = false;
  global.autoUpdate       = false;
};


}
