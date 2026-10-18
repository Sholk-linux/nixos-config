pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: root

    // ═══════════════════════════════════════════════════════════
    //  MASTER — через wpctl (опрос раз в 2 секунды)
    // ═══════════════════════════════════════════════════════════
    property real masterVolume: 0
    property bool masterMuted: false
    property bool masterReady: false

    // Пока пользователь тащит слайдер — не опрашиваем wpctl,
    // чтобы значение не «откатывалось» назад
    property bool sliderActive: false

    // Микшер открыт? Пока false — не трогаем PipeWire вообще
    property bool mixerOpen: false

    Process {
        id: masterReadProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: false
        stdout: StdioCollector {
            id: masterOut
            onStreamFinished: {
                if (root.sliderActive) return
                const raw = masterOut.text
                const m = raw.match(/Volume:\s*([\d.]+)/)
                if (m) {
                    root.masterVolume = parseFloat(m[1])
                    root.masterReady = true
                }
                root.masterMuted = raw.includes("[MUTED]")
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!root.sliderActive) masterReadProc.running = true
        }
    }

    function setMasterVolume(vol) {
        const v = Math.max(0, Math.min(1.5, vol))
        root.masterVolume = v
        Quickshell.execDetached([
            "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", v.toFixed(2)
        ])
    }

    function toggleMasterMute() {
        root.masterMuted = !root.masterMuted
        Quickshell.execDetached([
            "wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"
        ])
    }

    // ═══════════════════════════════════════════════════════════
    //  STREAMS — только когда микшер открыт
    // ═══════════════════════════════════════════════════════════
    readonly property var streams: {
        if (!root.mixerOpen) return []
        const list = []
        for (const node of Pipewire.nodes.values) {
            if (!node.isStream) continue
            if (!node.isSink) continue
            const cls = node.properties ? node.properties["media.class"] : ""
            if (cls !== "Stream/Output/Audio") continue
            if (!node.audio) continue
            list.push(node)
        }
        return list
    }

    // Привязываем узлы только при открытом микшере
    PwObjectTracker {
        objects: root.mixerOpen ? root.streams : []
    }

    function setStreamVolume(node, volume) {
        if (!node || !node.audio) return
        node.audio.volume = Math.max(0, Math.min(1.5, volume))
    }

    function toggleStreamMute(node) {
        if (!node || !node.audio) return
        node.audio.muted = !node.audio.muted
    }
}
