//
//  TrackTableViewCell.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        // Configurar imagen del cover
        coverImageView.layer.cornerRadius = 5
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
    }

    // Configurar con Track
    func configure(with track: Track) {
        titleLabel.text = track.title
        artistLabel.text = track.artist.name
        durationLabel.text = track.durationFormatted

        // Cargar imagen
        if let coverURL = track.album.coverMedium {
            coverImageView.loadImage(from: coverURL)
        } else {
            coverImageView.image = UIImage(systemName: "music.note")
        }
    }

    // Configurar con FavoriteSong (Core Data)
    func configure(with favorite: FavoriteSong) {
        titleLabel.text = favorite.title
        artistLabel.text = favorite.artistName

        // Formatear duración
        let minutes = Int(favorite.duration) / 60
        let seconds = Int(favorite.duration) % 60
        durationLabel.text = String(format: "%d:%02d", minutes, seconds)

        // Cargar imagen
        if let coverURL = favorite.coverURL {
            coverImageView.loadImage(from: coverURL)
        } else {
            coverImageView.image = UIImage(systemName: "music.note")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = UIImage(systemName: "music.note")
        titleLabel.text = nil
        artistLabel.text = nil
        durationLabel.text = nil
    }
}
