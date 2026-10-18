{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "lua";

    # Полное соответствие официальному эталону Lua API
    extraConfig = ''
                                                      -----------------------------
                                                      ---- СИСТЕМНЫЕ НАСТРОЙКИ ----
                                                      -----------------------------
                                                      hl.config({
                                                        input = {
                                                          kb_layout = "us,ru",
                                                          kb_options = "grp:caps_toggle",
                                                        },

                                                        decoration = {
                                                          rounding = 10,

                                          				active_opacity = 0.95,      -- Прозрачность активного окна (85%)
                                                    		inactive_opacity = 0.9,    -- Прозрачность окон на заднем плане (75%)
                                                    		fullscreen_opacity = 1.0,

                                                          blur = {
                                                            enabled = true,
                                                      	  size = 8,                 -- Радиус размытия (чем больше, тем сильнее размытие)
                                                      	  passes = 3,               -- Количество проходов (3 дает идеальный мягкий эффект)
                                                      	  new_optimizations = true, -- Оптимизация производительности
                                                      	  ignore_opacity = true,   -- Игнорировать прозрачность самого окна, чтобы блюр не ломался
                                                      	  xray = false,				-- Эффект рентгена (выключен для лучшей читаемости)
                                    					  	},

                                                          shadow = {
                                                            enabled = true,
                                                            range = 6,
                                                            render_power = 3,
                                                            color = "rgba(74, 158, 255, 1)",
                                                          },
                                                        },
                                                      })

      												hl.monitor({
        													output   = "HDMI-A-1",
        													mode     = "2560x1440@119.99",
        													position = "0x0",
        													scale    = 1,
      												})

                                                      --------------------------
                                                      ---- ГОРЯЧИЕ КЛАВИШИ ----
                                                      --------------------------
                                                      local mainMod = "ALT"

                                                      -- Управление программами и окнами
                                                      hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty"))
                                                      hl.bind(mainMod .. " + Q", hl.dsp.window.kill())
                                                      hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
                                                      hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("wofi --show drun"))

                                                      -- Перемещение и изменение размера плавающих окон мышью
                                                      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
                                                      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

                                                      -- Смена фокуса окон (movefocus)
                                                      hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
                                                      hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
                                                      hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
                                                      hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

                                                      -- Перемещение окон (swapwindow)
                                                      hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.swap({ direction = "left" }))
                                                      hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
                                                      hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.swap({ direction = "up" }))
                                                      hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.swap({ direction = "down" }))

                                                     -- Скриншоты
            										 -- Скриншот всего экрана
            										 hl.bind("PRINT", hl.dsp.exec_cmd([[sh -c 'grim - | tee ~/Изображения/"Снимки экрана"/$(date +"%Y-%m-%d_%H-%M-%S").png | wl-copy && notify-send "Скриншот" "Экран сохранён"']]))

            										 -- Скриншот выделенной области
            										 hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | tee ~/Изображения/"Снимки экрана"/$(date +"%Y-%m-%d_%H-%M-%S").png | wl-copy && notify-send "Скриншот" "Область сохранена"']]))

            										 -- Скриншот области с открытием в swappy
            										 hl.bind("CTRL + PRINT", hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | swappy -f -']]))


                              						  -- Изменение размера (resizeactive)
                                                      hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.resize({ x = -60, y = 0, relative = true }))
                                                      hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 60, y = 0, relative = true }))
                                                      hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.resize({ x = 0, y = -60, relative = true }))
                                                      hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.resize({ x = 0, y = 60, relative = true }))

                                                      -- Автогенерация ворксейсов 1-10
                                                      for i = 1, 10 do
                                                        local key = i % 10
                                                        hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
                                                        hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
                                                      end

                                                      -----------------------
                                                      ---- ПРАВИЛА ОКОН ----
                                                      -----------------------
                                                      hl.window_rule({
                                                          name  = "noblur-mpv",
                                                          match = { class = "mpv" },
                                                          no_blur = true,
                                                      })

                                                      hl.window_rule({
                                                          name  = "noblur-fullscreen",
                                                          match = { fullscreen = true },
                                                          no_blur = true,
                                                      })

                                                      hl.window_rule({
                                                          name  = "noblur-steam",
                                                          match = { class = "steam_app_.*" },
                                                          no_blur = true,
                                                      })

                                                      --------------------
                                                      ---- АВТОЗАПУСК ----
                                                      --------------------
                                                      hl.on("hyprland.start", function()
                                                    	  -- Запуск статус-бара
                                                    	  hl.exec_cmd("sleep 2 && qs -p ~/.nix/home/hyprland/quickshell")
                                                    
                                                    	  -- Запуск менеджера обоев и установка картинки в одну строку
                                                    	  -- Это решает проблему, когда 'awww img' падает из-за еще не загруженного демона
                                                    	  hl.exec_cmd("awww-daemon && sleep 2 && awww img '/home/sholk/.nix/home/hyprland/wallpaper.png'")
                                                	  end)
    '';
  };
}
