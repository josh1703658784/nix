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
  mutableTaps = false;
  enableRosetta = false;
  user = "admin";
  taps = {
    "homebrew/homebrew-core" = inputs.homebrew-core;
    "homebrew/homebrew-cask" = inputs.homebrew-cask;
    "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
  };
};

# environment.systemPath = [ "${homebrew-prefix}/bin" ];
homebrew = {
  brews                   = pkgs.lib.mkForce [ ]; # https://github.com/LnL7/nix-darwin/pull/1329
  caskArgs.no_binaries    = true;
  caskArgs.no_quarantine  = false;
  caskArgs.require_sha    = true;
  global.autoUpdate       = true;
  global.brewfile         = false;
  onActivation.autoUpdate = true;
  onActivation.cleanup    = "uninstall";          # set 'zap' global and uninstall per 'app'?
  onActivation.upgrade    = true;
  casks                   = pkgs.callPackage ./brew.casks.nix {};
  # masApps                 = pkgs.callPackage ./brew.mas.nix {};
};


}
