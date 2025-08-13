{
  inputs = {
    apple-fonts.url      = "github:Lyndeno/apple-fonts.nix";
    discordo.url         = "github:ayn2op/discordo";
    home-manager.url     = "github:nix-community/home-manager";
    nix-darwin.url       = "github:LnL7/nix-darwin/master";
    nix-homebrew.url     = "github:zhaofengli/nix-homebrew";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url          = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixvim.url           = "github:nix-community/nixvim";

    homebrew-core = {
      # https://github.com/zhaofengli/nix-homebrew
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      # https://github.com/zhaofengli/nix-homebrew
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      # https://github.com/zhaofengli/nix-homebrew
      # https://github.com/zhaofengli/nix-homebrew/issues/9#issuecomment-1774684583
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = inputs@{
      self
    , nix-darwin
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , nixvim
    , apple-fonts
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    , homebrew-bundle
    , ...
  }:
  let
    system           = "aarch64-darwin";
    username         = "josh";
    config-name      = "mac-nix";
    user-data-volume = "/Volumes/${username}-data";
    user-home-dir    = "/Users/${username}";
    homebrew-prefix  = "${user-home-dir}/opt/homebrew";
    nix-config-dir   = "${user-data-volume}/Developer/nix-configs/etc/nix-darwin";
  in
  {
    darwinConfigurations."${config-name}" = nix-darwin.lib.darwinSystem {
      specialArgs = { # nix-darwin
        username         = username;
        inputs           = inputs;
        user-data-volume = user-data-volume;
        user-home-dir    = user-home-dir;
        homebrew-prefix  = homebrew-prefix;
        nix-config-dir   = nix-config-dir;
        config-name      = config-name;
        pkgs-unstable    = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      modules = [

        nix-homebrew.darwinModules.nix-homebrew
        ./nix-config.nix

        nixvim.nixDarwinModules.nixvim
        ./system-config.nix

        ./homebrew/brew.nix
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs       = true;
          home-manager.useUserPackages     = true;
          home-manager.users."${username}" = import ./home-manager/home.nix;
          home-manager.extraSpecialArgs    = {
            username         = username;
            inputs           = inputs;
            user-data-volume = user-data-volume;
            user-home-dir    = user-home-dir;
            homebrew-prefix  = homebrew-prefix;
          };
        }
      ];
    };
  };
}
