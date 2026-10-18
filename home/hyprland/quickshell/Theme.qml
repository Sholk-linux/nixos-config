pragma Singleton
import QtQuick

QtObject {
    // ═══════════════════════════════════════════════════════
    //  ПАЛИТРА POLAR NIGHT
    // ═══════════════════════════════════════════════════════
    readonly property color bg:         "#202936"   // color0  — фон панели
    readonly property color empty:      "#303d52"   // color8  — пустой стол / кнопка off
    readonly property color filled:     "#a2d5f7"   // color12 — стол с окнами, акценты
    readonly property color active:     "#84c3eb"   // color4  — текущий стол, hover
    readonly property color urgent:     "#f0a3aa"   // color1  — urgent, DND, ошибки
    readonly property color text:       "#e2f1fa"   // color7  — основной текст
    readonly property color textActive: "#202936"   // на светлых фонах

    // ═══════════════════════════════════════════════════════
    //  ПРОЗРАЧНЫЕ СЛОИ (для hover, границ, теней)
    // ═══════════════════════════════════════════════════════
    readonly property color surface1:   Qt.rgba(1, 1, 1, 0.04)   // обычный фон карточки
    readonly property color surface2:   Qt.rgba(1, 1, 1, 0.08)   // фон при hover
    readonly property color borderSoft: Qt.rgba(0.5, 0.8, 1, 0.12) // мягкая граница панели/попапа
    readonly property color divider:    Qt.rgba(0.5, 0.8, 1, 0.10) // разделитель
    readonly property color shadow:     Qt.rgba(0, 0, 0, 0.45)    // тень попапов
    readonly property color textDim:    Qt.rgba(0.8, 0.9, 1, 0.7)  // приглушённый текст (body)
    readonly property color textFaint:  Qt.rgba(0.8, 0.9, 1, 0.4)  // совсем тусклый (время, пусто)

    // ═══════════════════════════════════════════════════════
    //  РАЗМЕРЫ
    // ═══════════════════════════════════════════════════════
    readonly property int pillSize:  28    // размер квадратика стола
    readonly property int rowHeight: 28    // высота виджетов в панели
    readonly property int barHeight: 44    // высота всей панели
    readonly property int radius:    12    // крупное скругление (панель, попап)
    readonly property int radiusSm:  8     // мелкое (столы, карточки)
    readonly property int radiusXs:  4     // микро (кнопки удаления)

    // ═══════════════════════════════════════════════════════
    //  ТАЙМИНГИ АНИМАЦИЙ (мс)
    // ═══════════════════════════════════════════════════════
    readonly property int fast:   120   // цвет, мелкие переходы
    readonly property int normal: 180   // hover, scale
    readonly property int slow:   280   // появление, крупные переходы
    readonly property int popup:  4200  // сколько висит уведомление

    // ═══════════════════════════════════════════════════════
    //  EASING
    // ═══════════════════════════════════════════════════════
    readonly property int easeOut:  Easing.OutCubic    // для появления
    readonly property int easeBack: Easing.OutBack     // для отскоков
    readonly property int easeSoft: Easing.InOutSine   // для пульсаций

    // ═══════════════════════════════════════════════════════
    //  ШРИФТ
    // ═══════════════════════════════════════════════════════
    // Nerd Font нужен только для глифов в виджетах (CPU, RAM, сеть, раскладка, колокольчик).
    // Иконки приложений берутся из системы через DesktopEntries + Quickshell.iconPath.
    readonly property string mono: "JetBrainsMono Nerd Font"

    // ═══════════════════════════════════════════════════════
    //  УТИЛИТЫ
    // ═══════════════════════════════════════════════════════
    // Цвет прогресс-бара по проценту (0-100)
    function usageColor(pct) {
        if (pct > 80) return urgent
        if (pct > 50) return filled
        return active
    }

    // Цвет прогресс-бара по доле (0.0-1.0)
    function ratioColor(ratio) {
        if (ratio > 0.85) return urgent
        if (ratio > 0.60) return filled
        return active
    }
}
