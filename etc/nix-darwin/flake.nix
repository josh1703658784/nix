{
  inputs = {
    nixpkgs.url               = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs-unstable.url      = "github:nixos/nixpkgs/nixos-unstable";
    nix-homebrew.url          = "github:zhaofengli/nix-homebrew";

    nix-darwin                = {
      url                       = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows    = "nixpkgs";
    };

    home-manager              = {
      url                       = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows    = "nixpkgs";
    };

    nixvim                    = {
      url                       = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows    = "nixpkgs";
    };

    homebrew-core             = {
      # https://github.com/zhaofengli/nix-homebrew
      url                       = "github:homebrew/homebrew-core";
      flake                     = false;
    };

    homebrew-cask             = {
      # https://github.com/zhaofengli/nix-homebrew
      url                       = "github:homebrew/homebrew-cask";
      flake                     = false;
    };

    homebrew-empty             = {
      # https://github.com/josh1703658784/homebrew-empty
      url                       = "github:josh1703658784/homebrew-empty";
      flake                     = false;
    };

    homebrew-legacy             = {
      # https://github.com/josh1703658784/homebrew-legacy
      url                       = "github:josh1703658784/homebrew-legacy";
      flake                     = false;
    };

    homebrew-bundle           = {
      # https://github.com/zhaofengli/nix-homebrew
      # https://github.com/zhaofengli/nix-homebrew/issues/9#issuecomment-1774684583
      url                       = "github:homebrew/homebrew-bundle";
      flake                     = false;
    };

    apple-fonts               = {
      # https://github.com/Lyndeno/apple-fonts.nix
      url                       = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows    = "nixpkgs";
    };

    discordo                  = {
      url                       = "github:ayn2op/discordo";
      inputs.nixpkgs.follows    = "nixpkgs";
    };

    nix-darwin-linking        = {
      # https://github.com/nix-darwin/nix-darwin/pull/1396#issuecomment-3150075769
      # https://github.com/dwt/nix-darwin/tree/application-linking-done-right
      url                       = "github:dwt/nix-darwin/application-linking-done-right";
      inputs.nixpkgs.follows    = "nixpkgs";
    };

    brew-nix                  = {
      # https://github.com/BatteredBunny/brew-nix
      url                       = "github:BatteredBunny/brew-nix";
      inputs.nix-darwin.follows = "nix-darwin";
      inputs.brew-api.follows   = "brew-api";
      inputs.nixpkgs.follows    = "nixpkgs";
    };

    brew-api                  = {
      # https://github.com/BatteredBunny/brew-api
      url                       = "github:BatteredBunny/brew-api";
      flake                     = false;
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
    , brew-nix
    # , nixcasks
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
        brew-nix.darwinModules.default
        nix-homebrew.darwinModules.nix-homebrew
        nixvim.nixDarwinModules.nixvim

        ./nix/nix-config.nix
        ./system/system-config.nix
        ./homebrew/brew.nix
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })

        { disabledModules = [ "system/applications.nix" ]; }
        "${inputs.nix-darwin-linking}/modules/system/applications.nix"

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
