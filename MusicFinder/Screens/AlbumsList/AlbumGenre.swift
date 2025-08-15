//
//  AlbumGenre.swift
//  MusicFinder
//
//  Created by 6od9i on 12/08/25.
//

import Foundation

extension AlbumsFiltersDTO {
    var genreValue: AlbumGenre? {
        guard let genre, genre.isEmpty == false else { return nil }
        return AlbumGenre.allCases.first(where: { $0.rawValue == genre }) ?? .custom(genre)
    }
}

enum AlbumGenre: CaseIterable, Identifiable, CustomStringConvertible, Hashable {
    case rock, pop, jazz, metal, classical, electronic
    case custom(String)
    
    var id: String { self.rawValue }
    
    var rawValue: String {
        switch self {
        case .rock: return "rock"
        case .pop: return "pop"
        case .jazz: return "jazz"
        case .metal: return "metal"
        case .classical: return "classical"
        case .electronic: return "electronic"
        case .custom(let value): return value.isEmpty ? "custom" : value
        }
    }
    
    static var allCases: [Self] {
        [.rock, .pop, .jazz, .metal, .classical, .electronic, .custom("")]
    }
    
    var description: String { self.rawValue.capitalized }
}
