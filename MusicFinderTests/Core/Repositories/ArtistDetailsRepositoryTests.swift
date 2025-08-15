//
//  ArtistDetailsRepositoryTests.swift
//  MusicFinderTests
//
//  Created by 6od9i on 14/08/25.
//

import Foundation
import Testing
import Combine
@testable import MusicFinder

struct ArtistDetailsRepositoryTests {
    @Test func testArtistDetailsReturnsData() async throws {
        // Arrange
        let service = RequestsServiceMock()
        let repository = ArtistDetailsRepository(requestsService: service)
        let artist = ArtistsListModel.Artist.mock
        let details = ArtistDetailsModel.mock()
        service.data = try JSONEncoder().encode(details)
        var cancellable: AnyCancellable?
        
        // Act
        var receivedDetails: ArtistDetailsModel?
        await withCheckedContinuation { continuation in
            cancellable = repository.artistDetails(for: artist)
                .sink(receiveCompletion: { _ in
                    continuation.resume()
                }, receiveValue: { result in
                    receivedDetails = result
                })
        }
        _ = cancellable
        
        // Assert
        assert(receivedDetails != nil, "Should return artist details")
    }
    
    @Test func testRecentAlbumsReturnsData() async throws {
        // Arrange
        let service = RequestsServiceMock()
        let repository = ArtistDetailsRepository(requestsService: service)
        let artist = ArtistsListModel.Artist.mock
        let recentAlbums = RecentAlbumsModel.mock()
        service.data = try JSONEncoder().encode(recentAlbums)
        var cancellable: AnyCancellable?
        
        // Act
        var receivedAlbums: [RecentAlbumsModel.Release] = []
        await withCheckedContinuation { continuation in
            cancellable = repository.recentAlbums(for: artist)
                .sink(receiveCompletion: { _ in
                    continuation.resume()
                }, receiveValue: { result in
                    receivedAlbums = result
                })
        }
        _ = cancellable
        
        // Assert
        assert(receivedAlbums.isEmpty == false, "Should return recent albums")
    }
    
    @Test func testRecentAlbumsThrowsEmptyResponse() async throws {
        // Arrange
        let service = RequestsServiceMock()
        let emptyModel = RecentAlbumsModel.mock(releases: [])
        service.data = try JSONEncoder().encode(emptyModel)
        let repository = ArtistDetailsRepository(requestsService: service)
        let artist = ArtistsListModel.Artist.mock
        var cancellable: AnyCancellable?
        var receivedError: Error?
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = repository.recentAlbums(for: artist)
                .sink(receiveCompletion: { result in
                    if case .failure(let error) = result {
                        receivedError = error
                    }
                    continuation.resume()
                }, receiveValue: { _ in })
        }
        _ = cancellable
        
        // Assert
        assert(receivedError as? RequestsError == .emptyResponse, "Should be RequestsError.emptyResponse")
    }
}

extension RecentAlbumsModel {
    static func mock(pagination: Pagination = .mock, releases: [Release] = [.mock()]) -> RecentAlbumsModel {
        RecentAlbumsModel(pagination: pagination, releases: releases)
    }
}
