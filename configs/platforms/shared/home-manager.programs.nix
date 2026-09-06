
# HOME MANAGER CONFIGS
# https://home-manager-options.extranix.com

# NIX PACKAGES SEARCH
# https://search.nixos.org

{
    pkgs
  , config
  , vars
  , lib
  , ...
}:

let

in

{

home-manager.enable   = true;

nixvim.enable         = true;
direnv.enable         = true;
docker-cli.enable     = false;
git.enable            = true;
# helix.enable          = true;
# java.enable           = true;
nnn.enable            = true;
skim.enable           = true; # fuzzy search
ssh.enable            = false;
tmux.enable           = true;
zsh.enable            = true;
nh.enable             = true;
password-store.enable = false;
# nix-search-tv.enable = true; # branch:unstable

password-store.settings = {
  PASSWORD_STORE_DIR = "/Volumes/_DATA_/.local/share/password-store";
};

nh = {
  flake = "/Volumes/_DATA_/Developer/nix-configs/configs"; # builtins.trace vars vars.thisFlakePath;
  clean.enable = true;
};

nixvim                  = {
  viAlias                          = true;
  vimAlias                         = true;
  defaultEditor                    = true;
  colorschemes.dracula-nvim.enable = true;
  plugins.lualine.enable           = true;
  extraConfigVim                   = ''
    set number relativenumber
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
    set expandtab
  '';
};

# ssh            = {
#   # see https://github.com/nix-community/home-manager/issues/7266
#     # Host *
#   # extraConfig    = ''
#   #   IdentityAgent ~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
#      # IdentityAgent "~/Library/Group Containers/group.strongbox.mac.mcguill/agent.sock"
#   # '';
#   # extraConfig    = ''
#   #    IdentityAgent ~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
#   # '';
#   # controlMaster   = "auto";
#   # controlPath     = "~/.ssh/sockets/%r@%h-%p";
#   # controlPersist  = "10m";
# 
#   includes       = ["~/.orbstack/ssh/config"];
#   matchBlocks    = {
#     "codeberg.org" = {
#       hostname       = "codeberg.org";
#       user           = "git";
#       identityFile   = vars.pubkeyPaths.codeberg;
#     };
#     "nas"          = {
#       hostname       = "nas.stonecat-shark.ts.net";
#       user           = "freon";
#       identityFile   = vars.pubkeyPaths.nas;
#    };
#     "nas.local"    = {
#       hostname       = "172.19.134.18";
#       user           = "freon";
#       identityFile   = vars.pubkeyPaths.nas;
#     };
#     "router"       = {
#       hostname       = "172.19.134.33";
#       port           = 33891;
#       user           = "freon";
#       identityFile   = vars.pubkeyPaths.router;
#     };
#     "github"       = {
#       hostname       = "github.com";
#       user           = "git";
#       identityFile   = vars.pubkeyPaths.github;
#     };
#   };
# };

# fuzzy finder: https://github.com/casonadams/skim.zsh
skim = {
  # integretations causes compdef completion issues due
  # to nix-darwin not properly supporting multi-user installs
  enableZshIntegration = false;
};

git                  = {
  # https://search.nixos.org/options?channel=25.11&query=programs.git.config#show=option%253Aprograms.git.config
  diff-so-fancy.enable = true;
  ignores              = [ ".secret" ".secrets" ".nocommit" ".ignore"];
  # https://docs.codeberg.org/git/configuring-git/
  userName             = "josh_1752185424";
  userEmail            = "josh_1752185424@noreply.codeberg.org";
  extraConfig = {
    push = {
      autoSetupRemote = true;
    };
  };
};

direnv = {
  enableZshIntegration = true;
  nix-direnv.enable = true;
};

tmux = {
  clock24 = true;
  # shell = ""; # broken https://github.com/nix-community/home-manager/issues/5952
  extraConfig = ''
    set-option -g set-titles on
    set-option -g set-titles-string "#{session_name} - #{host}"
    set -g default-command ${pkgs.zsh}/bin/zsh
  '';
  plugins = [
    {
      plugin = pkgs.tmuxPlugins.dracula;
    }
  ];
};

# zsh.completionInit = "autoload -U compinit && compinit -i";
# zsh.completionInit = "autoload -U compinit && compinit -u";
zsh = {
  autocd = true;
  enableCompletion = false;
  autosuggestion.enable = false;
  plugins = [
    {
      name   = "vi-mode";
      src    = pkgs.zsh-vi-mode;
      file   = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
    }
    {
      name   = "zsh-powerlevel10k";
      src    = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
      file   = "powerlevel10k.zsh-theme";
    }
    {
      name   = "powerlevel10k-config";
      src    = ./config/zsh-powerlevel10k;
      file   = "p10k.zsh";
    }
    {
      name   = "dracula/zsh";
      file   = "dracula.zsh-theme";
      src    = pkgs.fetchFromGitHub {
        owner  = "dracula";
        repo   = "zsh";
        rev    = "75ea3f5e1055291caf56b4aea6a5d58d00541c41";
        sha256 = "sha256-TuKC1wPdq2OtEeViwnAmitpdaanyXHJmBcqV+rHxy34=";
      };
    }
    {
      name   = "dracula/zsh-syntax-highlighting";
      file   = "zsh-syntax-highlighting.sh";
      src    = pkgs.fetchFromGitHub {
        owner  = "dracula";
        repo   = "zsh-syntax-highlighting";
        rev    = "09c89b657ad8a27ddfe1d6f2162e99e5cce0d5b3";
        sha256 = "sha256-JrSKx8qHGAF0DnSJiuKWvn6ItQHvWpJ5pKo4yNbrHno=";
      };
    }
  ];
  dirHashes = {
    _                        = "_DATA_";
    nix-config               = "${vars.userDataVolume}/Developer/nix-configs";
    homelab-docker           = "${vars.userDataVolume}/Developer/homelab-docker";
    hlf                      = "${vars.userDataVolume}/Developer/homelab-docker/frontends";
    hlm                      = "${vars.userDataVolume}/Developer/homelab-docker/compose/media";
    hlr                      = "${vars.userDataVolume}/Developer/homelab-docker/compose/rss";
    hls                      = "${vars.userDataVolume}/Developer/homelab-docker/compose/slippi";
    hlu                      = "${vars.userDataVolume}/Developer/homelab-docker/compose/utilities";
    repos                    = "${config.home.homeDirectory}/_DATA_/Developer";
  };
  shellAliases = {
    d            = "docker";
    dc           = "docker compose";
    dc-recreate  = "docker compose up --detach --force-recreate";
    dcr          = "docker compose up --detach --force-recreate --renew-anon-volumes";
    dcrl         = "docker-compose-recreate-log";
    g            = "git";
    ll           = "ls -la";
    l            = "ls -la";
    switch       = "su - admin -c 'sudo /run/current-system/sw/bin/darwin-rebuild switch --flake \"${vars.userDataVolume}/Developer/nix-configs/configs\"'";
    switch-v      = "su - admin -c 'sudo /run/current-system/sw/bin/darwin-rebuild switch --show-trace -vvvvv --show-trace --flake \"${vars.userDataVolume}/Developer/nix-configs/configs\"'";
    diff         = "ksdiff";
    # tailscale    = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    dcd          = "docker compose down";
    dce          = "docker-compose exec";
    dci          = "docker-compose-inspect";
    dcl          = "docker-compose-log-colorize";
    dcu          = "docker compose up -d";
    dcul         = "docker-compose-up-d-log-colorize";
    sc           = "shellcheck";
    admin        = "sudo-admin";
    tmpdir       = "cd \"$(mktemp -d)\"";
    tailscale    = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    ts           = "tailscale";

    # https://github.com/3timeslazy/nix-search-tv?tab=readme-ov-file#fzf
    nix-search   = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
  };
  initContent = builtins.readFile ./config/zsh-shell-functions/functions.sh;

};
}
