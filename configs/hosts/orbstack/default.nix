{
    system
  , config
  , vars
  , ...
}:


{

  imports = [
    ../../platforms/nixos/configuration.nix
    ../../platforms/nixos/home-manager.nix
  ];

  system.stateVersion = "25.05";

}
