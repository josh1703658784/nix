{ self, nix-darwin, pkgs, ... }: {
  nix.enable = false; # nix-determinate overrides this

# nix-darwin.specialArgs.user = "josh";
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # environment.systemPackages = [
  #   pkgs.mkalias
  # ];
#
#   system.activationScripts.applications.text =
#   let
#     env = pkgs.buildEnv {
#       name = "system-applications";
#       paths = [ pkgs.mkalias ];
#       pathsToLink = "/Applications";
#     };
#   in
#     pkgs.lib.mkForce ''
#     (
#       #:echo has('clipboard') shellcheck enable=all
#       set -T # inherit DEBUG and RETURN trap for functions
#       set -C # prevent file overwrite by > &> <>
#       set -E # inherit -e
#       set -e # exit immediately on errors
#       set -u # exit on not assigned variables
#       set -o pipefail # exit on pipe failure
#       set -f # fully disable globbing, can be disabled as needed
#       # shopt -s failglob # fail when globbing fails
#       #set -x
#
#       # Set up applications.
#       echo 'setting up /Applications...' >&2
#       rm -rf '/Applications/Nix Apps'
#       mv '/Applications/Nix Apps' "/Applications/Nix Apps $(date +%s)"
#       mkdir -p '/Applications/Nix Apps'
#       # find "${env}/Applications" -maxdepth 1 -type l -exec readlink '{}' + |
#       # while read -r SRC; do
#       #   APP_NAME="$(basename "''${SRC}")"; readonly APP_NAME
#       #   echo "''${APP_NAME}"
#       #   echo "copying ''${SRC}" >&2
#       #   ${pkgs.mkalias}/bin/mkalias "''${SRC}" "/Applications/Nix Apps/''${APP_NAME}"
#       # done
#     )
#     '';
}
