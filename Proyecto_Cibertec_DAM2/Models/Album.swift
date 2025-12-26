//
//  Album.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import Foundation

struct Album: Codable {
    let id: Int
    let title: String
    let coverMedium: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case coverMedium = "cover_medium"
    }
}
