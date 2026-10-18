{ pkgs, ... }:

{
  systemd.user.services.discord-fetch = {
    Unit = {
      Description = "Discord status fetcher";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.callPackage ../pkgs/discord-fetch.nix { }}/bin/discord-fetch"; # путь к бинарнику
      Restart = "always";
      RestartSec = 10;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
