{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Sholk";
        email = "twich2230@gmail.com";   # подставь свой email
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = false;
      };
      core = {
        editor = "nvim";
      };
    };
  };
  programs.gh = {
  	enable = true;
  	gitCredentialHelper.enable = true;
  };
}
