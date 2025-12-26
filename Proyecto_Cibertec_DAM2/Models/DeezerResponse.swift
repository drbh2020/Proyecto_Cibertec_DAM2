//
//  DeezerResponse.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import Foundation

struct DeezerResponse: Codable {
    let data: [Track]
    let total: Int?
    let next: String?
}

struct ChartResponse: Codable {
    let tracks: TrackList
}

struct TrackList: Codable {
    let data: [Track]
}
