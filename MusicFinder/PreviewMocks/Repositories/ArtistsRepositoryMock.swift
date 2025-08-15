//
//  ArtistsRepositoryMock.swift
//  MusicFinder
//
//  Created by 6od9i on 14/08/25.
//

import Foundation

#if DEBUG || TESTING

extension ArtistsRepository {
    static var mock: ArtistsRepository {
        .init(requestsService: RequestsServiceMock())
    }
}

#endif
