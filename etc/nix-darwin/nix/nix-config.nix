{ self, nix-darwin, pkgs, nixcasks, nixpkgs, ... }: {
  nix.enable = false; # nix-determinate overrides this

  #   pkgs = import nixpkgs {
  #   inherit system;
  #   config.packageOverrides = _: {
  #     inherit nixcasks;
  #   };
  # };

  # nix-darwin.specialArgs.user = "josh";
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nix.channel.enable = false;

  nix.settings.sandbox = true;

  # nix.virtualisation.docker.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # nix = {
  #   package                       = pkgs.nix;
  #   gc.automatic                  = true;
  #   gc.interval                   = { Weekday = 0; Hour = 0; Minute = 0; };
  #   gc.options                    = "--delete-older-than 30d";
  #   optimise.automatic            = true;
  #   settings                      = {
  #     extra-experimental-features = [ "nix-command" "flakes" ];
  #     experimental-features       = "nix-command flakes";
  #   };
  # };
  #

  brew-nix.enable = true;

  environment.systemPackages = pkgs.callPackage ./nix-config.pkgs.nix {};

  # find symlink of all apps here
  #"${outputs.darwinConfigurations.admins-MacBook-Pro.config.system.build.applications.outPath}/Applications"
}
