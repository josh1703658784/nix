
# HOME MANAGER CONFIGS
# https://home-manager-options.extranix.com

# NIX PACKAGES SEARCH
# https://search.nixos.org

{
    inputs
  , config
  , pkgs
  , user-data-volume
  , user-home-dir
  , nix-config-dir
  , ...
}:

let

in

{

fonts.fontconfig.enable      = true;
programs.direnv.enable       = true;
programs.git.enable          = true;
programs.nnn.enable          = true;
programs.skim.enable         = true; # fuzzy search
programs.tmux.enable         = true;
programs.zsh.enable          = true;
programs.home-manager.enable = true;
programs.firefox.enable = true;
# programs.ssh.enable = true;


home.file = {
  _HOME.source         = config.lib.file.mkOutOfStoreSymlink "${user-data-volume}";
};

home.packages = pkgs.callPackage ./home.pkgs.nix {};

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

    # @TODO resolve this dynamically
    nix-config = "${user-data-volume}/Developer/nix-configs";
  };
  shellAliases = {
    d       = "docker";
    dc      = "docker compose";
    dc-recreate = "docker compose up --detach --force-recreate";
    dcr     = "docker compose up --detach --force-recreate --renew-anon-volumes";
    dcrl    = "docker-compose-recreate-log";
    g       = "git";
    ll      = "ls -la";
    l       = "ls -la";
    ns      = "nix-shell";
    switch  = "su - admin -c 'sudo darwin-rebuild switch --show-trace --flake \"${user-data-volume}/Developer/nix-configs/etc/nix-darwin\"'";
    diff    = "ksdiff";
    tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
    ts        = "tailscale";
    dcd   = "docker compose down";
    dce   = "docker-compose exec";
    dci   = "docker-compose-inspect";
    dcl   = "docker-compose-log-colorize";
    dcu   = "docker compose up -d";
    dcul  = "docker-compose-up-d-log-colorize";
    sc    = "shellcheck";
  };
  initContent = builtins.readFile ./external-configs/zsh-shell-functions/functions.sh;

};

# system.stateVersion = "24.11";
home.stateVersion = "24.11";
}
