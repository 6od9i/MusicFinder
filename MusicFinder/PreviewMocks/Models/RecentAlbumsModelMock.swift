//
//  RecentAlbumsModelMock.swift
//  MusicFinder
//
//  Created by 6od9i on 13/08/25.
//

import Foundation

#if DEBUG || TESTING

extension RecentAlbumsModel.Release {
    static func mock(title: String = "Some Album",
                     thumbnail: String? = "https://i.discogs.com/aQZr7jjKE_3BwzwzIevYEH4Cr9R2PLehZKmLavb83Ec/rs:fit/g:sm/q:40/h:150/w:150/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTQwMDY1/OC0xMTcxNjU4NzQw/LmpwZWc.jpeg",
                     year: Int? = 1993,
                     type: String = "master",
                     mainRelease: Int? = 400658,
                     artist: String = "Some Artist",
                     role: String = "Main") -> RecentAlbumsModel.Release {
        RecentAlbumsModel.Release(
            id: 103, title: title, thumbnail: thumbnail, year: year, type: type,
            mainRelease: mainRelease, artist: artist, role: role
        )
    }
}

#endif
