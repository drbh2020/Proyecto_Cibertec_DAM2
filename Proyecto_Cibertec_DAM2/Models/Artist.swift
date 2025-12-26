//
//  Artist.swift
//  Proyecto_Cibertec_DAM2
//
//  Created by user286645 on 12/26/25.
//

import Foundation

struct Artist: Codable {
    let id: Int
    let name: String
    let pictureMedium: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case pictureMedium = "picture_medium"
    }
}
