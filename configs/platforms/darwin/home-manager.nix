{
    inputs
  , config
  , pkgs
  , specialArgs
  , vars
  , thisFlakePath
  , lib
  , ...
}:

let
  pubkeyPaths = {
    codeberg = "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/34f34cab85c3fb77d9c33d4dd85e40de.pub";
    # nas      = "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/6429b5655e234964c2505eccb9827cd6.pub";
    nas      = "~/.ssh/nas.pub";
    router   = "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/4885fd615d7919d6b615baa5b1306479.pub";
  };
  # thisFlakePath = "${vars.userDataVolume}/Developer/nix-configs/configs";
  vars' = vars // { inherit pubkeyPaths thisFlakePath; };
  extraSpecialArgs = specialArgs // { vars = vars'; };
in
{

home-manager.sharedModules       = [ inputs.nixvim.homeManagerModules.nixvim ];
home-manager.useGlobalPkgs       = true;
home-manager.useUserPackages     = true;
home-manager.extraSpecialArgs    = builtins.trace extraSpecialArgs.vars extraSpecialArgs;

home-manager.users."${vars.username}" = { config, vars, ... }: {
  home          = {
    packages      = pkgs.callPackage ./home-manager.packages.nix { inherit pkgs; };
    homeDirectory = builtins.trace vars vars.userHomeDir;
    stateVersion  = "25.05";
    file = {
      "mackup.cfg" = {
        enable = true;
        source = ./home.file/mackup.cfg;
        target = ".mackup.cfg";
      };
      "mackup" = {
        enable    = true;
        source    = ./home.file/mackup;
        recursive = true;
        target    = ".mackup";
      };
    };

    file."_DATA_".source = config.lib.file.mkOutOfStoreSymlink "/Volumes/_DATA_";
  };
  programs      = import ../shared/home-manager.programs.nix  { inherit pkgs config vars lib; };
  services      = import ../shared/home-manager.services.nix  { inherit pkgs config vars lib; };
};

}
