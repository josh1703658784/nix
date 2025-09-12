{
  vars
}:

{
  autohide                = true;   # automatically hide and show the dock
  orientation             = "left"; # position of the dock on screen
  show-process-indicators = false;
  show-recents            = false;
  static-only             = false;  # show only open applications, disables dirs
  tilesize                = 32;     # size of the icons
  magnification           = false;
  mineffect               = "suck";
  minimize-to-application = true;
  expose-group-apps       = true;   # group windows by application in Mission Control
  mru-spaces              = false;  # automatically rearrange spaces based on most recent use
  persistent-apps         = [];     # persistent applications
  persistent-others       = [       # persistent folders
    "${vars.userHomeDir}/Downloads"
  ];
}
