//
//  ArtistDetailsModel.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import Foundation

struct ArtistDetailsModel: Codable {
    let id: Int
    let name: String
    let profile: String?
    let realname: String?
    let images: [Image]?
    let members: [Artist]?
    let groups: [Group]?

    var image: String? {
        images?.first(where: { $0.type == .primary })?.uri ?? images?.first?.uri
    }

    var isBand: Bool {
        members?.count ?? 0 > 0
    }
    
    var sortedMembers: [Artist]? {
        members?.sorted { $0.active && !$1.active }
    }
    
    var sortedGroups: [Group]? {
        groups?.sorted { $0.active && !$1.active }
    }
    
    struct Image: Codable {
        let type: ImageType
        let uri: String
        
        enum ImageType: String, Codable {
            case primary
            case secondary
        }
    }
    
    struct Group: Identifiable, Codable, ArtistInfo {
        let id: Int
        let name: String
        let active: Bool
        let thumbnail: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case active
            case thumbnail = "thumbnail_url"
        }
    }
    
    struct Artist: Identifiable, Codable, ArtistInfo {
        let id: Int
        let name: String
        let active: Bool
        let thumbnail: String?
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case active
            case thumbnail = "thumbnail_url"
        }
    }
}
