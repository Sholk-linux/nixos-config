{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # === Базовые опции Neovim ===
    opts = {
      number = true;
      relativenumber = false;
      termguicolors = true;
      tabstop = 4;
      shiftwidth = 4;
      clipboard = "unnamedplus";
    };

    clipboard = {
      register = "unnamedplus"; # Использовать системный буфер по умолчанию
      providers.wl-copy.enable = true; # Включить провайдер wl-copy для Wayland
    };

    # === Глобальные переменные (лидер) ===
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # === Диагностика (отдельный модуль, НЕ внутри lsp) ===
    diagnostic.settings = {
      virtual_text = true;
      severity_sort = true;
      float = {
        border = "rounded";
      };
    };

    # === Цветовая схема Polar Night через base16 ===
    colorschemes.base16 = {
      enable = true;
      autoLoad = true;
      colorscheme = {
        base00 = "#161c23"; # background (фон Kitty)
        base01 = "#202936"; # color0 (статус-бары, тёмный фон)
        base02 = "#243345"; # selection_background
        base03 = "#5d7094"; # color8 (комментарии)
        base04 = "#a2d5f7"; # color12 (тёмный передний план)
        base05 = "#e2f1fa"; # foreground (основной текст)
        base06 = "#f4faff"; # color15 (светлый передний план)
        base07 = "#f4faff"; # color15 (светлый фон)
        base08 = "#f0a3aa"; # color1 (красный — переменные)
        base09 = "#fbc3c8"; # color9 (оранжевый — числа)
        base0A = "#f5dbaa"; # color3 (жёлтый — классы)
        base0B = "#9ee5d4"; # color2 (зелёный — строки)
        base0C = "#a6e3ed"; # color6 (циан — поддержка)
        base0D = "#84c3eb"; # color4 (синий — функции)
        base0E = "#d6bbf0"; # color5 (маджента — ключевые слова)
        base0F = "#ebd9fc"; # color13 (устаревшее)
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-nix
      friendly-snippets
    ];

    # === Плагины ===
    plugins = {
      # --- Статус-бар ---
      lualine = {
        enable = true;
        settings.options = {
          theme = "base16";
          globalstatus = true;
        };
      };

      # --- Файловый менеджер ---
      nvim-tree = {
        enable = true;
        settings = {
          view = {
            width = 30;
            side = "left";
          };
          renderer = {
            group_empty = true;
          };
          filters = {
            dotfiles = false;
          };
        };
      };

      # --- Поиск (Telescope) ---
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            options = {
              desc = "Поиск файлов";
            };
          };
          "<leader>fg" = {
            action = "live_grep";
            options = {
              desc = "Поиск текста";
            };
          };
        };
      };

      # --- Сниппеты ---
      luasnip = {
        enable = true;
        fromVscode = [ { } ];
      };
      friendly-snippets = {
        enable = true;
      };

      # --- Дерево синтаксиса (Treesitter) ---
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          rust
          lua
          python
          go
          javascript
          typescript
          html
          css
          markdown
        ];
        settings = {
          highlight = {
            enable = true;
          };
          indent = {
            enable = true;
          };
        };
      };

      # --- Автодополнение (blink.cmp) ---
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "none";
            "<C-Space>" = [
              "show"
              "show_documentation"
              "hide_documentation"
            ];
            "<Up>" = [
              "select_prev"
              "fallback"
            ];
            "<Down>" = [
              "select_next"
              "fallback"
            ];
            "<C-n>" = [
              "select_next"
              "fallback"
            ];
            "<C-p>" = [
              "select_prev"
              "fallback"
            ];
            "<CR>" = [
              "accept"
              "fallback"
            ];
            "<Tab>" = [
              "accept"
              "fallback"
            ];
            "<Esc>" = [
              "hide"
              "fallback"
            ];
          };
          snippets = {
            preset = "luasnip";
          };
          completion = {
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 500;
            };
          };
          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
          };
        };
      };

      # --- Форматирование (conform.nvim) ---
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            rust = [ "rustfmt" ];
            nix = [ "nixfmt" ];
          };
          format_on_save = {
            timeout_ms = 500;
            lsp_format = "fallback";
          };
        };
      };

      # --- Автозакрытие скобок и кавычек ---
      nvim-autopairs.enable = true;

      # --- Подсказки по горячим клавишам ---
      which-key = {
        enable = true;
        settings = {
          preset = "modern";
        };
      };

      # === LSP ===
      lsp = {
        enable = true;

        keymaps = {
          silent = true;
          lspBuf = {
            gd = {
              action = "definition";
              desc = "Перейти к определению";
            };
            gr = {
              action = "references";
              desc = "Ссылки";
            };
            gi = {
              action = "implementation";
              desc = "Реализации";
            };
            K = {
              action = "hover";
              desc = "Документация";
            };
            "<leader>rn" = {
              action = "rename";
              desc = "Переименовать";
            };
            "<leader>ca" = {
              action = "code_action";
              desc = "Действия";
            };
          };
          diagnostic = {
            "[d" = {
              action = "goto_prev";
              desc = "Пред. ошибка";
            };
            "]d" = {
              action = "goto_next";
              desc = "След. ошибка";
            };
            "<leader>d" = {
              action = "open_float";
              desc = "Показать ошибку";
            };
          };
        };

        servers = {
          nil_ls.enable = true;
          pyright.enable = true;
          gopls.enable = true;
          html.enable = true;
          cssls.enable = true;
          ts_ls.enable = true;
          marksman.enable = true;
          qmlls = {
            enable = true;
            cmd = [
              "qmlls"
              "-E"
            ];
          };
        };
      };

      # === Rust ===
      rustaceanvim = {
        enable = true;
      };

      crates = {
        enable = true;
        autoLoad = true;
      };

      web-devicons.enable = true;
    };

    # === Внешние пакеты (LSP, форматтеры) ===
    extraPackages = with pkgs; [
      rustup
      nil
      nixfmt
      pyright
      gopls
      vscode-langservers-extracted
      marksman
      qt6.qtdeclarative
      wl-clipboard
      curl
      ripgrep
    ];

    # === Горячие клавиши (вне LSP) ===
    keymaps = [
      {
        mode = "n";
        key = "<F5>";
        action = "<cmd>split | term | resize 15<CR>";
        options.silent = true;
      }
      {
        mode = "t";
        key = "<Esc>";
        action = "<C-\\><C-n>";
        options.silent = true;
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>NvimTreeToggle<CR>";
        options.desc = "Файловый менеджер";
      }
      {
        mode = "n";
        key = "<leader>ef";
        action = "<cmd>NvimTreeFindFile<CR>";
        options.desc = "Найти файл в дереве";
      }
    ];
  };
}
