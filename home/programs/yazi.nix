{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    # === Плагины ===
    plugins = {
      smart-enter = pkgs.yaziPlugins.smart-enter;
    };

    # === Инициализация плагинов (Lua) ===
    initLua = ''
      require("smart-enter"):setup({})
    '';

    # === Основные настройки ===
    settings = {
      manager = {
        ratio = [
          1
          4
          3
        ];
        show_hidden = false;
        show_symlink = true;
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        show_mode = "none";
      };

      preview = {
        tab_size = 4;
        max_width = 1000;
        max_height = 1000;
        image_filter = "lanczos3";
        image_quality = 90;
      };

      opener = {
        edit = [
          {
            run = "nvim %s";
            desc = "Neovim";
            block = true;
          }
        ];
        open = [
          {
            run = "xdg-open %s";
            desc = "Open";
            block = false;
          }
        ];
        reveal = [
          {
            run = "xdg-open \"$(dirname \"%s\")\"";
            desc = "Reveal";
            block = false;
          }
        ];
        play = [
          {
            run = "mpv %s";
            desc = "Play in mpv";
            block = true;
          }
        ];
      };

      open = {
        prepend_rules = [
          # Явные правила по расширениям — только edit
          {
            url = "*.nix";
            use = "edit";
          }
          {
            url = "*.rs";
            use = "edit";
          }
          {
            url = "*.toml";
            use = "edit";
          }
          {
            url = "*.md";
            use = "edit";
          }
          {
            url = "*.txt";
            use = "edit";
          }
          {
            url = "*.lua";
            use = "edit";
          }
          {
            url = "*.py";
            use = "edit";
          }
          {
            url = "*.go";
            use = "edit";
          }
          {
            url = "*.js";
            use = "edit";
          }
          {
            url = "*.ts";
            use = "edit";
          }
          {
            url = "*.json";
            use = "edit";
          }
          {
            url = "*.yaml";
            use = "edit";
          }
          {
            url = "*.yml";
            use = "edit";
          }
          {
            url = "*.sh";
            use = "edit";
          }
          {
            url = "*.conf";
            use = "edit";
          }
          {
            url = "*.html";
            use = "edit";
          }
          {
            url = "*.css";
            use = "edit";
          }

          # MIME-типы
          {
            mime = "text/*";
            use = "edit";
          }
          {
            mime = "image/*";
            use = [
              "open"
              "reveal"
            ];
          }
          {
            mime = "video/*";
            use = [
              "play"
              "reveal"
            ];
          }
          {
            mime = "audio/*";
            use = [
              "play"
              "reveal"
            ];
          }
          {
            mime = "application/pdf";
            use = [
              "open"
              "reveal"
            ];
          }
        ];
      };

      tasks = {
        micro_workers = 10;
        macro_workers = 10;
        bizarre_retry = 5;
      };
    };

    # === Горячие клавиши ===
    keymap = {
      manager.prepend_keymap = [
        # Enter — умный (папка → войти, файл → открыть)
        {
          on = [ "<Enter>" ];
          run = "plugin smart-enter";
          desc = "Умный Enter";
        }

        # Навигация
        {
          on = [ "h" ];
          run = "leave";
          desc = "Назад";
        }
        {
          on = [ "l" ];
          run = "enter";
          desc = "Войти";
        }
        {
          on = [ "j" ];
          run = "arrow down";
          desc = "Вниз";
        }
        {
          on = [ "k" ];
          run = "arrow up";
          desc = "Вверх";
        }
        {
          on = [
            "g"
            "g"
          ];
          run = "arrow top";
          desc = "В начало";
        }
        {
          on = [ "G" ];
          run = "arrow bot";
          desc = "В конец";
        }

        # Файловые операции
        {
          on = [ "y" ];
          run = "yank";
          desc = "Копировать";
        }
        {
          on = [ "x" ];
          run = "cut";
          desc = "Вырезать";
        }
        {
          on = [ "p" ];
          run = "paste";
          desc = "Вставить";
        }
        {
          on = [ "d" ];
          run = "remove";
          desc = "Удалить";
        }
        {
          on = [ "D" ];
          run = "remove --permanent";
          desc = "Удалить навсегда";
        }
        {
          on = [ "a" ];
          run = "create";
          desc = "Создать";
        }
        {
          on = [ "r" ];
          run = "rename";
          desc = "Переименовать";
        }

        # Поиск
        {
          on = [ "/" ];
          run = "find";
          desc = "Поиск";
        }
        {
          on = [ "n" ];
          run = "find_arrow";
          desc = "Следующий";
        }
        {
          on = [ "N" ];
          run = "find_arrow --previous";
          desc = "Предыдущий";
        }

        # Сортировка
        {
          on = [
            ","
            "m"
          ];
          run = "sort mtime --reverse=no";
          desc = "По дате";
        }
        {
          on = [
            ","
            "M"
          ];
          run = "sort mtime --reverse=yes";
          desc = "По дате (обр.)";
        }
        {
          on = [
            ","
            "s"
          ];
          run = "sort size --reverse=no";
          desc = "По размеру";
        }
        {
          on = [
            ","
            "S"
          ];
          run = "sort size --reverse=yes";
          desc = "По размеру (обр.)";
        }
        {
          on = [
            ","
            "e"
          ];
          run = "sort extension --reverse=no";
          desc = "По типу";
        }

        # Скрытые файлы
        {
          on = [ "." ];
          run = "hidden toggle";
          desc = "Скрытые файлы";
        }

        # Выход
        {
          on = [ "q" ];
          run = "quit";
          desc = "Выход";
        }
        {
          on = [ "Q" ];
          run = "quit --no-cwd-file";
          desc = "Выход без cd";
        }

        # Полстраницы
        {
          on = [ "<C-u>" ];
          run = "arrow half-up";
          desc = "Полстраницы вверх";
        }
        {
          on = [ "<C-d>" ];
          run = "arrow half-down";
          desc = "Полстраницы вниз";
        }

        # Быстрый jump
        {
          on = [
            "g"
            "h"
          ];
          run = "cd ~";
          desc = "Домой";
        }
        {
          on = [
            "g"
            "c"
          ];
          run = "cd ~/.config";
          desc = "В ~/.config";
        }
        {
          on = [
            "g"
            "d"
          ];
          run = "cd ~/Documents";
          desc = "В ~/Documents";
        }
        {
          on = [
            "g"
            "p"
          ];
          run = "cd ~/Pictures";
          desc = "В ~/Pictures";
        }
        {
          on = [
            "g"
            "n"
          ];
          run = "cd ~/nixos";
          desc = "В ~/nixos";
        }
      ];
    };

    # === Тема Polar Night ===
    theme = {
      manager = {
        cwd = {
          fg = "#84c3eb";
          bold = true;
        };
        hovered = {
          fg = "#161c23";
          bg = "#84c3eb";
          bold = true;
        };
        preview_hovered = {
          underline = true;
        };
        find_keyword = {
          fg = "#f5dbaa";
          italic = true;
        };
        find_position = {
          fg = "#d6bbf0";
          bg = "reset";
          italic = true;
        };
        marker_selected = {
          fg = "#9ee5d4";
          bg = "#9ee5d4";
        };
        marker_copied = {
          fg = "#f5dbaa";
          bg = "#f5dbaa";
        };
        marker_cut = {
          fg = "#f0a3aa";
          bg = "#f0a3aa";
        };
        tab_active = {
          fg = "#161c23";
          bg = "#84c3eb";
        };
        tab_inactive = {
          fg = "#e2f1fa";
          bg = "#202936";
        };
        border_style = {
          fg = "#243345";
          bg = "#161c23";
        };
      };

      status = {
        separator_open = "";
        separator_close = "";
        separator_style = {
          fg = "#243345";
          bg = "#202936";
        };
        mode_normal = {
          fg = "#161c23";
          bg = "#84c3eb";
          bold = true;
        };
        mode_select = {
          fg = "#161c23";
          bg = "#9ee5d4";
          bold = true;
        };
        mode_unset = {
          fg = "#161c23";
          bg = "#f0a3aa";
          bold = true;
        };
        progress_label = {
          fg = "#f4faff";
          bold = true;
        };
        progress_normal = {
          fg = "#84c3eb";
          bg = "#202936";
        };
        progress_error = {
          fg = "#f0a3aa";
          bg = "#202936";
        };
        permissions_t = {
          fg = "#84c3eb";
        };
        permissions_r = {
          fg = "#f5dbaa";
        };
        permissions_w = {
          fg = "#f0a3aa";
        };
        permissions_x = {
          fg = "#9ee5d4";
        };
        permissions_s = {
          fg = "#5d7094";
        };
      };

      select = {
        border = {
          fg = "#84c3eb";
          bg = "#161c23";
        };
        active = {
          fg = "#9ee5d4";
        };
        inactive = {
          fg = "#5d7094";
        };
      };

      input = {
        border = {
          fg = "#84c3eb";
          bg = "#161c23";
        };
        title = {
          fg = "#84c3eb";
        };
        value = {
          fg = "#e2f1fa";
        };
        selected = {
          fg = "#161c23";
          bg = "#84c3eb";
        };
      };

      tasks = {
        border = {
          fg = "#84c3eb";
          bg = "#161c23";
        };
        title = {
          fg = "#84c3eb";
        };
        hovered = {
          fg = "#161c23";
          bg = "#84c3eb";
        };
      };

      which = {
        mask = {
          bg = "#161c23";
        };
        cand = {
          fg = "#a6e3ed";
        };
        rest = {
          fg = "#5d7094";
        };
        desc = {
          fg = "#f5dbaa";
        };
        separator = " → ";
        separator_style = {
          fg = "#243345";
          bg = "#202936";
        };
      };

      help = {
        on = {
          fg = "#a6e3ed";
        };
        exec = {
          fg = "#9ee5d4";
        };
        desc = {
          fg = "#e2f1fa";
        };
        hovered = {
          fg = "#161c23";
          bg = "#84c3eb";
          bold = true;
        };
        footer = {
          fg = "#202936";
          bg = "#e2f1fa";
        };
      };

      filetype = {
        rules = [
          {
            mime = "image/*";
            fg = "#d6bbf0";
          }
          {
            mime = "video/*";
            fg = "#f5dbaa";
          }
          {
            mime = "audio/*";
            fg = "#f5dbaa";
          }
          {
            mime = "application/zip";
            fg = "#fbc3c8";
          }
          {
            mime = "application/x-tar";
            fg = "#fbc3c8";
          }
          {
            mime = "application/x-7z-compressed";
            fg = "#fbc3c8";
          }
          {
            mime = "application/x-rar";
            fg = "#fbc3c8";
          }
          {
            mime = "application/x-bzip2";
            fg = "#fbc3c8";
          }
          {
            mime = "application/x-gzip";
            fg = "#fbc3c8";
          }
          {
            mime = "application/pdf";
            fg = "#f0a3aa";
          }
          {
            mime = "text/*";
            fg = "#e2f1fa";
          }
          {
            url = "*";
            fg = "#e2f1fa";
          }
          {
            url = "*/";
            fg = "#84c3eb";
          }
        ];
      };
    };
  };
}
