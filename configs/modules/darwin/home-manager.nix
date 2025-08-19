{
    inputs
  , config
  , lib
  , pkgs
  , userDataVolume
  , userHomeDir
  , home-manager
  # , homeSpecialArgs
  , username
  # , nixvim
  , ...
}:

{

home-manager.sharedModules       = [ inputs.nixvim.homeManagerModules.nixvim ];
home-manager.useGlobalPkgs       = true;
home-manager.useUserPackages     = true;
home-manager.extraSpecialArgs    = { inherit userDataVolume userHomeDir; };

home-manager.users."${username}" = { userDataVolume, userHomeDir, ... }: {
  # home.file = { };
  home = {
    packages = pkgs.callPackage ./packages.nix { inherit pkgs; };
    homeDirectory = userHomeDir;
    stateVersion = "25.05";
  };
  programs = import ../shared/home-manager.programs.nix  { inherit pkgs userDataVolume; };
};

}
