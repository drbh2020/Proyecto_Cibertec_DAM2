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
        guard let audioURL = URL(string: url) else { return }

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

        player?.play()
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
        onPlaybackFinished?()
    }
}
