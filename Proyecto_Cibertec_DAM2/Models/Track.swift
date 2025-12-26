//
//  Track.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import Foundation

struct Track: Codable {
    let id: Int
    let title: String
    let duration: Int
    let preview: String
    let artist: Artist
    let album: Album

    // Computed property para duración formateada
    var durationFormatted: String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
