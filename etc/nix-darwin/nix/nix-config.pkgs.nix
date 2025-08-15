{ pkgs }:
with pkgs;
[
  # pkgs.brewCasks.

  # pkgs.brewCasks.blockblock           # INSTALLER + unpacker produced multiple directories
  # pkgs.brewCasks.busycal              # INSTALLER + Error opening xar archive
  # pkgs.brewCasks.busycontacts         # INSTALLER + Error opening xar archive
  # pkgs.brewCasks.cocoapacketanalyzer  # ERROR: noBrokenSymlinks: the symlink ... points to a missing target
  # pkgs.brewCasks.devonthink           # dt4, want dt3
  # pkgs.brewCasks.little-snitch        # does not install to /Applications
  # pkgs.brewCasks.mullvad-browser      # Headers Error
  # pkgs.brewCasks.sf-symbols           # Error opening xar archive
  # pkgs.brewCasks.swinsian             # not beta
  # pkgs.brewCasks.tailscale-app        # gzip: Distribution.pkg/Payload: not in gzip format
  # pkgs.brewCasks.tor-browser          # Headers Error (on opening dmg)

  (pkgs.brewCasks.alfred.overrideAttrs (o: {
    nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.gnutar ];
    unpackPhase = "tar -xvzf $src";
  }))


  # (pkgs.brewCasks.devonthink.overrideAttrs (oldAttrs: {
  #   # https://libmedium.stonecat-shark.ts.net/@dallasclark/install-a-previous-version-of-an-application-with-homebrew-cask-9d3b8d288db6
  #   src = pkgs.fetchurl {
  #     url = "https://download.devontechnologies.com/download/devonthink/3.9.14/DEVONthink_3.dmg.zip";
  #     hash = "sha256-IxpWpdl5cVH6CrxN9iJU4zDrniqyTudE5NPvhsUpwH8=";
  #   };
  # }))

  (pkgs.brewCasks.hookmark.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = builtins.head oldAttrs.src.urls;
      hash = "sha256-Swfi85wtbeK/VjGwn58gQsr0CqbngrBmpmEeFGH5ilE=";
      curlOptsList = ["-A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Safari/605.1.15'"];
    };
  }))

  (pkgs.brewCasks.imageoptim.overrideAttrs (o: {
    nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.gnutar ];
    unpackPhase = "tar -xf $src";
  }))

  (pkgs.brewCasks.powerphotos.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = builtins.head oldAttrs.src.urls;
      hash = "sha256-7yMQeopRbT0XNAJQffF/ncRyszAhaB6hSC/cGvjIrGY=";
    };
  }))

  (pkgs.brewCasks.suspicious-package.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = builtins.head oldAttrs.src.urls;
      hash = "sha256-//iL7BRdox+KA1CJnGttUQiUfskuBeMGrf1YUNt/m90=";
    };
  }))

  (pkgs.brewCasks.yate.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = builtins.head oldAttrs.src.urls;
      hash = "sha256-yJaxMGfq/ogWimrjUrAsHPAP6F5RrPRE41BZsP9LHAY=";
    };
  }))

  pkgs.appcleaner
  pkgs.brewCasks."kaleidoscope@3"
  pkgs.brewCasks.arq
  pkgs.brewCasks.boop
  pkgs.brewCasks.coteditor
  pkgs.brewCasks.dhs
  pkgs.brewCasks.exactscan
  pkgs.brewCasks.firefox
  pkgs.brewCasks.fork
  pkgs.brewCasks.halloy
  pkgs.brewCasks.hazel
  pkgs.brewCasks.jordanbaird-ice
  pkgs.brewCasks.kextviewr
  pkgs.brewCasks.knockknock
  pkgs.brewCasks.macpass
  pkgs.brewCasks.marta
  pkgs.brewCasks.meta
  pkgs.brewCasks.monodraw
  pkgs.brewCasks.mp3tag
  pkgs.brewCasks.netiquette
  pkgs.brewCasks.orion
  pkgs.brewCasks.signal
  pkgs.brewCasks.steermouse
  pkgs.brewCasks.syncthing-app
  pkgs.brewCasks.taskexplorer
  pkgs.brewCasks.textual
  pkgs.brewCasks.thingsmacsandboxhelper
  pkgs.brewCasks.yubico-authenticator
  pkgs.iina
  pkgs.iterm2
  pkgs.keepassxc
  pkgs.net-news-wire
  pkgs.qbittorrent
  pkgs.xld

]
