{
    inputs
  , config
  , lib
  , pkgs
  , specialArgs
  , vars
  , ...
}:


{
  imports = [
    ./system.nix
    ./home-manager.nix
  ];
}
