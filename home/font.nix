{ config, pkgs, ... }:

{
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      # Основной шрифт для интерфейса
      sansSerif = [ "Inter" ];
      # Шрифт для заголовков и документов (тоже Inter)
      serif = [ "Inter" ];
      # Для эмодзи можно оставить что-то по умолчанию
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
