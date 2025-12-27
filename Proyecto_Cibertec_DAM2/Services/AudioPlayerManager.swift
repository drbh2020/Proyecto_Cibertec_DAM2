//
//  AudioPlayerManager.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import Foundation
import AVFoundation

class AudioPlayerManager: NSObject {
    static let shared = AudioPlayerManager()

    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?

    var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }

    // Tiempo actual de reproducción en segundos
    var currentTime: Double {
        guard let player = player else { return 0 }
        let time = CMTimeGetSeconds(player.currentTime())
        return time.isNaN ? 0 : time
    }

    // Duración total del audio en segundos
    var duration: Double {
        guard let playerItem = playerItem else { return 0 }
        let time = CMTimeGetSeconds(playerItem.duration)
        return time.isNaN ? 0 : time
    }

    // Progreso de 0.0 a 1.0
    var progress: Float {
        let current = currentTime
        let total = duration
        guard total > 0 else { return 0 }
        return Float(current / total)
    }

    var onPlaybackFinished: (() -> Void)?

    private override init() {
        super.init()
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }

    func play(url: String) {
        guard let audioURL = URL(string: url) else {
            print("❌ Error: URL de audio inválida")
            return
        }

        print("🎵 Reproduciendo: \(audioURL)")

        // Detener reproducción anterior
        stop()

        playerItem = AVPlayerItem(url: audioURL)
        player = AVPlayer(playerItem: playerItem)

        // Observer para cuando termina
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )

        // Observer para errores
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFailToPlay),
            name: .AVPlayerItemFailedToPlayToEndTime,
            object: playerItem
        )

        player?.play()
        print("▶️ Reproducción iniciada")
    }

    func pause() {
        player?.pause()
    }

    func resume() {
        player?.play()
    }

    func stop() {
        player?.pause()
        player = nil
        playerItem = nil
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            resume()
        }
    }

    @objc private func playerDidFinishPlaying() {
        print("✅ Reproducción terminada")
        onPlaybackFinished?()
    }

    @objc private func playerDidFailToPlay(notification: Notification) {
        if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error {
            print("❌ Error en reproducción: \(error.localizedDescription)")
        }
    }
}
