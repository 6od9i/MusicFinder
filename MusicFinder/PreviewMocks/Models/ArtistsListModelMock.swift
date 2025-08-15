//
//  ArtistsListModelMock.swift
//  MusicFinder
//
//  Created by 6od9i on 13/08/25.
//

import Foundation

#if DEBUG || TESTING

extension ArtistsListModel {
    static func mock(pagination: Pagination = .mock, results: [Artist] = [.mock]) -> ArtistsListModel {
        ArtistsListModel(pagination: pagination, results: results)
    }
}

extension ArtistsListModel.Artist {
    static func mock(id: Int = 101, name: String = "Mock Artist", thumbnail: String = "https://i.discogs.com/yRQXmyjuMqPC3Cz5Df3MdnPBsvCV3mgdvvBDDlYTSx4/rs:fit/g:sm/q:40/h:150/w:150/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9BLTIwODkx/OC0xMzc1NTE1NTQy/LTEwMjkuanBlZw.jpeg") -> ArtistsListModel.Artist {
           return ArtistsListModel.Artist(id: id, name: name, thumbnail: thumbnail)
       }
    
    static var mock: ArtistsListModel.Artist {
        mock()
    }
}

#endif
