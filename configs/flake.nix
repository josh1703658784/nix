{
  inputs = {
    nixpkgs.url  = "github:NixOS/nixpkgs/nixos-26.05";
    nixvim.url   = "github:nix-community/nixvim/nixos-26.05"; # https://github.com/nix-community/nixvim

    nix-search-tv         = { # https://github.com/3timeslazy/nix-search-tv
      url                 = "github:MarSoft/nix-search-tv/fix-homemanager";
    };
    home-manager              = { # https://github.com/nix-community/home-manager
      url                    = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
      self
    , nixpkgs
    , home-manager
    , nixvim
    , nix-search-tv
    , ...
  }:
  let
    vars = {
      configName     = "macbook";
      username       = "josh";
      userHomeDir    = "/Users/${vars.username}";
      userDataVolume = "/Volumes/_DATA_";
    };
  in
  {

    nixosConfigurations = {
      "nix" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs vars;
        };
        system = "aarch64-linux";
        modules = [
          {
            environment.systemPackages = [
              inputs.nix-search-tv.packages.x86_64-linux.default
              # inputs.nix-search-tv.packages.${pkgs.system}.default
              # inputs.nix-search-tv.packages.${stdenv.hostPlatform.system}.default
            ];
          }
          home-manager.nixosModules.home-manager
          ./hosts/orbstack
        ];
      };
    };
  };
}
