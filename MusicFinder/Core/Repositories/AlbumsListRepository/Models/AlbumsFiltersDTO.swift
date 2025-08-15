//
//  AlbumsFiltersDTO.swift
//  MusicFinder
//
//  Created by 6od9i on 12/08/25.
//

import Foundation

struct AlbumsFiltersDTO: Equatable, CustomStringConvertible {
    var year: Int?
    var genre: String?
    var label: String?
    
    var isEmpty: Bool { year == nil && genre?.isEmpty ?? true && label?.isEmpty ?? true }
    
    var description: String {
        var text = ""
        if let year {
            text.append("year=\(year)")
        }
        if let genre {
            text.append("genre=\(genre)")
        }
        if let label {
            text.append("label=\(label)")
        }
        return text
    }
}
