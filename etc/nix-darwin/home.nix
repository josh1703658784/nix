
# home manager configs: https://home-manager-options.extranix.com

# { lib, config, pkgs, modulesPath, ... }:
{ config, pkgs, ...}:

{
    # imports = [ nixvim.homeManagerModules.nixvim ];
	home.stateVersion = "24.11";
	programs.home-manager.enable = true;

  home.file = {
    _josh-data.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data";
    # _bin.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data";
    _Databases.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data/Databases";
    _Developer.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data/Developer";
    _Documents.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data/Documents";
    # _etc.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data";
    _Music.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data/Music";
    # _opt.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data";
    _Pictures.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data/Pictures";
    _Sync.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data/Sync";
    # _tmp.source = config.lib.file.mkOutOfStoreSymlink "/Volumes/josh-data";
  };

	# inputs.nixvim.homeManagerModules.nixvim
    # programs.nixvim.enable = true;
	# inputs.nixvim.homeManagerModules.nixvim

	# home-manager.users.josh.home.homeDirectory
	# home.homeDirectory = /Users/josh;
	# home.username = "josh";
	# home.homeDirectory = "/Users/josh";
	# programs.home-manager.enable = true;
	# home-manager.users.josh.home.users = /Users/josh;
#   imports =
#     [
#       #<home-manager/nixos>
#       (import "${home-manager}/nixos")
#     ];
#
#   networking.hostName = lib.mkForce "xenon";
#   programs.zsh.enable = true; # https://nixos.wiki/wiki/Command_Shell
#   users.defaultUserShell = pkgs.zsh;
#
#   services.tailscale.enable = true;
#
#   home-manager.useUserPackages = true;
#   home-manager.users.josh = { pkgs, ... }: {
#     home.sessionPath = [
#       "\$\{HOME\}/bin"
#       "\$\{HOME\}/opt/bin"
#     ];
#
    # home.packages = [
    #   pkgs.ack
	  # pkgs.bat
    #   # pkgs.conceal
    #   # pkgs.docker-client
    #   # pkgs.docker-compose
    #   # pkgs.dockerfile-language-server-nodejs
    #   # # pkgs.git
    #   # pkgs.go
    #   # pkgs.trashy
    #   # pkgs.skim
    #   # pkgs.inetutils
    #   # pkgs.nix-search-cli
    #   # pkgs.nodejs
    #   # pkgs.openssh
    #   # pkgs.postgresql
    #   # pkgs.python3
    #   # pkgs.tailspin
    #   # pkgs.shellcheck
    #   # pkgs.shfmt
    #   # pkgs.sipcalc
    #   # pkgs.sqlite
    #   # pkgs.textql
    # ];
#     programs.neovim.enable = true;
#     programs.ssh.enable = true;
#     programs.bash.enable = false;
#     programs.home-manager.enable = true;
#     programs.nnn.enable = true;
    programs.tmux.enable = true;
    programs.zsh.enable = true;
#     programs.starship.enable = true;
#     programs.skim.enable = true; # fzf inspired
#     programs.git.enable = true;
#     programs.direnv.enable = true;
#
#     programs.skim = {
#       enableZshIntegration = true;
#     };
#
#     programs.git = {
#       diff-so-fancy.enable = true;
#     };
#
#     programs.direnv = {
#       enableZshIntegration = true;
#       nix-direnv.enable = true;
#     };
#
#
#
    programs.tmux = {
      clock24 = true;
      extraConfig = ''
	      set-option -g set-titles on
        set-option -g set-titles-string "#{session_name} - #{host}"
      '';
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = dracula;
        }
      ];
    };
#     programs.git = {
# 	    ignores = [ ".secret" ".secrets"];
#     };
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
#       autocd = true;
#       enableCompletion = true;
#       autosuggestion.enable = true;
#       dirHashes = {
#         homelab = "/Volumes/Data/Developer/homelab-docker";
#         dev = "/Volumes/Data/Developer";
#         home = "/Users/josh";
#         "_" = "/Users/josh";
#       };
#       plugins = [{
#         name = "vi-mode";
#         src = pkgs.zsh-vi-mode;
#         file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
#       }];
#       shellAliases = {
#         ll = "ls -la";
#         nix-edit = "sudo nvim /etc/nixos/configuration.nix";
#         nix-reload = "sudo nixos-rebuild switch";
#         d = "docker";
#         dc = "docker-compose";
#         g = "git";
#         ts = "tailscale";
#         dcu = "docker compose up -d";
#         dcd = "docker compose down";
#         ns = "nix-shell";
#         dci = "docker-compose-inspect";
#         dcl = "docker-compose-log-colorize";
#         dcul = "docker-compose-up-d-log-colorize";
#         dce = "docker-compose exec";
#         highlight = "tspin";
#         less = "less-tspin";
#         cat = "cat-tspin";
#       };
#       initExtra = ''
#         reminder(){
#           local -r uuid="''${1}"
#           local -r url='shortcuts://x-callback-url/run-shortcut?name=open-reminder&input=text&text='
#           sudo open "''${url}''${uuid}"
#         }
#         nova(){
#           open -a Nova ''${@}
#         }
#
#         less-tspin(){
#           # Read from file and view in `less`
#           local -r filepath="''${1}"
#           tspin "''${filepath}"
#         }
#
#         cat-tspin(){
#           # Read from file and print to stdout
#           local -r filepath="''${1}"
#           tspin "''${filepath}" --print
#         }
#
#         #tlf(){
#           ## Capture the stdout of another command and view in `less`
#           #tspin --listen-command 'kubectl logs -f pod_name'
#         #}
#
#         docker-compose-up-d-log-colorize(){
#           local -r args="''${@}"
#           docker compose up -d "''${args}"
#           docker compose logs -f "''${args}" | tspin -f
#         }
#
#
#         docker-compose-inspect(){
#           local -r service="''${1}"
#           docker inspect "$(docker-compose ps -a "''${service}" | awk '{ print $1 }' | tail -n 1)"
#         }
#
#         docker-compose-log-colorize(){
#           docker compose logs -f "''${@}" | tspin -f
#         }
#
#         # expand aliases to full command
#         function expand-alias() {
#             zle _expand_alias
#             zle self-insert
#         }
#         zle -N expand-alias
#         bindkey -M main ' ' expand-alias
#
#         # https://github.com/jarun/nnn/blob/master/misc/quitcd/quitcd.bash_sh_zsh
#         n() {
# 	        [ "''${NNNLVL:-0}" -eq 0 ] || {
# 		        echo 'nnn is already running'
# 		        return
# 	        }
# 	        # w/ export will *always* cd on quit
# 	        local -r nnnTmpfile="''${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
#
# 	        # The command builtin allows one to alias nnn to n, if desired, without
# 	        # making an infinitely recursive alias
# 	        command nnn "''${@}"
#
# 	        [ ! -f "''${nnnTmpfile}" ] || {
# 		        # shellcheck source=/dev/null
# 		        . "''${nnnTmpfile}"
# 		        rm -f -- "''${nnnTmpfile}" > '/dev/null'
# 	        }
#         }
#       '';
    };
#
#     programs.neovim = {
# 	    defaultEditor = true;
# 	    viAlias = true;
# 	    vimAlias = true;
# 	    extraConfig = ''
#     	  set number relativenumber
#
#   	  '';
#     };
#     programs.starship = {
#       # Configuration written to ~/.config/starship.toml
#       settings = {
#         add_newline = false;
#
#         # character = {
#         #   success_symbol = "[➜](bold green)";
#         #   error_symbol = "[➜](bold red)";
#         # };
#
#         # package.disabled = true;
#       };
#     };
# #
# #    # The state version is required and should stay at the version you
# #    # originally installed.
#     home.stateVersion = "23.11";
#   };
#
  # system.stateVersion = "24.11";
}
