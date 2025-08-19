let
  # Reuses the locked flake inputs.
  flakeLock = builtins.fromJSON (builtins.readFile ../flake.lock);
  # Gets the locked sources.
  src = builtins.fetchTree flakeLock.nodes.nix-test-runner.locked;
in
{ pkgs ? import ./nixpkgs.nix { }
  # Use last pinned crate2nix packages to build the test runner
  # so that it works even if we have broken stuff!
, tools ? pkgs.callPackage "${builtins.fetchTree flakeLock.nodes.crate2nix_stable.locked}/tools.nix" { }
}:
let
  dotbackup = tools.appliedCargoNix {
    name = "nix-test-runner";
    inherit src;
  };
in
dotbackup.rootCrate.build
