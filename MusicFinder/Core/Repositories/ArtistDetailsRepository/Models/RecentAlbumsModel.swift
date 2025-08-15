//
//  RecentAlbumsModel.swift
//  MusicFinder
//
//  Created by 6od9i on 10/08/25.
//

import Foundation

struct RecentAlbumsModel: Codable {
    let pagination: Pagination
    let releases: [Release]
    
    struct Release: Codable, Identifiable {
        let id: Int
        let title: String
        let thumbnail: String?
        let year: Int?
        let type: String
        let mainRelease: Int?
        let artist: String
        let role: String
        
        enum CodingKeys: String, CodingKey {
            case id, title, type, artist, role, year
            case mainRelease = "main_release"
            case thumbnail = "thumb"
        }
    }
}
