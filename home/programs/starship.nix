{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      palette = "polar_night";
      add_newline = false;

      # Пересобрали строку: убрали $nix_shell из общего блока $all
      # и явно прописали его в самом конце первой строки: сначала $nix_shell, потом $cmd_duration
      format = "$os$username$hostname$directory$git_branch$git_status$fill$nix_shell$cmd_duration$line_break╰─$character ";

      # Настраиваем заполнитель, чтобы он расталкивал текст по краям
      fill = {
        symbol = " ";
      };

      # ====== Модуль Nix-Shell (impure / pure) ======
      nix_shell = {
        disabled = false;
        # Убираем "via", ставим логотип NixOS и красим само слово в голубой цвет
        format = "[$symbol$state]($style) ";
        symbol = " "; # Логотип NixOS вместо снежинки
        style = "bold color4"; # Мягкий синий/голубой под цвет хоста
        impure_msg = "impure";
        pure_msg = "pure";
      };

      # ====== Модуль ОС ======
      os = {
        disabled = false;
        format = "╭─ [$symbol]($style)";
        style = "bold color7";
        symbols = {
          Alpine = " ";
          Amazon = " ";
          Android = " ";
          Arch = "  ";
          Artix = " ";
          CentOS = " ";
          Debian = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = " ";
          Gentoo = " ";
          Illumos = " ";
          EndeavourOS = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          OpenBSD = " ";
          openSUSE = " ";
          OracleLinux = " ";
          Pop = " ";
          Raspbian = " ";
          Redhat = " ";
          RedHatEnterprise = " ";
          RockyLinux = " ";
          Solus = " ";
          SUSE = " ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = " ";
        };
      };

      # ====== Цветовая палитра "Полярная ночь" ======
      palettes.polar_night = {
        color0 = "#202936";
        color1 = "#f0a3aa";
        color2 = "#9ee5d4";
        color3 = "#f5dbaa";
        color4 = "#84c3eb";
        color5 = "#d6bbf0";
        color6 = "#a6e3ed";
        color7 = "#e2f1fa";
        color8 = "#303d52";
        color9 = "#fbc3c8";
        color10 = "#bbf2e6";
        color11 = "#fdf0d5";
        color12 = "#a2d5f7";
        color13 = "#ebd9fc";
        color14 = "#c5f0f7";
        color15 = "#f4faff";
      };

      # ====== Имя пользователя и хост ======
      username = {
        format = "[$user]($style)@";
        style_user = "bold color2";
        style_root = "bold color1";
        show_always = true;
      };

      hostname = {
        format = "[$hostname]($style) ";
        style = "bold color4";
        ssh_only = false;
      };

      # ====== Текущая директория ======
      directory = {
        format = "[$path]($style)";
        style = "bold color3";
        truncation_length = 1;
        truncation_symbol = "…/";
      };

      # ====== Ветка Git ======
      git_branch = {
        format = " [$branch]($style)";
        style = "bold color5";
      };

      # ====== Статус Git ======
      git_status = {
        format = "([$all_status$ahead_behind]($style))";
        style = "color1";
      };

      # ====== Языки программирования ======
      nodejs = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color2";
      };
      bun = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color3";
      };
      deno = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color4";
      };
      rust = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color1";
      };
      golang = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color6";
      };
      c = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color4";
      };
      cpp = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color4";
      };
      zig = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color3";
      };
      python = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color6";
      };
      ruby = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color1";
      };
      php = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color5";
      };
      perl = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color4";
      };
      java = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color1";
      };
      kotlin = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color4";
      };
      scala = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color1";
      };
      gradle = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color6";
      };
      docker_context = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color4";
      };
      kubernetes = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color4";
      };
      terraform = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color5";
      };
      aws = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color11";
      };
      lua = {
        format = " [$symbol]($style)";
        symbol = " ";
        style = "bold color4";
      };

      package = {
        format = "";
      };

      # ====== Время выполнения ======
      cmd_duration = {
        format = "[$duration]($style)";
        style = "bold color7";
        min_time = 2000;
        show_milliseconds = false;
        disabled = false;
      };

      # ====== Символ ввода ======
      character = {
        format = "$symbol";
        success_symbol = "[❯](bold color2)";
        error_symbol = "[❯](bold color1)";
      };
    };
  };
}
