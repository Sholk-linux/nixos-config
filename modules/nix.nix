{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  security.sudo.extraConfig = ''
    Defaults env_keep += "EDITOR SUDO_EDITOR VISUAL"
    Defaults env_keep += "XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME"
  '';

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib zlib openssl curl libssh bzip2 libxml2
      acl libsodium util-linux xz systemd
      libX11 libXext libXrandr libXcomposite libXtst libXfixes
      libxcb libXdamage libxshmfence libXxf86vm libGL libva
      pipewire glib gtk2 libelf networkmanager vulkan-loader libgbm libdrm
    ];
  };
}
