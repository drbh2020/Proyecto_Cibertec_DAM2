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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkFavoriteStatus()
        setupAudioCallback()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AudioPlayerManager.shared.stop()
    }

    private func setupUI() {
        titleLabel.text = track.title
        artistLabel.text = track.artist.name
        albumLabel.text = track.album.title
        durationLabel.text = track.durationFormatted

        // Configurar imagen del cover
        coverImageView.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true

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
            }
        }
    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        if AudioPlayerManager.shared.isPlaying {
            AudioPlayerManager.shared.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            AudioPlayerManager.shared.play(url: track.preview)
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
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
