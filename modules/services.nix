{ pkgs, ... }: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = false;
    };
  };

  services.flatpak.enable = true;

  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--accept-dns=false" ];
  };

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];
  services.udev.packages = [ pkgs.brlaser ];

  environment.systemPackages = with pkgs; [
    git gh wayland libxkbcommon
    wineWow64Packages.stagingFull winetricks
  ];
}
