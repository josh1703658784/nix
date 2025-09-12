{
  inputs = {
    nixpkgs.url               = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    # nixpkgs-unstable.url      = "github:nixos/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR/26af345a615eb8739a0ee9f98822e8b11a188821";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin                = {
      # https://github.com/nix-darwin/nix-darwin
      url                       = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows    = "nixpkgs";
    };

    home-manager              = {
      # https://github.com/nix-community/home-manager
      url                       = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows    = "nixpkgs";
    };

    ###############################
    ## HOMEBREW \_/-\_/-\_/-\_/-\_/
    ###############################
    # https://github.com/zhaofengli/nix-homebrew
    nix-homebrew.url          = "github:zhaofengli/nix-homebrew";

    homebrew-cask             = {
      # https://github.com/zhaofengli/nix-homebrew
      url                       = "github:homebrew/homebrew-cask";
      flake                     = false;
    };

    homebrew-bundle           = {
      # https://github.com/zhaofengli/nix-homebrew
      # https://github.com/zhaofengli/nix-homebrew/issues/9#issuecomment-1774684583
      url                       = "github:homebrew/homebrew-bundle";
      flake                     = false;
    };

    ###############################
    # MISC \_/-\_/-\_/-\_/-\_/-\_/-
    ###############################
    nixvim                    = {
      # https://github.com/nix-community/nixvim
      url                       = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows    = "nixpkgs";
    };

  };

  outputs = inputs@{
      self
    , nixpkgs
    , home-manager
    , nixvim
    , nix-homebrew
    , nix-darwin
    , nur
    , ...
  }:
  let
    configName     = "mac-nix";
    username       = "josh";
    primaryUser    = "josh";
    homebrewUser   = "admin";
    system         = "aarch64-darwin";
    userDataVolume = "/Volumes/_DATA_";
    homebrewPrefix = "${userHomeDir}/opt/homebrew";
    nixConfigDir   = "${userDataVolume}/Developer/nix-configs/etc/nix-darwin";
    userHomeDir    = "/Users/${username}";
    # thisFlakePath = "${userDataVolume}/Developer/nix-configs/configs";

    supportedSystems = [
      # "x86_64-linux"
      # "aarch64-linux"
      "aarch64-darwin"
    ];
    # forEachSupportedSystem =
    # f:
    # nixpkgs.lib.genAttrs supportedSystems (
    #   system:
    #   f {
    #     pkgs = import nixpkgs { inherit system; };
    #   }
    # );
  in
  {
    darwinConfigurations = {
      mac-nix = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs system;
          vars = {
            inherit
            configName
            username
            userHomeDir
            userDataVolume
            primaryUser
            homebrewUser;
          };
        };

        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          nur.modules.darwin.default
          ./hosts/darwin
        ];
      };
    };

    nixosConfigurations = {
      orbstack = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
          vars = {
            inherit
            configName
            username
            userHomeDir
            userDataVolume
            primaryUser
            homebrewUser;
          };
        };
        # specialArgs = {inherit inputs username userHomeDir;};
        system = "aarch64-linux";
        # system.stateVersion = "25.05";
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/orbstack
    #       # > Our main nixos configuration file <
          # ./nixos/configuration.nix
          # ./modules/orbstack/configuration.orbstack.nix
        ];
      };
    };
  };
}
