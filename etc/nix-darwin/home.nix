
# HOME MANAGER CONFIGS
# https://home-manager-options.extranix.com

# NIX PACKAGES SEARCH
# https://search.nixos.org

# { lib, config, pkgs, modulesPath, ... }:
{ inputs, username, config, pkgs, ...}:

{
  fonts.fontconfig.enable      = true;
  programs.direnv.enable       = true;
  programs.git.enable          = true;
  programs.nnn.enable          = true;
  programs.skim.enable         = true; # fuzzy search
  programs.tmux.enable         = true;
  programs.zsh.enable          = true;
  programs.home-manager.enable = true;
  # programs.ssh.enable = true;

  home.file = {
    _Databases.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/${username}-data/Databases";
    _Developer.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/${username}-data/Developer";
    _Documents.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/${username}-data/Documents";
    _HOME.source      = config.lib.file.mkOutOfStoreSymlink "/Volumes/${username}-data";
    _Music.source     = config.lib.file.mkOutOfStoreSymlink "/Volumes/${username}-data/Music";
    _Pictures.source  = config.lib.file.mkOutOfStoreSymlink "/Volumes/${username}-data/Pictures";
    _Sync.source      = config.lib.file.mkOutOfStoreSymlink "/Volumes/${username}-data/Sync";
    # _bin.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data";
    # _etc.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data";
    # _opt.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data";
    # _tmp.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data";
  };

  home.packages = with pkgs; [
    zsh-powerlevel10k
    bat
    git

    # FONTS
    nerdfonts
    meslo-lgs-nf
    inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
  ];

  # fuzzy finder: https://github.com/casonadams/skim.zsh
  programs.skim = {
    enableZshIntegration = true;
  };

  programs.git = {
    diff-so-fancy.enable = true;
    ignores = [ ".secret" ".secrets" ".nocommit" ".ignore"];
  };

  programs.direnv = {
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.tmux = {
    clock24 = true;
    # shell = ""; # broken https://github.com/nix-community/home-manager/issues/5952
    extraConfig = ''
      set-option -g set-titles on
      set-option -g set-titles-string "#{session_name} - #{host}"
      set -g default-command ${pkgs.zsh}/bin/zsh
    '';
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = dracula;
      }
    ];
  };

  programs.zsh = {
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./external-configs/zsh-powerlevel10k;
        file = "config";
        # src = pkgs.fetchFromGitHub {
        #   owner = "dracula";
        #   repo = "powerlevel10k";
        #   rev = "123e8e09c323f47d8cfe97b3ff7888bfad313798";
        #   sha256 = "sha256-55z0Bh9gz7BPPUDZtum9Pav1RhG3avFNWu6B/q90fXI=";
        # };
        # file = "./files/.p10k.zsh";
      }
      {
        name = "dracula/zsh";
        file = "dracula.zsh-theme";
        src = pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "zsh";
          rev = "75ea3f5e1055291caf56b4aea6a5d58d00541c41";
          sha256 = "sha256-TuKC1wPdq2OtEeViwnAmitpdaanyXHJmBcqV+rHxy34=";
        };
      }
      {
        name = "dracula/zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.sh";
        src = pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "zsh-syntax-highlighting";
          rev = "09c89b657ad8a27ddfe1d6f2162e99e5cce0d5b3";
          sha256 = "sha256-JrSKx8qHGAF0DnSJiuKWvn6ItQHvWpJ5pKo4yNbrHno=";
        };
      }
    ];
    dirHashes = {
      databases = "_Databases";
      developer = "_Developer";
      documents = "_Documents";
      downloads = "Downloads";
      desktop   = "Desktop";
      _         = "_HOME";
      music     = "_Music";
      pictures  = "_Pictures";
      sync      = "_Sync";

      dbs  = "_Databases";
      dev  = "_Developer";
      docs = "_Documents";
    };
    shellAliases = {
      d       = "docker";
      dc      = "docker-compose";
      g       = "git";
      ll      = "ls -la";
      l       = "ls -la";
      ns      = "nix-shell";
      switch  = "sudo nixos-rebuild switch";
      ts      = "tailscale";
      # dcd   = "docker compose down";
      # dce   = "docker-compose exec";
      # dci   = "docker-compose-inspect";
      # dcl   = "docker-compose-log-colorize";
      # dcu   = "docker compose up -d";
      # dcul  = "docker-compose-up-d-log-colorize";
    };
    initExtra = ''
      nova(){
        readonly REAL="$(readlink '/Applications/Nix Apps/Nova.app' )"
        readonly BIN="''${REAL}/Contents/SharedSupport/nova"
        "''${BIN}" ''${@}
      }

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

      # # expand aliases to full command
      # function expand-alias() {
      #     zle _expand_alias
      #     zle self-insert
      # }
      # zle -N expand-alias
      # bindkey -M main ' ' expand-alias

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

  # system.stateVersion = "24.11";
	home.stateVersion = "24.11";
}
