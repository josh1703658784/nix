{
    system
  , inputs
  , pkgs
  , nixpkgs
  , lib
  , config
  , specialArgs
  , configName
  , username
  , primaryUser
  , userDataVolume
  , userHomeDir
  , ...

}:

let
in
{
  imports = [
    { disabledModules = [ "system/applications.nix" ]; }
    ../../modules/darwin/system.applications.nix
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/software.nix
    ../../modules/darwin/home-manager.nix
  ];

  nix.enable = false; # nix-determinate overrides this

  nix.checkConfig = true;
  nix.channel.enable = false;
  nix.settings.sandbox = true;
  nix.settings.auto-optimise-store = true;

  # nix-darwin.specialArgs.user = "josh";
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;
  nixpkgs.config.allowUnfree = true;


}
