//
//  ChartCollectionViewCell.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import UIKit

class ChartCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        // Configurar imagen del cover
        coverImageView.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill

        // Configurar sombra de la celda
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false

        // Configurar labels
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 2
        artistLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        artistLabel.textColor = .systemGray
    }

    func configure(with track: Track) {
        titleLabel.text = track.title
        artistLabel.text = track.artist.name

        // Cargar imagen
        if let coverURL = track.album.coverMedium {
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
    }
}
