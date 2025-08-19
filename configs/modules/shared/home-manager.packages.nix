{
    pkgs
}:
with pkgs;
[

    # cli
  ack
  bat
  # discordo
  devbox
  docker
  docker-credential-helpers
  # git
  inetutils
  jq
  meslo-lgs-nf
  nix-search-cli
  rclone
  rig
  shellcheck
  sipcalc
  shellcheck
  shfmt
  tailspin
  textql
  watch
  wget
  yadm # dotfile manager
  zsh-powerlevel10k
  # inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd
]
