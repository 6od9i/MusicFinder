//
//  File.swift
//  MusicFinderTests
//
//  Created by 6od9i on 13/08/25.
//

import Foundation

#if DEBUG || TESTING

extension AlbumsListModel.Album {
    static var mock: AlbumsListModel.Album { .mock() }
    
    static func mock(
        id: Int = 1,
        type: String = "release",
        title: String = "Mock Album",
        year: String = "1990",
        genre: [String] = ["Rock"],
        style: [String] = ["Punk", "Grunge"],
        label: [String] = ["POP SUB"],
        thumbnail: String = "https://i.discogs.com/6QIzL7eXXChdca1lneVv5V1QLhB-Rznzb8vwbxVm6kY/rs:fit/g:sm/q:40/h:150/w:150/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTIzMjYx/MDQtMTMyMzk0NDA2/NS5qcGVn.jpeg",
        coverImage: String = "https://i.discogs.com/9CbEg-Cgz8g_brIy_Rn1mWH7hPBRaBsoEQQ5q2IPzjw/rs:fit/g:sm/q:90/h:300/w:297/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTIzMjYx/MDQtMTMyMzk0NDA2/NS5qcGVn.jpeg",
        country: String = "USA",
        format: [String] = ["Vinyl"]
    ) -> AlbumsListModel.Album {
        .init(
            id: id,
            type: type,
            title: title,
            year: year,
            genre: genre,
            style: style,
            label: label,
            thumbnail: thumbnail,
            coverImage: coverImage,
            country: country,
            format: format
        )
    }
}

#endif
