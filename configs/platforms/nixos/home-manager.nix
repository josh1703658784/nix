{
    inputs
  , config
  , lib
  , pkgs
  , specialArgs
  # , userDataVolume
  # , userHomeDir
  # , home-manager
  # , username
  , vars
  , ...
}:

let
  pubkeyPaths = {
    codeberg = "${specialArgs.vars.userHomeDir}/.ssh/codeberg-pubkey";
    deck     = "${vars.userHomeDir}/.ssh/deck-pubkey";
    github   = "${vars.userHomeDir}/.ssh/github-pubkey";
    gitea    = "${vars.userHomeDir}/.ssh/gitea-pubkey";
    nas      = "${vars.userHomeDir}/.ssh/nas-pubkey";
    router   = "${vars.userHomeDir}/.ssh/router-pubkey";
  };
  # thisFlakePath = "${vars.userDataVolume}/Developer/nix-configs/configs";
  vars' = vars // { inherit pubkeyPaths; };
  extraSpecialArgs = specialArgs // { vars = vars'; };
in
{

home-manager.sharedModules       = [ inputs.nixvim.homeManagerModules.nixvim ];
home-manager.useGlobalPkgs       = true;
home-manager.useUserPackages     = true;
home-manager.extraSpecialArgs    = builtins.trace extraSpecialArgs.vars extraSpecialArgs;

home-manager.users."${vars.username}" = { config, vars, ... }: {
  # home.file                                  = { };
  home          = {
    packages      = pkgs.callPackage ../shared/home-manager.packages.nix { inherit pkgs; };
    # homeDirectory = lib.mkForce userHomeDir;
    stateVersion  = "25.05";
  };
  programs      = import ../shared/home-manager.programs.nix  { inherit pkgs config vars lib; };
};

}
