//
//  AlbumsListModel.swift
//  MusicFinder
//
//  Created by 6od9i on 11/08/25.
//

import Foundation

struct AlbumsListModel: Codable {
    let pagination: Pagination
    let results: [Album]

    struct Album: Codable, Identifiable {
        let id: Int
        let type: String?
        let title: String?
        let year: String?
        let genre: [String]?
        let style: [String]?
        let label: [String]?
        let thumbnail: String?
        let coverImage: String?
        let country: String?
        let format: [String]?

        enum CodingKeys: String, CodingKey {
            case id, type, title, year, genre, style, label, country, format
            case thumbnail = "thumb"
            case coverImage = "cover_image"
        }
    }
}
