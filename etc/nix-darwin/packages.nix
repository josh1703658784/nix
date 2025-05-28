
{
    inputs
  , config
  , pkgs
  , pkgs-unstable
  , brew-nix
  , username
  , user-home-dir
  , homebrew-prefix
  , nix-homebrew
  , homebrew-volume
  , ...
}:

{

# brew-nix.enable = true;
# brew-nix.enable = true;
environment.systemPackages = with pkgs-unstable; [
  mas
  bat
  watch
  nix-search-cli

  # nixpkgs gui
  # pkgs.iterm2
  # pkgs.appcleaner
  # pkgs.iina
  # pkgs.net-news-wire
  # pkgs.qbittorrent
  # pkgs.signal-desktop
  # pkgs.syncthing
  # pkgs.xld
  # pkgs.utm

  # pkgs.beeper
  # pkgs.firefox
  # pkgs.yubioath-flutter # nixpkgs does not have darwin support

  # # brewCasks gui
  # brewCasks.arq
  # brewCasks.beeper # ! available in system packages
  # brewCasks.boop
  # brewCasks.cocoapacketanalyzer
  # brewCasks.coteditor
  # brewCasks.devonthink
  # brewCasks.dhs
  # brewCasks.exactscan
  # # brewCasks.firefox # ! available in system packages
  # brewCasks.fork
  # brewCasks.hazel
  # brewCasks.kextviewr
  # brewCasks.knockknock
  # # brewCasks.little-snitch           # ! /Applications required
  # brewCasks.marta
  # brewCasks.meta
  # brewCasks.nova
  # brewCasks.orbstack
  # brewCasks.orion
  # brewCasks.steermouse              # ! /Applications required
  # # brewCasks.swinsian                # ! can't update to beta
  # brewCasks.textual
];


}




# yadm
  # gtrash # trash
  # apple-sdk
  # pkgs.darwin.xcode
  #apple-sdk_15
  # pkgs.darwin.xcode
  # pkgs.darwin.apple_sdk.frameworks



  # #brewCasks.

  # brewCasks.blockblock              # ! install required
  # brewCasks.busycal                 # ! weird collisions
  # brewCasks.hiddenbar
  # brewCasks.neo-network-utility     # ! cannot undmg non-hfs
  # brewCasks.reikey                  # ! install required
  # brewCasks.sf-symbols              # ! install required
  # brewCasks.tor-browser             # ! arm + darwin not available on nixpkgs
  # brewCasks.yubico-yubikey-manager  # ! install required

  # overrides
  # (brewCasks.busycal.overrideAttrs (o: {
  #   src = pkgs.fetchurl {
  #     url = (builtins.replaceStrings [".zip"] [".dmg" ] o.src.url);
  #     # sha256 = "sha256-4reNiGyU2Woc+4OIVhQexVZYqdPeyg3Ff3qtkA8ZE4E=";
  #     hash = "sha256-4reNiGyU2Woc+4OIVhQexVZYqdPeyg3Ff3qtkA8ZE4E=";
  #   };
  #   unpackPhase = "undmg $src";
  # }))
  # (brewCasks.alfred.overrideAttrs (o: {
  #   nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.gnutar ];
  #   unpackPhase = "tar -xvzf $src";
  # }))
  # (brewCasks.imageoptim.overrideAttrs (o: {
  #   nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.gnutar ];
  #   unpackPhase = "tar -xvf $src";
  # }))
  # (brewCasks.neo-network-utility.overrideAttrs (o: {
  #   nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.gnutar ];
  #   unpackPhase = ''
  #   unzip -c "''${src}"
  #   dmgsrc="$(echo "''${src}" | sed 's/\.zip$//g')"
  #   undmg "''${dmgsrc}"
  #   # echo
  #   '';
  #   # url = (builtins.replaceStrings [".zip"] [""] o.src.url);
  # }))
  # (brewCasks.powerphotos.overrideAttrs (o: {
  #   src = pkgs.fetchurl {
  #     url = builtins.head o.src.urls;
  #     hash = "sha256-YqCtMiim1B48XzKJcnJ5yUI7qVUquY6FTltF+Jf6Y/A=";
  #   };
  # }))
  # (brewCasks.suspicious-package.overrideAttrs (o: {
  #   src = pkgs.fetchurl {
  #     url = builtins.head o.src.urls;
  #     hash = "sha256-//iL7BRdox+KA1CJnGttUQiUfskuBeMGrf1YUNt/m90=";
  #   };
  # }))

  # (brewCasks.PACKAGE.overrideAttrs (o: {
  #   src = pkgs.fetchurl {
  #     url = builtins.head o.src.urls;
  #     hash = lib.fakeHash; # Replace me with real hash after building once
  #   };
  # }))
