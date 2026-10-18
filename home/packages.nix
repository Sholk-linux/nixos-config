{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # ─── Браузеры ───────────────────────────────────────────
    firefox
    librewolf

    # ─── Игры и лаунчеры ────────────────────────────────────
    prismlauncher
    lutris

    # ─── 3D / графика / дизайн ──────────────────────────────
    blender
    blockbench
    gimp

    # ─── Виртуализация / эмуляция ───────────────────────────
    qemu_kvm
    qemu-utils

    # ─── Файлы / архивы / передача ──────────────────────────
    yazi
    unzip
    localsend
    qbittorrent

    # ─── Терминал / CLI / TUI ───────────────────────────────
    kitty
    nushell
    starship
    zsh-powerlevel10k
    bat
    fastfetch
    lavat
    pipes-rs
    peaclock

    # ─── Wayland / десктоп-интеграция ───────────────────────
    quickshell
    xcb-util-cursor
    wofi
    awww
    mako
    libnotify
    dconf-editor
    pavucontrol
    wl-clipboard

    # ─── Скриншоты ──────────────────────────────────────────
    grim
    slurp
    swappy

    # ─── Мультимедиа / аудио ────────────────────────────────
    ffmpeg

    # ─── Разработка ─────────────────────────────────────────
    python3
    gcc
    binutils
    pkg-config
    direnv
    temurin-bin-21
    (pkgs.rust-bin.stable.latest.default.override {
      extensions = [
        "clippy"
        "rustfmt"
        "rust-analyzer"
        "rust-src"
        "rust-docs"
      ];
    })

    # ─── Офис / заметки / словари ───────────────────────────
    libreoffice-qt
    obsidian
    hunspell
    hunspellDicts.ru_RU

    # ─── Общение ────────────────────────────────────────────
#    discord
#    (pkgs.callPackage ./pkgs/discord-fetch.nix { })

    # ─── Шрифты ─────────────────────────────────────────────
    inter
  ];

  services.flatpak = {
    enable = true;
    # Список устанавливаемых пакетов в формате "remote:app/id"
    packages = [
      # Игры (Roblox/Sober)
      "flathub:app/org.vinegarhq.Sober/x86_64/stable"
      # Мультимедиа / запись (OBS Studio)
      "flathub:app/com.obsproject.Studio/x86_64/stable"
    ];
    # Удалённые репозитории (можно добавить beta)
    remotes = {
      flathub = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      # flathub-beta = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
  };
}
