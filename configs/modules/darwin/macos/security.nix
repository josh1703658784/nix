{}:
{
  # auth with touchid, watch in terminal
  pam.services.sudo_local = {
    enable                  = true;
    reattach                = true;
    touchIdAuth             = true;
    watchIdAuth             = true;
  };
}
