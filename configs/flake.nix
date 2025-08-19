{
  inputs = {
    nixpkgs.url               = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    # nixpkgs-unstable.url      = "github:nixos/nixpkgs/nixos-unstable";

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

    # flake-parts = {
    #   url = "github:hercules-ci/flake-parts";
    #   inputs.nixpkgs-lib.follows = "nixpkgs";
    # };

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

    homebrew-pinned             = {
      # https://github.com/josh1703658784/homebrew-pinned
      url                       = "github:josh1703658784/homebrew-pinned";
      flake                     = false;
    };

    homebrew-bundle           = {
      # https://github.com/zhaofengli/nix-homebrew
      # https://github.com/zhaofengli/nix-homebrew/issues/9#issuecomment-1774684583
      url                       = "github:homebrew/homebrew-bundle";
      flake                     = false;
    };

    homebrew-empty             = {
      # https://github.com/josh1703658784/homebrew-empty
      url                       = "github:josh1703658784/homebrew-empty";
      flake                     = false;
    };

    ###############################
    # NIXIFIED HOMEBREW PACKAGES
    ###############################
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


    ###############################
    # MISC \_/-\_/-\_/-\_/-\_/-\_/-
    ###############################
    nixvim                    = {
      # https://github.com/nix-community/nixvim
      url                       = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows    = "nixpkgs";
    };

    crate2nix = {
      url = "github:nix-community/crate2nix/0.12.0";
      # url = "github:nix-community/crate2nix";
    };

    nix-test-runner = {
      url = "github:stoeffel/nix-test-runner";
      flake = false;
    };

    # stylix = {
    #   url = "github:nix-community/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # apple-fonts               = {
    #   # https://github.com/Lyndeno/apple-fonts.nix
    #   url                       = "github:Lyndeno/apple-fonts.nix";
    #   inputs.nixpkgs.follows    = "nixpkgs";
    # };

    # discordo                  = {
    #   # https://github.com/ayn2op/discordo
    #   url                       = "github:ayn2op/discordo";
    #   inputs.nixpkgs.follows    = "nixpkgs";
    # };

    # nix-darwin-linking        = {
    #   # copies GUI apps from Nix store to /Application/Nix Apps instead of default symlinking
    #   # https://github.com/nix-darwin/nix-darwin/pull/1396#issuecomment-3150075769
    #   # https://github.com/dwt/nix-darwin/tree/application-linking-done-right
    #   url                       = "github:dwt/nix-darwin/application-linking-done-right";
    #   inputs.nixpkgs.follows    = "nixpkgs";
    # };

    # plist-manager = {
    #   # https://github.com/z0al/plist-manager
    #   url = "github:z0al/plist-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.nix-darwin.follows = "nix-darwin";
    # };
  };

  outputs = inputs@{
      self
    , nixpkgs
    , home-manager
    , brew-nix
    , nixvim
    , nix-homebrew
    , nix-darwin
    , crate2nix
    , ...
  }:
  let
    configName     = "mac-nix";
    username       = "josh";
    primaryUser    = "josh";
    system         = "aarch64-darwin";
    userDataVolume = "/Volumes/_DATA_";
    homebrewPrefix = "${userHomeDir}/opt/homebrew";
    nixConfigDir   = "${userDataVolume}/Developer/nix-configs/etc/nix-darwin";
    userHomeDir    = "/Users/${username}";

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
    darwinConfigurations."${configName}" = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit
        inputs
        configName
        username
        userHomeDir
        userDataVolume
        primaryUser
        system
        ;
      };

      modules = [
        nix-homebrew.darwinModules.nix-homebrew
        brew-nix.darwinModules.default
        home-manager.darwinModules.home-manager

        ./hosts/darwin
      ];
    };

    nixosConfigurations = {
      modules = [
        ./modules/orbstack/configuration.orbstack.nix
      ];
    };
  };
}
