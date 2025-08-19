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

    crate2nix_stable = {
      url = "github:nix-community/crate2nix/0.12.0";
    };

    nix-test-runner = {
      url = "github:stoeffel/nix-test-runner";
      flake = false;
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    , stylix
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
    homeSpecialArgs = {
      inherit
      inputs
      userDataVolume
      userHomeDir
      ;
    };

    supportedSystems = [
      # "x86_64-linux"
      # "aarch64-linux"
      "aarch64-darwin"
    ];
    forEachSupportedSystem =
    f:
    nixpkgs.lib.genAttrs supportedSystems (
      system:
      f {
        pkgs = import nixpkgs { inherit system; };
      }
    );
  in
  {
    darwinConfigurations."${configName}" = nix-darwin.lib.darwinSystem {
      inherit system specialArgs;
      modules = [
        # manage nix darwin linking/copying gui packages
        { disabledModules = [ "system/applications.nix" ]; }
        ./system/applications.nix

        # manage homebrew binary
        nix-homebrew.darwinModules.nix-homebrew

        # manage nix homebrew wrapper
        brew-nix.darwinModules.default

        stylix.darwinModules.stylix

        ./modules/darwin/nix.nix
        ./modules/darwin/system.nix
        ./modules/darwin/macos.nix
        ./modules/darwin/homebrew.nix
        ./modules/darwin/apps.nix

        # home manager
        home-manager.darwinModules.home-manager
        {
          home-manager.sharedModules       = [ nixvim.homeManagerModules.nixvim ];
          home-manager.useGlobalPkgs       = true;
          home-manager.useUserPackages     = true;
          home-manager.users."${username}" = import ./modules/home-manager/home.nix;
          home-manager.extraSpecialArgs    = homeSpecialArgs;
        }
      ];
    };


    customPackages = (
      { pkgs }:
      {
        cargo = pkgs.callPackage ./packages/Cargo.nix { };
    #     nix-tester-runner = pkgs.callPackage ./packages/nix-test-runner.nix { };
        # dotbackup = pkgs.callPackage ./packages/nix-test-runner.nix { };
        # grafana-ntfy = pkgs.callPackage ./packages/grafana-ntfy.nix { };
      }
    );

  };
}
