{ pkgs, config, ... }:

{
  imports = [
    ./packages.nix
    ./font.nix
    ./hyprland/desktop.nix
    ./programs/librewolf.nix
    ./programs/zsh.nix
    ./programs/starship.nix
    ./programs/wofi.nix
    ./programs/kitty.nix
    ./programs/git.nix
    ./programs/nvim.nix
    ./programs/mako.nix
    ./programs/yazi.nix
    ./programs/fastfetch/fastfetch.nix
    ./services/discord-fetch.nix
    ./services/discord.nix
  ];

  home.stateVersion = "26.05";

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}
