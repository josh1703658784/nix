{
    pkgs
}:
with pkgs;
[

    # cli
  ack
  bat
  # discordo
  docker
  docker-credential-helpers
  git
  inetutils
  meslo-lgs-nf
  nix-search-cli
  rclone
  rig
  shellcheck
  sipcalc
  tailspin
  watch
  wget
  yadm # dotfile manager
  zsh-powerlevel10k
  # inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
]
