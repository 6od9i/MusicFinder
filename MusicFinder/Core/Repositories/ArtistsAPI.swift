//
//  ArtistsAPI.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import Foundation

/// All API requests for the artists with parameters
enum ArtistsAPI: APIEndpointProtocol {
    static let baseURL: String = "https://api.discogs.com/"
    
    case searchArtists(query: String, page: Int, perPage: Int)
    case artistDetails(artistId: Int)
    case recentAlbums(artistId: Int, page: Int, perPage: Int)
    case searchAlbums(
        artistId: Int, page: Int, perPage: Int, year: Int? = nil, genre: String? = nil, label: String? = nil,
        sort: String? = "year", sortOrder: String? = "desc"
    )

    private var currentPath: String {
        switch self {
        case .searchArtists(let query, let page, let perPage):
            return "database/search?q=\(query)&type=artist&page=\(page)&per_page=\(perPage)"
            
        case .artistDetails(let artistId):
            return "/artists/\(artistId)"
            
        case .recentAlbums(let artistId, let page, let perPage):
            return "/artists/\(artistId)/releases?sort=year&sort_order=desc&page=\(page)&per_page=\(perPage)"
            
        case .searchAlbums(
            let artistId, let page, let perPage, let year,
            let genre, let label, let sort, let sortOrder
        ):
            var queryItems: [String] = []
            
            queryItems.append("artist_id=\(artistId)")
            queryItems.append("type=release")
            queryItems.append("page=\(page)")
            queryItems.append("per_page=\(perPage)")
            
            if let year {
                queryItems.append("year=\(year)")
            }
            if let genre {
                queryItems.append("genre=\(genre.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
            }
            if let label {
                queryItems.append("label=\(label.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
            }
            if let sort {
                queryItems.append("sort=\(sort)")
            }
            if let sortOrder {
                queryItems.append("sort_order=\(sortOrder)")
            }
            
            return "database/search?" + queryItems.joined(separator: "&")
        }
    }
    
    var path: String {
        Self.baseURL + currentPath
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String: String] {
        ["Accept": "application/json"].merging(authHeader) { $1 }
    }
    
    private var authHeader: [String: String] {
        ["Authorization": "Discogs token=\(RequestsSettings.authToken)"]
    }
}
