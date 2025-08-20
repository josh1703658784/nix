{
    inputs
  , config
  , lib
  , pkgs
  , userDataVolume
  , userHomeDir
  , home-manager
  , username
  , ...
}:

let
  pubkeyPaths = {
    codeberg = "${userHomeDir}/.ssh/codeberg-pubkey";
    deck     = "${userHomeDir}/.ssh/deck-pubkey";
    github   = "${userHomeDir}/.ssh/github-pubkey";
    gitea    = "${userHomeDir}/.ssh/gitea-pubkey";
    nas      = "${userHomeDir}/.ssh/nas-pubkey";
    router   = "${userHomeDir}/.ssh/router-pubkey";
  };
in
{

home-manager.sharedModules       = [ inputs.nixvim.homeManagerModules.nixvim ];
home-manager.useGlobalPkgs       = true;
home-manager.useUserPackages     = true;
home-manager.extraSpecialArgs    = { inherit userDataVolume userHomeDir pubkeyPaths; };

home-manager.users."${username}" = { userDataVolume, userHomeDir, pubkeyPaths, ... }: {
  home          = {
    packages      = pkgs.callPackage ./home-manager.packages.nix { inherit pkgs; };
    homeDirectory = userHomeDir;
    stateVersion  = "25.05";
    file = {
      "${pubkeyPaths.codeberg}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcPC4M2E6njMrhPCmUk+j4x6SVS14Qi1hS/o/U6ucRW";
      };
      "${pubkeyPaths.deck}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF4XlbsAyZeY24ArMNfUaQZNZaOv0U8X8W/gTDXyHDHS";
      };
      "${pubkeyPaths.github}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtUC70woyEkQoRrCWcOHE80Zm/AU1WnHpOFGpLYLz7a";
      };
      "${pubkeyPaths.gitea}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmZBYKHTjyeRpV+EBEXtQs3t4TKL49XNpfNE84dI0SH";
      };
      "${pubkeyPaths.nas}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHmYQW1Mzt5+T4CfqufZuO39txTHRWWvLgo0F2PvMvw1";
      };
      "${pubkeyPaths.router}" = {
        enable = true;
        executable = false;
        text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA90frwx2GUhavtkMF7yBw3xZAhTYkAKR7owjsmZtGSt";
      };
    };
  };
  programs      = import ../shared/home-manager.programs.nix  { inherit pkgs userDataVolume pubkeyPaths; };
};

}
