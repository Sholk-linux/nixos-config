{
  programs.firefox = {
    enable = true;
    extraConfig = ''
      user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
    '';

    profiles.default = {
      isDefault = true;
      userChrome = builtins.readFile ./firefox-corners.css;
    };
  };
}
