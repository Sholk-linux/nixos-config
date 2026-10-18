{ pkgs, ... }: {
  users.users.sholk = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5zS3b6Qo3NX9P8uZAc+tstyuXRAaAwfpXbl4r9VuYo twich2230@gmail.com"
    ];
  };
}
