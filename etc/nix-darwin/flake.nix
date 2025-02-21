{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    mac-app-util.url = "github:hraban/mac-app-util";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # BatteredBunny/brew-nix
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
    };
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };

    # zhaofengli-wip/nix-homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs = inputs@{
      self
    , nix-darwin
    , nixpkgs
    , brew-nix
    , brew-api
    , home-manager
    , nixvim
    , mac-app-util
    , apple-fonts
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    # , homebrew-bundle
    , ...
  }:
  let
    system = "aarch64-darwin";
    username = "josh";
    hostname = "admins-MacBook-Pro";
    user-data-volume = "/Volumes/${username}-data";
    user-home-dir = "/Users/${username}";
    homebrew-volume = "/Volumes/nix-homebrew";
    homebrew-prefix = "${homebrew-volume}/opt/homebrew";
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#admins-MacBook-Pro
    darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      specialArgs = { # nix-darwin
        username = username;
        inputs = inputs;
        user-data-volume = user-data-volume;
        user-home-dir = user-home-dir;
        homebrew-prefix = homebrew-prefix;
        homebrew-cask = homebrew-cask;
        homebrew-volume = homebrew-volume;
      };
      modules = [
        ./configuration.nix
        mac-app-util.darwinModules.default

        brew-nix.darwinModules.default
        nixvim.nixDarwinModules.nixvim
        nix-homebrew.darwinModules.nix-homebrew
        # {
        #   nix-homebrew = {
        #     #@todo don't install at default location
        #     enable = true;
        #     mutableTaps = false;
        #     enableRosetta = false;
        #     taps = { "homebrew/homebrew-cask" = homebrew-cask; };
        #     user = username;
        #     prefixes = {
        #       "${homebrew-prefix}" = {
        #         enable = false;
        #         library = "${homebrew-prefix}/Library";
        #         taps = {
        #           "homebrew/homebrew-core" = homebrew-core;
        #           "homebrew/homebrew-cask" = homebrew-cask;
        #           "homebrew/homebrew-bundle" = homebrew-bundle;
        #         };
        #       };
        #     };
        #   };
        # }
        ./darwin.nix

        # nixvim.homeManagerModules.nixvim
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."${username}" = import ./home.nix;
          home-manager.extraSpecialArgs = {
            username = username;
            inputs = inputs;
            user-data-volume = user-data-volume;
          };
        }
      ];
    };
  };
}
