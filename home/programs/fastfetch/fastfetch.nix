{ pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    
    # Тонкая настройка вывода (настройки конвертируются в JSONC)
    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          right = 2;
        };
      };
      display = {
        size = {
          binaryPrefix = "si";
        };
        color = "blue";
        separator = " -  "; # Использование кастомного разделителя (требует Nerd Font)
      };
      modules = [
        "title"
        "os"
        "break"
        "kernel"
        "packages"
        "shell"
      ];
    };
  };
}

