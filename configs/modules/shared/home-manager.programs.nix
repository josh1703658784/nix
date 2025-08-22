
# HOME MANAGER CONFIGS
# https://home-manager-options.extranix.com

# NIX PACKAGES SEARCH
# https://search.nixos.org

{
    pkgs
  , config
  , userDataVolume
  , pubkeyPaths
  , ...
}:

let

in

{

home-manager.enable = true;

nixvim.enable       = true;
direnv.enable       = true;
docker-cli.enable   = false;
git.enable          = true;
nnn.enable          = true;
skim.enable         = true; # fuzzy search
ssh.enable          = true;
tmux.enable         = true;
zsh.enable          = true;
# nix-search-tv.enable = true; # unstable


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

ssh            = {
  # see https://github.com/nix-community/home-manager/issues/7266
  extraConfig    = ''
    IdentityAgent "~/Library/Group Containers/group.strongbox.mac.mcguill/agent.sock"
    IdentitiesOnly yes
  '';
  includes       = ["~/.orbstack/ssh/config"];
  matchBlocks    = {
    "codeberg.org" = {
      hostname       = "codeberg.org";
      user           = "git";
      identityFile = pubkeyPaths.codeberg;
    };
    "deck"         = {
      hostname       = "192.168.20.145";
      user           = "deck";
      identityFile   = pubkeyPaths.deck;
    };
    "github"       = {
      hostname       = "github.com";
      user           = "git";
      identityFile   = pubkeyPaths.github;
    };
    "gitea"        = {
      hostname       = "gitea.stonecat-shark.ts.net";
      user           = "git";
      identityFile   = pubkeyPaths.gitea;
    };
    "nas"          = {
      hostname       = "nas.stonecat-shark.ts.net";
      user           = "freon";
      identityFile   = pubkeyPaths.nas;
    };
    "nas.local"    = {
      hostname       = "192.168.10.34";
      user           = "freon";
      identityFile   = pubkeyPaths.nas;
    };
    "router"       = {
      hostname       = "192.168.10.1";
      user           = "user00";
      identityFile   = pubkeyPaths.router;
    };
  };
};

# fuzzy finder: https://github.com/casonadams/skim.zsh
skim = {
  enableZshIntegration = true;
};

git                  = {
  diff-so-fancy.enable = true;
  ignores              = [ ".secret" ".secrets" ".nocommit" ".ignore"];
  # https://docs.codeberg.org/git/configuring-git/
  userName             = "josh_1752185424";
  userEmail            = "josh_1752185424@noreply.codeberg.org";
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

zsh = {
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
      src = ./config/zsh-powerlevel10k;
      file = "p10k.zsh";
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
    _                        = "_DATA_";
    nix-config               = "${userDataVolume}/Developer/nix-configs";
    homelab-docker           = "${userDataVolume}/Developer/homelab-docker";
    homelab-docker-media     = "${userDataVolume}/Developer/homelab-docker/compose/media";
    homelab-docker-utilities = "${userDataVolume}/Developer/homelab-docker/compose/utilities";
    repositories             = "${config.home.homeDirectory}/_DATA_/Developer";
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
    switch       = "su - admin -c 'sudo darwin-rebuild switch --flake \"${userDataVolume}/Developer/nix-configs/configs\"'";
    switch-v      = "su - admin -c 'sudo darwin-rebuild switch --show-trace -vvvvv --show-trace --flake \"${userDataVolume}/Developer/nix-configs/configs\"'";
    diff         = "ksdiff";
    # tailscale    = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    ts           = "tailscale";
    dcd          = "docker compose down";
    dce          = "docker-compose exec";
    dci          = "docker-compose-inspect";
    dcl          = "docker-compose-log-colorize";
    dcu          = "docker compose up -d";
    dcul         = "docker-compose-up-d-log-colorize";
    sc           = "shellcheck";

    # https://github.com/3timeslazy/nix-search-tv?tab=readme-ov-file#fzf
    nix-search   = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
  };
  initContent = builtins.readFile ./config/zsh-shell-functions/functions.sh;

};
}
