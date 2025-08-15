//
//  AlbumsListRepositoryTests.swift
//  MusicFinderTests
//
//  Created by 6od9i on 14/08/25.
//

import Testing
import Combine
@testable import MusicFinder
import Foundation

struct AlbumsListRepositoryTests {
    
    @Test func testReturnsFromCacheIfAvailable() async throws {
        // Arrange
        let service = RequestsServiceMock()
        let albumsList = AlbumsListModel.mock()
        service.data = try JSONEncoder().encode(albumsList)

        let mockCache = LRUCacheMock<String, [Int: [AlbumsListModel.Album]]>()
        let repository = AlbumsListRepository(requestsService: service, albumsCache: mockCache)

        let artist = ArtistsListModel.Artist.mock
        var page = 1
        var cancellable: AnyCancellable?
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = repository.albums(for: artist, page: page, filters: .empty)
                .sink(receiveCompletion: { _ in
                    continuation.resume()
                }, receiveValue: { (_: [AlbumsListModel.Album]) in })
        }
        
        // Assert
        assert(service.lastAPI != nil, "Should call API first time")
                
        // Arrange
        service.lastAPI = nil
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = repository.albums(for: artist, page: page, filters: .empty)
                .sink(receiveCompletion: { _ in  continuation.resume() },
                      receiveValue: { (_: [AlbumsListModel.Album]) in })
        }
        
        // Assert
        assert(service.lastAPI == nil, "Should get from cache not from service")
        
        
        // Arrange
        page = 2
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = repository.albums(for: artist, page: page, filters: .empty)
                .sink(receiveCompletion: { _ in  continuation.resume() },
                      receiveValue: { (_: [AlbumsListModel.Album]) in })
        }
        _ = cancellable
        
        // Assert
        assert(service.lastAPI != nil, "Should call API for another page")
    }
    
    @Test func testThrowsEmptyResponseIfNoAlbums() async throws {
        // Arrange
        let service = RequestsServiceMock()
        let albumsList = AlbumsListModel.mock(results: [])
        service.data = try JSONEncoder().encode(albumsList)

        let repository = AlbumsListRepository(requestsService: service)

        let artist = ArtistsListModel.Artist.mock
        var cancellable: AnyCancellable?
        
        var receivedError: Error?
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = repository.albums(for: artist, page: 1, filters: .empty)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    continuation.resume()
                }, receiveValue: { (_: [AlbumsListModel.Album]) in })
        }
        _ = cancellable
        
        // Assert
        assert(receivedError as? RequestsError == .emptyResponse, "Should throw emptyResponse error")
    }
    
    @Test func testThrowsNoMoreDataWhenPageExceedsLimit() async throws {
        // Arrange
        let service = RequestsServiceMock()
        let albumsList = AlbumsListModel.mock(pagination: Pagination(page: 1, pages: 1, perPage: 1, items: 1))
        service.data = try JSONEncoder().encode(albumsList)
        
        let repository = AlbumsListRepository(requestsService: service)
        let artist = ArtistsListModel.Artist.mock
        var cancellable: AnyCancellable?
        var page = 1
        
        var receivedError: Error?
        
        await withCheckedContinuation { continuation in
            cancellable = repository.albums(for: artist, page: page, filters: .empty)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    continuation.resume()
                }, receiveValue: { (_: [AlbumsListModel.Album]) in })
        }
        assert(receivedError == nil, "Should have no error")
        
        page = 2
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = repository.albums(for: artist, page: page, filters: .empty)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    continuation.resume()
                }, receiveValue: { (_: [AlbumsListModel.Album]) in })
        }
        _ = cancellable
        
        // Assert
        assert(receivedError as? RequestsError == .noMoreData, "Should throw noMoreData error")
    }
}

extension AlbumsListModel {
    static func mock(pagination: Pagination = .mock, results: [Album] = [.mock]) -> AlbumsListModel {
        AlbumsListModel(pagination: pagination, results: results)
    }
}

extension AlbumsFiltersDTO {
    static var empty: AlbumsFiltersDTO {
        AlbumsFiltersDTO(year: nil, genre: nil, label: nil)
    }
}
