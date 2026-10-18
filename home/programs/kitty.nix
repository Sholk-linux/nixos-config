{
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;
      dynamic_background_opacity = true;
      background_opacity = "0.99";
      background_blur = 10;
      wayland_titlebar_color = "background";
      cursor_shape = "block";
      cursor_trail = 1;
      cursor_blink_interval = "0";

      # --- ПОВЕДЕНИЕ И ОПТИМИЗАЦИЯ ---
      scrollback_lines = 10000; # Хранить до 10 000 строк истории терминала
      wheel_scroll_multiplier = "5.0"; # Более быстрая и плавная прокрутка мышью
      repaint_delay = 8; # Минимальная задержка отрисовки (для 120Hz+ мониторов)
      input_delay = 1; # Мгновенный отклик на нажатие клавиш
      enable_audio_bell = false; # Отключить раздражающий системный писк

      # --- ПАЛИТРА: ТЕМНАЯ ПОЛЯРНАЯ НОЧЬ ---
      background = "#161c23";
      foreground = "#e2f1fa";
      cursor = "#a1dbf7";
      cursor_text_color = "#0b0f14";
      selection_background = "#243345";
      selection_foreground = "#e2f1fa";

      color0 = "#202936";
      color1 = "#f0a3aa";
      color2 = "#9ee5d4";
      color3 = "#f5dbaa";
      color4 = "#84c3eb";
      color5 = "#d6bbf0";
      color6 = "#a6e3ed";
      color7 = "#e2f1fa";
      color8 = "#5d7094";
      color9 = "#fbc3c8";
      color10 = "#bbf2e6";
      color11 = "#fdf0d5";
      color12 = "#a2d5f7";
      color13 = "#ebd9fc";
      color14 = "#c5f0f7";
      color15 = "#f4faff";
    };
  };
}
