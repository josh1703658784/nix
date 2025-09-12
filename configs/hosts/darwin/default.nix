{
    system
  , config
  , vars
  , ...

}:

let
  thisFlakePath = "${vars.userDataVolume}/Developer/nix-configs/configs";
  # specialArgs = specialArgs // { inherit thisFlakePath; };
  # builtins.trace

  # vars' = vars // { inherit thisFlakePath; };
  # specialArgs = specialArgs // { vars = vars'; };
  # specialArgs = {
  #   inherit specialArgs;
  #   vars = {
  #     inherit vars;
  #     inherit thisFlakePath;
  #   };
  # };
  # specialArgs = {};
in
{
  imports = [
    ../../modules/darwin/system.nix
    ../../modules/darwin/homebrew.nix
    ../../modules/home-manager/home-manager.nix
  ];

  nix.enable = false; # false for nix-determinate

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
