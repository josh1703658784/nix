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
    codeberg = "${specialArgs.vars.userHomeDir}/.ssh/codeberg-pubkey";
    deck     = "${vars.userHomeDir}/.ssh/deck-pubkey";
    github   = "${vars.userHomeDir}/.ssh/github-pubkey";
    gitea    = "${vars.userHomeDir}/.ssh/gitea-pubkey";
    nas      = "${vars.userHomeDir}/.ssh/nas-pubkey";
    router   = "${vars.userHomeDir}/.ssh/router-pubkey";
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
      "${vars.pubkeyPaths.codeberg}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcPC4M2E6njMrhPCmUk+j4x6SVS14Qi1hS/o/U6ucRW";
      };
      "${vars.pubkeyPaths.deck}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF4XlbsAyZeY24ArMNfUaQZNZaOv0U8X8W/gTDXyHDHS";
      };
      "${vars.pubkeyPaths.github}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtUC70woyEkQoRrCWcOHE80Zm/AU1WnHpOFGpLYLz7a";
      };
      "${vars.pubkeyPaths.gitea}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmZBYKHTjyeRpV+EBEXtQs3t4TKL49XNpfNE84dI0SH";
      };
      "${vars.pubkeyPaths.nas}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmYQW1Mzt5+T4CfqufZuO39txTHRWWvLgo0F2PvMvw1";
      };
      "${vars.pubkeyPaths.router}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA90frwx2GUhavtkMF7yBw3xZAhTYkAKR7owjsmZtGSt";
      };
    };

    file."_DATA_".source = config.lib.file.mkOutOfStoreSymlink "/Volumes/_DATA_";
  };
  programs      = import ../shared/home-manager.programs.nix  { inherit pkgs config vars lib; };
  services      = import ../shared/home-manager.services.nix  { inherit pkgs config vars lib; };
};

}
