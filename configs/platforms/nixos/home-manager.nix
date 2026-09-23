{
    inputs
  , config
  , lib
  , pkgs
  , specialArgs
  , vars
  , ...
}:

let
  pubkeyPaths = {
    nas    = "${vars.userHomeDir}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/5ef1ef402650e42d997727607fafa2e5.pub";
    router = "${vars.userHomeDir}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/5ac39e8ef66a4ce5e516a135d229ae95.pub";
    github = "${vars.userHomeDir}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/dd13d0088ae44d603805c3d6ece7ac36.pub";
  };
in
{

home-manager.sharedModules       = [ inputs.nixvim.homeModules.nixvim ];
# home-manager.sharedModules       = [ inputs.nixvim.homeModules.nixvim  inputs.nix-search-tv.packages.x86_64-linux.default];
# home-manager.sharedModules       = [ inputs.nixvim.homeModules.nixvim inputs.nix-search-tv.packages.${pkgs.system}.default];
home-manager.useGlobalPkgs       = true;
home-manager.useUserPackages     = true;
home-manager.extraSpecialArgs    = specialArgs // { inherit inputs; };

home-manager.users."${vars.username}" = { config, vars, ... }: {
  home.packages = pkgs.callPackage ../shared/home-manager.packages.nix { inherit pkgs; };
  home.stateVersion  = "25.05"; # @@ DO NOT MODIFY @@
  programs      = import ../shared/home-manager.programs.nix  { inherit pkgs config vars lib; };
};

}
