{
  programs.librewolf = {
    enable = true;

    # Общие скрытые настройки для about:config
    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "sidebar.verticalTabs" = true;
      "browser.tabs.inTitlebar" = 1;
      "privacy.resistFingerprinting" = false;
      "webgl.disabled" = false;
    };

    # Опции интерфейса прописываются строго ВНУТРИ конкретного профиля
    profiles.default = {
      userChrome = ''
        /* Скрываем дефолтную горизонтальную панель вкладок */
        #TabsToolbar {
          visibility: collapse !important;
        }

        /* Убираем лишние рамки и отступы боковой панели, чтобы Sidebery сливался с окном */
        #sidebar-box {
          border-right: none !important;
        }
        #sidebar-header {
          display: none !important; /* Убираем заголовок "Боковая панель" */
        }
      '';
    };
  };
}
