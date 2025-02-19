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
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
    };
    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
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
    , ...
  }:
  let
    system = "aarch64-darwin";
    username = "josh";
    hostname = "admins-MacBook-Pro";
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#admins-MacBook-Pro
    darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      specialArgs = { # nix-darwin
        username = username;
        inputs = inputs;
      };
      modules = [
        ./configuration.nix
        mac-app-util.darwinModules.default

        # mac-app-util.darwinModules.default
        brew-nix.darwinModules.default
        nixvim.nixDarwinModules.nixvim
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
          };
        }
      ];
    };
  };
}
