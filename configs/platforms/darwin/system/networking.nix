{ vars }:
{
  # https://mynixos.com/nix-darwin/options/networking
  computerName               = vars.configName;
  hostName                   = vars.configName;
  localHostName              = vars.configName;
  wakeOnLan.enable           = false;
  # knownNetworkServices = [
  #   "Thunderbolt Bridge"
  #   "Wi-Fi"
  #   "NextDNS"
  #   "Tailscale"
  # ];

  # unstable
  # applicationFirewall.enable = false; # use little-snitch
  # networking.applicationFirewall = {
  #   allowSigned = true;
  #   allowSignedApp = false;
  #   blockAllIncoming = true;
  #   enableStealthMode = true;
  # };

  # dns = [
  #   "9.9.9.9"
  # ];
}
