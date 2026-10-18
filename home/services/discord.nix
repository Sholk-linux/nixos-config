{ pkgs, ... }:

{
  systemd.user.services.discord-autostart = {
    Unit = {
      Description = "Discord Autostart";
      After = [ "network.target" ];
    };
    Service = {
      ExecStart = "${pkgs.discord}/bin/discord --start-minimized";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
