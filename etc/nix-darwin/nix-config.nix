{ self, nix-darwin, pkgs, ... }: {
  nix.enable = false; # nix-determinate overrides this

# nix-darwin.specialArgs.user = "josh";
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nix.channel.enable = false;


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

  #environment.systemPackages = [
    #pkgs.mkalias
  # pkgs.iterm2
  # ];

  # find symlink of all apps here
  #"${outputs.darwinConfigurations.admins-MacBook-Pro.config.system.build.applications.outPath}/Applications"


  # # https://github.com/landakram/nix-config/blob/master/link-apps/default.nix
  # system.activationScripts.postActivation.text =
  # inputs@{ system }:
  # let
  #   appPath = "${system.build.applications.outPath}/Applications";
  #   env = pkgs.buildEnv {
  #     name = "system-applications";
  #     paths = [ pkgs.mkalias ];
  #     pathsToLink = "/Applications/Nix Apps";
  #   };
  # in
  #   pkgs.lib.mkForce ''
  #     readonly DEST_DIR='/Applications/Nix Apps [Aliases]'
  #     echo "Aliasing Apps to $DEST_DIR"
  #     mkdir -p "$DEST_DIR"
  #     find ${appPath}/Applications -maxdepth 1 -type l | while read f; do
  #       src="$(/usr/bin/stat -f%Y $f)"
  #       appname="$(basename $src)"
  #       dest_app=$DEST_DIR/$appname
  #       [ -f $dest_app ] && rm $dest_app
  #       mkalias "''${src}" "''${dest_app}"
  #     done
  #   '';




}
