//
//  Pagination.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import Foundation

struct Pagination: Codable {
    let page: Int
    let pages: Int
    let perPage: Int
    let items: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perPage = "per_page"
        case items
    }
}
