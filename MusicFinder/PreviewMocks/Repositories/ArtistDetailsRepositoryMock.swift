//
//  ArtistDetailsRepositoryMock.swift
//  MusicFinder
//
//  Created by 6od9i on 14/08/25.
//

import Foundation
import Combine

#if DEBUG || TESTING

class ArtistDetailsSourceMock: ArtistDetailsSource {
    var pageSize: Int
    var artistError: Error?
    var albumsError: Error?
    var delay: Int = 0
    var details: ArtistDetailsModel?
    var albums: [RecentAlbumsModel.Release]?
    var wasRequestCalled = false
    
    init(pageSize: Int = 10, delay: Int = 0, artistError: Error? = nil, albumsError: Error? = nil,
         albums: [RecentAlbumsModel.Release]? = nil, details: ArtistDetailsModel = .mock()) {
        self.pageSize = pageSize
        self.artistError = artistError
        self.albumsError = albumsError
        self.delay = delay
        self.albums = albums
        self.details = details
    }
    
    
    func artistDetails(for artist: any ArtistInfo) -> AnyPublisher<ArtistDetailsModel, any Error> {
        wasRequestCalled = true
        if let artistError {
            return Fail(error: artistError)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        if let details {
            return Just(details)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: RequestsError.noMoreData)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func recentAlbums(for artist: any ArtistInfo) -> AnyPublisher<[RecentAlbumsModel.Release], any Error> {
        wasRequestCalled = true
        if let albumsError {
            return Fail(error: albumsError)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        if let albums {
            return Just(albums)
                .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: RequestsError.noMoreData)
            .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}


#endif
