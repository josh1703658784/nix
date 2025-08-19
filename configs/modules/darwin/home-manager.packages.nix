{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/home-manager.packages.nix { inherit pkgs; };
in

shared-packages ++ [
  chezmoi
  dockutil # Manage icons in the dock
]
