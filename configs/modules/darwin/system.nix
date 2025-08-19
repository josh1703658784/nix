{
    username
  , userHomeDir
  , primaryUser
  , ...
}:

{
  system.primaryUser = primaryUser;

  programs.tmux.enable      = true;
  programs.direnv.enable    = true;
  programs.man.enable       = true;
  programs.nix-index.enable = false;

  programs.tmux = {
    enableMouse   = true;
    enableVim     = true;
  };

  programs.direnv   = {
    loadInNixShell    = true;
    nix-direnv.enable = true;
    # settings        = {};
  };

  documentation = {
    enable        = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-documentation.enable
    doc.enable    = true; # https://nix-darwin.github.io/nix-darwin/manual/#opt-documentation.doc.enable
    man.enable    = true;
  };

  environment = {
    # https://mynixos.com/nix-darwin/options/environment
    variables = {
      EDITOR = "nvim";
    };
  };

  fonts = {
    # https://mynixos.com/nix-darwin/options/fonts
  };

  users.users = {
    "${username}" = {
      home = userHomeDir;
    };
  };

}
