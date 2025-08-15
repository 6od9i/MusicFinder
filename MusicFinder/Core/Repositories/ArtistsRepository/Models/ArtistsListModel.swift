//
//  ArtistsListModel.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import Foundation

struct ArtistsListModel: Codable {
    let pagination: Pagination
    let results: [Artist]
    
    struct Artist: Codable, Identifiable, ArtistInfo {
        let id: Int
        let name: String
        let thumbnail: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name = "title"
            case thumbnail = "thumb"
        }
    }
}
