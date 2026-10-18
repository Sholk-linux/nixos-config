pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
    id: root

    signal popupRequested(var entry)

    property list<var> history: []
    property bool dnd: false
    property int  maxHistory: 100

    // ─── Звук ─────────────────────────────────────────────────
    readonly property string soundFile: Quickshell.shellDir + "/notify.wav"

    // Какой плеер доступен: pw-play (PipeWire) или paplay (PulseAudio)
    property string audioPlayer: ""

    // Один раз при старте определяем плеер
    Process {
        id: detectPlayer
        command: ["sh", "-c", "command -v pw-play || command -v paplay"]
        running: true
        stdout: StdioCollector {
            id: detectOut
            onStreamFinished: {
                const p = detectOut.text.trim()
                if (p.length > 0) {
                    root.audioPlayer = p.endsWith("pw-play") ? "pw-play" : "paplay"
                    console.log("notify: audio player =", root.audioPlayer)
                } else {
                    console.warn("notify: no audio player found (need pw-play or paplay)")
                }
            }
        }
    }

    // ─── Воспроизведение со случайной вариацией ───────────────
    function playSound() {
        if (root.audioPlayer === "") return

        // ±4% скорости → ±4% высоты тона
        const rateBase   = 44100
        const rateSpread = 0.04
        const rate = Math.round(rateBase * (1.0 + (Math.random() * 2 - 1) * rateSpread))

        // ±15% громкости
        const volume = (0.9 + Math.random() * 0.3).toFixed(2)

        if (root.audioPlayer === "pw-play") {
            Quickshell.execDetached([
                "pw-play",
                "--rate=" + rate,
                "--volume=" + volume,
                root.soundFile
            ])
        } else {
            // paplay не умеет --rate, только --volume
            Quickshell.execDetached([
                "paplay",
                "--volume=" + Math.round(volume * 65536),
                root.soundFile
            ])
        }
    }

    // ─── Сервер уведомлений ──────────────────────────────────
    NotificationServer {
        id: server
        keepOnReload: false
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: (notif) => {
            notif.tracked = true

            const entry = {
                id: notif.id,
                summary: notif.summary,
                body: notif.body,
                appName: notif.appName,
                appIcon: notif.appIcon,
                urgency: notif.urgency,
                time: new Date(),
                notification: notif
            }

            root.history = [entry, ...root.history].slice(0, root.maxHistory)

            if (!root.dnd) {
                root.playSound()
                root.popupRequested(entry)
            }
        }
    }

    // ─── Управление историей ─────────────────────────────────
    function clearHistory() {
        for (const e of root.history) {
            if (e.notification) e.notification.dismiss()
        }
        root.history = []
    }

    function removeByIndex(idx) {
        if (idx < 0 || idx >= root.history.length) return
        const e = root.history[idx]
        if (e && e.notification) e.notification.dismiss()
        const copy = root.history.slice()
        copy.splice(idx, 1)
        root.history = copy
    }

    function removeEntry(entry) {
        const idx = root.history.indexOf(entry)
        if (idx >= 0) removeByIndex(idx)
    }

    function toggleDnd() {
        root.dnd = !root.dnd
    }
}
