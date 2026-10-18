{ ... }:

{

  # 2. Конфиг wofi (базовые настройки)
  xdg.configFile."wofi/config".text = ''
    width=40%
    height=30%
    prompt=Запуск:
    allow_images=true
    normal_window=false
    show=drun
    insensitive=true
  '';

  # 3. CSS-стиль для wofi (вся красота)
  xdg.configFile."wofi/style.css".text = ''
    window {
        background-color: rgba(20, 20, 30, 0.85);
        border-radius: 16px;
        border: 1px solid rgba(70, 130, 255, 0.3);
        font-family: "JetBrains Mono", monospace;
    	overflow: hidden;          /* чтобы скругление работало правильно */
    }

    #entry {
        background-color: transparent;
        color: #ffffff;
        font-size: 16px;
        padding: 8px 16px;
        border: none;
    }

    #entry:selected {
        background-color: #4a9eff;
        border-radius: 8px;
        color: #ffffff;
    }

    #list {
        padding: 4px 0;
    }

    #text {
        color: #cdd6f4;
        font-size: 14px;
    }

    #text:selected {
        color: #ffffff;
    }

    #img {
        margin-right: 12px;
    }

    scrollbar {
        background-color: transparent;
        width: 6px;
    }

    scrollbar slider {
        background-color: #4a9eff;
        border-radius: 4px;
    }
  '';
}
