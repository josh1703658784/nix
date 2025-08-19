{
  userDataVolume
}:
{
  AppleShowAllExtensions          = true;     # show file extensions
  AppleShowAllFiles               = false;     #  show hidden files
  CreateDesktop                   = true;    # show icons on the desktop
  FXDefaultSearchScope            = "SCcf";   # SCcf = current dir; default search scope
  FXEnableExtensionChangeWarning  = false;    # show warnings when changing a file extension
  FXPreferredViewStyle            = "clmv";   # clmv = column view; default finder view
  FXRemoveOldTrashItems           = false;    # let hazel clean the trash; remove items in trash after 30 days
  NewWindowTarget                 = "Other";  # default folder shown in Finder windows
  NewWindowTargetPath             = "file://${userDataVolume}"; # URI to open when NewWindowTarget is "Other"
  ShowExternalHardDrivesOnDesktop = false;    # show external disks on desktop
  ShowHardDrivesOnDesktop         = false;    # show hard disks on desktop
  ShowMountedServersOnDesktop     = false;    # show connected servers on desktop
  ShowPathbar                     = true;     # show path breadcrumbs in finder
  ShowRemovableMediaOnDesktop     = false;    # show removable media (CDs...) on desktop
  ShowStatusBar                   = false;    # show status bar at bottom of finder windows
  _FXShowPosixPathInTitle         = false;    # show the full POSIX filepath in the window title
  _FXSortFoldersFirst             = true;     # keep folders on top when sorting by name
}
