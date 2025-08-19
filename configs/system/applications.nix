# modified the below PR
# https://github.com/nix-darwin/nix-darwin/pull/1396
{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = {
    system.checks.text = lib.mkAfter ''
      ensureAppManagement() {
        for appBundle in /Applications/Nix\ Apps/*.app; do
          if [[ -d "$appBundle" ]]; then
            if ! touch "$appBundle/.DS_Store" &> /dev/null; then
              return 1
            fi
          fi
        done

        return 0
      }

      if ! ensureAppManagement; then
        if [[ "$(launchctl managername)" != Aqua ]]; then
          # It is possible to grant the App Management permission to `sshd-keygen-wrapper`, however
          # there are many pitfalls like requiring the primary user to grant the permission and to
          # be logged in when `darwin-rebuild` is run over SSH and it will still fail sometimes...
          printf >&2 '\e[1;31merror: permission denied when trying to update apps over SSH, aborting activation\e[0m\n'
          printf >&2 'Apps could not be updated as `darwin-rebuild` requires Full Disk Access to work over SSH.\n'
          printf >&2 'You can either:\n'
          printf >&2 '\n'
          printf >&2 '  grant Full Disk Access to all programs run over SSH\n'
          printf >&2 '\n'
          printf >&2 'or\n'
          printf >&2 '\n'
          printf >&2 '  run `darwin-rebuild` in a graphical session.\n'
          printf >&2 '\n'
          printf >&2 'The option "Allow full disk access for remote users" can be found by\n'
          printf >&2 'navigating to System Settings > General > Sharing > Remote Login\n'
          printf >&2 'and then pressing on the i icon next to the switch.\n'
          exit 1
        else
          # The TCC service required to modify notarised app bundles is `kTCCServiceSystemPolicyAppBundles`
          # and we can reset it to ensure the user gets another prompt
          tccutil reset SystemPolicyAppBundles > /dev/null

          if ! ensureAppManagement; then
            printf >&2 '\e[1;31merror: permission denied when trying to update apps, aborting activation\e[0m\n'
            printf >&2 '`darwin-rebuild` requires permission to update your apps, please accept the notification\n'
            printf >&2 'and grant the permission for your terminal emulator in System Settings.\n'
            printf >&2 '\n'
            printf >&2 'If you did not get a notification, you can navigate to System Settings > Privacy & Security > App Management.\n'
            exit 1
          fi
        fi
      fi
    '';

    system.build.applications = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };

    system.activationScripts.applications.text = ''
      # Set up applications.
      echo "setting up /Applications/Nix Apps..." >&2

      ourLink () {
        local link
        link=$(readlink "$1")
        [ -L "$1" ] && [ "''${link#*-}" = 'system-applications/Applications' ]
      }

      ${lib.optionalString (config.system.primaryUser != null) ''
        # Clean up for links created at the old location in HOME
        # TODO: Remove this in 25.11.
        if ourLink ~${config.system.primaryUser}/Applications; then
          rm ~${config.system.primaryUser}/Applications
        elif ourLink ~${config.system.primaryUser}/Applications/'Nix Apps'; then
          rm ~${config.system.primaryUser}/Applications/'Nix Apps'
        fi
      ''}

      targetFolder='/Applications/Nix Apps'

      rm -r "$targetFolder"
      mkdir -p "$targetFolder"

      for appPath in '${config.system.build.applications}/Applications/'*; do
        appName="$( basename "$appPath" )"
        realAppPath="$( readlink "$appPath" )"
        ${lib.getExe pkgs.mkalias} "$realAppPath" "$targetFolder/$appName" &
      done
      wait
    '';
  };
}
