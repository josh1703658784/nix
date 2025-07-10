# My NixOS + Orbstack configuration
# /etc/nixos/configuration.nix in the VM imports this file at
# ${HOME}/etc/nixos/configuration.nix on host
#
# not much to see here at the moment, or maybe ever
#
# (+) everything I like about macos
# (+) everything I like about linux
# (+) host stays pristine
# (+) while also having great host integration [orbstack]
# (+) extremely light on resources [orbstack]
# (+) easy to manage configuration [nix]
# (+) easy to recreate environment [nix]
# (-) Nix documentation leaves a lot to be desired


#nixos options: https://search.nixos.org/options?channel=24.05
# home manager configs: https://home-manager-options.extranix.com

{ lib, config, pkgs, modulesPath, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    ref = "nixos-24.11";
  });
in
{
  imports =
    [
      #<home-manager/nixos>
      (import "${home-manager}/nixos")
      # nixvim for home-manager
      # (nixvim.homeManagerModules.nixvim)
    ];
    # nix.extraOptions = ''
    #     extra-substituters = https://devenv.cachix.org
    #     extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    # '';

#   nixpkgs.overlays = [ (final: prev: {
#         trashy = prev.trashy.overrideAttrs (oldAttrs: rec {
#           pname = "trashy";
#           version = "unstable-2024-01-19";
#
#           src = prev.fetchFromGitHub {
#             owner = "oberblastmeister";
#             repo = "trashy";
#             rev = "7c48827e55bca5a3188d3de44afda3028837b34b";
#             sha256 = "sha256-1pxmeXUkgAITouO0mdW6DgZR6+ai2dax2S4hV9jcJLM=";
#           };
#
#           # I don't really know what this does I just changed the command name from the existing package
#           # postInstall = pkgs.lib.optionalString (prev.stdenv.buildPlatform.canExecute pkgs.stdenv.hostPlatform) ''
#           postInstall = prev.lib.optionalString (prev.stdenv.buildPlatform.canExecute prev.stdenv.hostPlatform) ''
#             installShellCompletion --cmd trashy \
#               --bash <($out/bin/trashy completions bash) \
#               --fish <($out/bin/trashy completions fish) \
#               --zsh <($out/bin/trashy completions zsh) \
#           '';
#           # postInstall = prev.lib.optionalString (prev.stdenv.buildPlatform.canExecute prev.stdenv.hostPlatform) '';
#           # postInstall = prev.lib.optionalString (prev.stdenv.buildPlatform.canExecute prev.stdenv.hostPlatform) '';
#
#           cargoDeps = oldAttrs.cargoDeps.overrideAttrs (prev.lib.const {
#             name = "${pname}-vendor.tar.gz";
#             inherit src;
#             outputHash = "sha256-2QITAwh2Gpp+9JtJG77hcXZ5zhxwNztAtdfLmPH4J3Y=";
#           });
#         });
#       }
#   ) ];

  networking.hostName = lib.mkForce "xenon";
  environment.systemPackages = [
    pkgs.zsh
    pkgs.tailscale
  ];
  programs.zsh.enable = true; # https://nixos.wiki/wiki/Command_Shell
  users.defaultUserShell = pkgs.zsh;

  services.tailscale.enable = true;
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "jxs1161"];

  home-manager.useUserPackages = true;
  home-manager.users.jxs1161 = { pkgs, ... }: {
    home.sessionPath = [
      "\$\{HOME\}/bin"
      "\$\{HOME\}/opt/bin"
    ];

    nixpkgs.config.allowUnfree = true; #terraform

    imports = [ nixvim.homeManagerModules.nixvim ];

    home.packages = [
      pkgs.ack
      pkgs.conceal
      pkgs.docker-client
      pkgs.docker-compose
      pkgs.dockerfile-language-server-nodejs
      # pkgs.git
      pkgs.go
      pkgs.trashy
      pkgs.skim
      pkgs.jq
      pkgs.inetutils
      pkgs.nix-search-cli
      pkgs.nodejs
      pkgs.openssh
      pkgs.postgresql
      pkgs.python3
      pkgs.tailspin
      pkgs.shellcheck
      pkgs.shfmt
      pkgs.sipcalc
      pkgs.sqlite
      pkgs.textql
      pkgs.terraform-ls
      # pkgs.terraform
      # pkgs.terragrunt
      # pkgs.bash
      # pkgs.hcledit
      pkgs.shellcheck
      pkgs.yaml-language-server
      # pkgs.terraformer
      # pkgs.devenv
      pkgs.devbox

    ];
    # programs.neovim.enable = true;
    programs.ssh.enable = true;
    programs.bash.enable = false;
    programs.home-manager.enable = true;
    programs.nnn.enable = true;
    programs.tmux.enable = true;
    programs.zsh.enable = true;
    programs.starship.enable = true;
    programs.skim.enable = true; # fzf inspired
    programs.git.enable = true;
    programs.direnv.enable = true;
    programs.nixvim.enable = true;

    programs.skim = {
      enableZshIntegration = true;
    };

    programs.git = {
      diff-so-fancy.enable = true;
	    ignores = [ ".secret" ".secrets"];
      userEmail = "jxs1161@yum.com";
      userName = "jxs1161";
      extraConfig = {
        push = {
          autoSetupRemote = true;
        };
      };
    };

    programs.direnv = {
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };



    programs.tmux = {
      clock24 = true;
      extraConfig = ''
	      set-option -g set-titles on
        set-option -g set-titles-string "#{session_name} - #{host}"
      '';
    };
    programs.zsh = {
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      dirHashes = {
        homelab = "/Volumes/Data/Developer/homelab-docker";
        dev = "/Volumes/Data/Developer";
        home = "/Users/jxs1161";
        "_" = "/Users/jxs1161";
      };
      plugins = [{
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }];
      shellAliases = {
        ll = "ls -la";
        nix-edit = "sudo nvim /etc/nixos/configuration.nix";
        nix-reload = "sudo nixos-rebuild switch";
        d = "docker";
        dc = "docker-compose";
        g = "git";
        ts = "tailscale";
        dcu = "docker compose up -d";
        dcd = "docker compose down";
        ns = "nix-shell";
        dci = "docker-compose-inspect";
        dcl = "docker-compose-log-colorize";
        dcul = "docker-compose-up-d-log-colorize";
        dce = "docker-compose exec";
        highlight = "tspin";
        tess = "less-tspin";
        tless = "less-tspin";
        tat = "cat-tspin";
        tcat = "cat-tspin";
        tf = "terraform";
        tg = "terragrunt";
        tfr = "terraformer";
      };
      initExtra = ''
        reminder(){
          local -r uuid="''${1}"
          local -r url='shortcuts://x-callback-url/run-shortcut?name=open-reminder&input=text&text='
          sudo open "''${url}''${uuid}"
        }
        nova(){
          open -a Nova ''${@}
        }

        less-tspin(){
          # Read from file and view in `less`
          local -r filepath="''${1}"
          tspin "''${filepath}"
        }

        cat-tspin(){
          # Read from file and print to stdout
          local -r filepath="''${1}"
          tspin "''${filepath}" --print
        }

        #tlf(){
          ## Capture the stdout of another command and view in `less`
          #tspin --listen-command 'kubectl logs -f pod_name'
        #}

        docker-compose-up-d-log-colorize(){
          local -r args="''${@}"
          docker compose up -d "''${args}"
          docker compose logs -f "''${args}" | tspin -f
        }


        docker-compose-inspect(){
          local -r service="''${1}"
          docker inspect "$(docker-compose ps -a "''${service}" | awk '{ print $1 }' | tail -n 1)"
        }

        docker-compose-log-colorize(){
          docker compose logs -f "''${@}" | tspin -f
        }

        # expand aliases to full command
        function expand-alias() {
            zle _expand_alias
            zle self-insert
        }
        zle -N expand-alias
        bindkey -M main ' ' expand-alias

        # https://github.com/jarun/nnn/blob/master/misc/quitcd/quitcd.bash_sh_zsh
        n() {
	        [ "''${NNNLVL:-0}" -eq 0 ] || {
		        echo 'nnn is already running'
		        return
	        }
	        # w/ export will *always* cd on quit
	        local -r nnnTmpfile="''${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

	        # The command builtin allows one to alias nnn to n, if desired, without
	        # making an infinitely recursive alias
	        command nnn "''${@}"

	        [ ! -f "''${nnnTmpfile}" ] || {
		        # shellcheck source=/dev/null
		        . "''${nnnTmpfile}"
		        rm -f -- "''${nnnTmpfile}" > '/dev/null'
	        }
        }
      '';
    };

    # programs.neovim = {
	  #   defaultEditor = true;
	  #   viAlias = true;
	  #   vimAlias = true;
	  #   extraConfig = ''
    # 	  set number relativenumber
  	#   '';
    #   #plugins = [
    #     #pkgs.vimExtraPlugins.dracula-nvim
    #     #pkgs.vimExtraPlugins.nvim-treesitter
    #   #];
    # };
    programs.nixvim = {
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      colorschemes.dracula-nvim.enable = true;
      # colorschemes.dracula-nvim.autoLoad = true;
      plugins.lualine.enable = true;
      extraConfigVim = ''
        set number relativenumber
      '';
    };

    programs.starship = {
      # Configuration written to ~/.config/starship.toml
      settings = {
        add_newline = false;

        # character = {
        #   success_symbol = "[➜](bold green)";
        #   error_symbol = "[➜](bold red)";
        # };

        # package.disabled = true;
      };
    };
#
#    # The state version is required and should stay at the version you
#    # originally installed.
    home.stateVersion = "24.11";
  };

  system.stateVersion = "24.11";
}
