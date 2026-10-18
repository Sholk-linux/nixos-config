{
  # Включаем официальный модуль Eza с иконками
  programs.eza = {
    enable = true;
    icons = "always";
    git = true;
    extraOptions = [ "--group-directories-first" ];
  };

  # 1. Добавляем умный переход по папкам zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Автоматически привязывается к Ctrl+R

    # Кастомизация под наши полярные цвета БЕЗ ломания читаемости
    colors = {
      bg = "-1"; # Использовать прозрачный фон вашей Kitty
      fg = "-1"; # Использовать ваш снежный текст
      hl = "#84c3eb"; # Совпадения подсвечивать снежно-голубым
      "fg+" = "#f4faff"; # Выбранная строка — ярко-белый лед
      "bg+" = "#1b2735"; # Мягкое ледяное выделение подложки (как в Kitty)
      "hl+" = "#a6e3ed"; # Совпадение на выбранной строке — светлый лед
      pointer = "#a1dbf7"; # Стрелочка выбора
      info = "#d6bbf0";
      prompt = "#84c3eb";
    };
  };

  # 3. Добавляем красивый системный монитор btop
  programs.btop = {
    enable = true;
    settings = {
      # Исправлено: тема TTY заставляет btop идеально слиться с фоном Kitty
      color_theme = "TTY";
      vim_keys = true;
      rounded_corners = true; # Скругленные рамки блоков
      theme_background = false;
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    # СЕКРЕТ СКОРОСТИ: Включаем быстрое кэширование
    nix-direnv.enable = true;

    config = {
      global = {
        hide_env_diff = true; # Полностью отключает показ измененных переменных
        log_filter = "^$"; # Прячет вообще весь текстовый вывод direnv
      };
    };
  };

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    # Меню автодополнения Tab переносим сюда (без лишних отступов)
    initContent = ''
      zstyle ':completion:*' menu select
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      autoload -Uz compinit && compinit
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    shellAliases = {
      ff = "fastfetch";
      hm = "home-manager switch --flake .#sholk";
      nr = "sudo nixos-rebuild switch --flake .#sholk-space";

      v = "nvim ";
      y = "yazi";
      cr = "cargo run --color always ";
      cac = "cargo check --color always ";

      ss = "sudo ";
      lavat = "lavat -g -c 6495ED -k 6495ED -b 9 -r 5";

      # Алиас для быстрого запуска монитора
      top = "btop";
    };
  };
}
