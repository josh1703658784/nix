{
  pkgs
}:

{

  # devonthink = (pkgs.brewCasks.devonthink.overrideAttrs (o: {
  #   # url = "https://download.devontechnologies.com/download/devonthink/3.9.14/DEVONthink_3.dmg.zip";
  #   # src.urls = ["https://download.devontechnologies.com/download/devonthink/3.9.14/DEVONthink_3.dmg.zip"];
  #   unpackPhase = "unzip $src; 7zz x 'DEVONthink_3.dmg'; mv 'DEVONthink 3/DEVONthink 3.app' .";
  #   sourceRoot = "DEVONthink 3.app";
  #   version = "3.9.14";
  #   src = pkgs.fetchurl {
  #     url = "https://download.devontechnologies.com/download/devonthink/3.9.14/DEVONthink_3.dmg.zip";
  #     hash = "sha256-IxpWpdl5cVH6CrxN9iJU4zDrniqyTudE5NPvhsUpwH8=";
  #     name = "DEVONthink 3.app.zip";
  #   };
  # }));

  alfred = (pkgs.brewCasks.alfred.overrideAttrs (o: {
    nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.gnutar ];
    unpackPhase = "tar -xvzf $src";
  }));

  busycontacts = (pkgs.brewCasks.busycontacts.overrideAttrs (o: {
    # https://ao.stonecat-shark.ts.net/questions/11298855/how-to-unpack-and-pack-pkg-file
    nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.xar pkgs.gzip pkgs.cpio ];
    unpackPhase = "unzip $src; xar -xf 'BusyContacts Installer.pkg'; cat BusyContacts.pkg/Payload | gunzip -dc | cpio -i";
    src = pkgs.fetchurl {
      url = builtins.head o.src.urls;
      hash = "sha256-MEe/gIon8i7NHAKLTAOfmQECI/W8XsjaLP76B5cBeQg=";
    };
  }));

  busycal = (pkgs.brewCasks.busycal.overrideAttrs (o: {
    # https://ao.stonecat-shark.ts.net/questions/11298855/how-to-unpack-and-pack-pkg-file
    nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.xar pkgs.gzip pkgs.cpio ];
    unpackPhase = "unzip $src; xar -xf 'BusyCal Installer.pkg'; cat BusyCal.pkg/Payload | gunzip -dc | cpio -i";
    src = pkgs.fetchurl {
      url = builtins.head o.src.urls;
      hash = "sha256-UzSxuHaDRtIt/6yUd1Y6gYsEKfZRw8hExSdCbAOPppA=";
    };
  }));

  cocoapacketanalyzer = (pkgs.brewCasks.cocoapacketanalyzer.overrideAttrs (o: {
    postPatch = "unlink ./Contents/Frameworks/Sparkle.framework/XPCServices";
  }));

  hookmark = (pkgs.brewCasks.hookmark.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = builtins.head oldAttrs.src.urls;
      hash = "sha256-Swfi85wtbeK/VjGwn58gQsr0CqbngrBmpmEeFGH5ilE=";
      curlOptsList = ["-A 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Safari/605.1.15'"];
    };
  }));

  imageoptim = (pkgs.brewCasks.imageoptim.overrideAttrs (o: {
    nativeBuildInputs = o.nativeBuildInputs ++ [ pkgs.gnutar ];
    unpackPhase = "tar -xf $src";
  }));

  mullvad-browser = (pkgs.brewCasks.mullvad-browser.overrideAttrs (o: {
    unpackPhase = o.unpackPhase + "mv 'Mullvad Browser/Mullvad Browser.app' .";
  }));

  powerphotos = (pkgs.brewCasks.powerphotos.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = builtins.head oldAttrs.src.urls;
      hash = "sha256-budnnAQODN7wvxDfNYl/NO6fS50LO0b4/reIE7+oxKw=";
    };
  }));

  suspicious-package = (pkgs.brewCasks.suspicious-package.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = builtins.head oldAttrs.src.urls;
      hash = "sha256-SJcXqQR/di3T8K3uNKv00QkLsmDGJNU9NQEIpDSqYJM=";
    };
  }));

  tor-browser = (pkgs.brewCasks.tor-browser.overrideAttrs (o: {
    unpackPhase = o.unpackPhase + "mv 'Tor Browser/Tor Browser.app' .";
  }));

  yate = (pkgs.brewCasks.yate.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = builtins.head oldAttrs.src.urls;
      hash = "sha256-yJaxMGfq/ogWimrjUrAsHPAP6F5RrPRE41BZsP9LHAY=";
    };
  }));

}
