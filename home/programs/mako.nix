{ ... }:

{
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      margin = "18, 20, 10, 20";
      background-color = "#383c4a"; # цвет как у waybar
      text-color = "#ffffff";
      border-color = "#4a9eff"; # твой голубой акцент
      border-radius = 10; # закругление
      font = "JetBrains Mono 12";
      width = 350;
      height = 100;
      padding = 10;
      default-timeout = 5000;
      ignore-timeout = true;
      max-visible = 5;
      group-by = "app-name";
    };
  };
}
