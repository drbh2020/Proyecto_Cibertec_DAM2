//
//  TrackDetailViewController.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import UIKit

class TrackDetailViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    var track: Track!
    private var isFavorite: Bool = false
    private var progressTimer: Timer?

    // Elementos de progreso creados programáticamente
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progressTintColor = .systemBlue
        progress.trackTintColor = .systemGray5
        progress.progress = 0
        return progress
    }()

    private let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.text = "0:00"
        return label
    }()

    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.text = "-0:30"
        label.textAlignment = .right
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressUI()
        setupUI()
        checkFavoriteStatus()
        setupAudioCallback()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopProgressTimer()
        AudioPlayerManager.shared.stop()
    }

    private func setupProgressUI() {
        // Agregar vistas a la jerarquía
        view.addSubview(progressView)
        view.addSubview(currentTimeLabel)
        view.addSubview(remainingTimeLabel)

        // Configurar constraints
        NSLayoutConstraint.activate([
            // Progress View - debajo del albumLabel
            progressView.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Current Time Label - abajo izquierda del progressView
            currentTimeLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 4),
            currentTimeLabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),

            // Remaining Time Label - abajo derecha del progressView
            remainingTimeLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 4),
            remainingTimeLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor)
        ])
    }

    private func setupUI() {
        titleLabel.text = track.title
        artistLabel.text = track.artist.name
        albumLabel.text = track.album.title
        durationLabel.text = track.durationFormatted

        // Configurar imagen del cover
        coverImageView.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true

        // Inicializar tiempo restante con la duración de la canción
        remainingTimeLabel.text = "-\(track.durationFormatted)"

        // Cargar imagen
        if let coverURL = track.album.coverMedium {
            coverImageView.loadImage(from: coverURL)
        }
    }

    private func checkFavoriteStatus() {
        isFavorite = CoreDataManager.shared.isFavorite(trackId: track.id)
        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = isFavorite ? .systemRed : .systemGray
    }

    private func setupAudioCallback() {
        AudioPlayerManager.shared.onPlaybackFinished = { [weak self] in
            DispatchQueue.main.async {
                self?.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self?.stopProgressTimer()
                self?.resetProgress()
            }
        }
    }

    // MARK: - Progress Management
    private func startProgressTimer() {
        stopProgressTimer()
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateProgress()
        }
    }

    private func stopProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }

    private func updateProgress() {
        let progress = AudioPlayerManager.shared.progress
        let currentTime = AudioPlayerManager.shared.currentTime
        let duration = AudioPlayerManager.shared.duration

        progressView.progress = progress

        // Actualizar tiempo actual
        let currentMinutes = Int(currentTime) / 60
        let currentSeconds = Int(currentTime) % 60
        currentTimeLabel.text = String(format: "%d:%02d", currentMinutes, currentSeconds)

        // Actualizar tiempo restante
        let remaining = duration - currentTime
        let remainingMinutes = Int(remaining) / 60
        let remainingSeconds = Int(remaining) % 60
        remainingTimeLabel.text = String(format: "-%d:%02d", remainingMinutes, remainingSeconds)
    }

    private func resetProgress() {
        progressView.progress = 0
        currentTimeLabel.text = "0:00"
        remainingTimeLabel.text = "-\(track.durationFormatted)"
    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        if AudioPlayerManager.shared.isPlaying {
            AudioPlayerManager.shared.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            stopProgressTimer()
        } else {
            AudioPlayerManager.shared.play(url: track.preview)
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            startProgressTimer()
        }
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if isFavorite {
            CoreDataManager.shared.removeFavorite(trackId: track.id)
        } else {
            CoreDataManager.shared.saveFavorite(track: track)
        }
        isFavorite.toggle()
        updateFavoriteButton()
    }
}
