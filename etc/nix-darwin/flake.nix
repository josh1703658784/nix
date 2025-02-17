{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
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
    nixcasks = {
      url = "github:jacekszymanski/nixcasks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
  };

  outputs = inputs@{ 
      self
    , nix-darwin
    , nixpkgs
    , brew-nix
    , brew-api
    , nixcasks
    , ... 
  }:
  let
    system = "aarch64-darwin";
    nixcasks = (inputs.nixcasks.output {
       osVersion = "sequoia";
    }).packages.${system};

    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      
      # overlay = final: prev: {
      #    unstable = import nixpkgs {
      #      inherit (prev) system;
      #      config.allowUnfree = true;
      #    };
      # };
      # system = "aarch64-darwin";


      nix.enable = false; # nix-determinate overrides this
      environment.systemPackages =
      [ pkgs.vim
        pkgs.git
      ];



      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      
      
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#admins-MacBook-Pro
    darwinConfigurations."admins-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      # pkgs = import nixpkgs {
      #   inherit system;
      #   config.packageOverrides = _: {
      #     inherit nixcasks;
      #   };
      # };
      modules = [ 
        configuration 
        brew-nix.darwinModules.default
        ./darwin.nix
      ];
    };
  };
}
