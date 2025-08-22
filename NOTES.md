[awesome nix](https://github.com/nix-community/awesome-nix)


# update nix
nix flake update

# options and package resources
* [nix packages search](https://search.nixos.org)

* [nix-darwin config options](https://nix-darwin.github.io/nix-darwin/manual/)

* [nix options](https://mynixos.com/options)

* [homebrew cask search](https://formulae.brew.sh/cask)

* [3rd party home-manager options search](https://home-manager-options.extranix.com)

# SAMPLE CONFIGS
https://github.com/dustinlyons/nixos-config
https://github.com/PaulGrandperrin/nix-systems
https://github.com/Misterio77/nix-starter-configs

# clean nix store
https://nixos.wiki/wiki/Cleaning_the_nix_store
https://nixos.wiki/wiki/Storage_optimization
https://matthewrhone.dev/nixos-package-guide#cleanup-old-packages-user-wide
```
$ nix-channel --update
$ nix-env -u --always
$ rm /nix/var/nix/gcroots/auto/*
$ nix-collect-garbage -d
```

# nix helper links
* [nix best practices](https://nix.dev/guides/best-practices)
* [nix pills](https://nixos.org/guides/nix-pills/02-install-on-your-running-system.html)

# commands
`nix flake metadata` will list of graph of inputs - this can be useful for configuring the `.follows` properly
[see also](https://discourse.nixos.org/t/recommendations-for-use-of-flakes-input-follows/17413/5)


# installing homebrew packages
## nixcasks
Attempts to nix-ify cask installation
https://github.com/jcszymansk/nixcasks
## brew-nix
Attempts to nix-ify cask installation
https://github.com/BatteredBunny/brew-nix
## mac-app-util
Attempts to nix-ify cask installation
This is one problemetic due to use of symlinks
https://github.com/hraban/mac-app-util
## nix-homebrew
Wraps `brew` for declarative cask management
B/c it relies on `brew` it isn't a "clean" solution but it is very reliable
https://github.com/zhaofengli/nix-homebrew


