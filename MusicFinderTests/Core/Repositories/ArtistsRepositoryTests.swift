//
//  ArtistsRepositoryTests.swift
//  MusicFinderTests
//
//  Created by 6od9i on 14/08/25.
//

import Testing
import Combine
@testable import MusicFinder
import Foundation

struct ArtistsRepositoryTests {
    @Test func testReturnsFromCacheIfAvailable() async throws {
        // Arrange
        let service = RequestsServiceMock()
        let ArtistsList = ArtistsListModel.mock()
        service.data = try JSONEncoder().encode(ArtistsList)
        
        let cache = LRUCacheMock<String, [Int: [ArtistsListModel.Artist]]>()
        let repository = ArtistsRepository(requestsService: service, artistsCache: cache)

        let query = "query"
        var page = 1
        var cancellable: AnyCancellable?
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = repository.artists(for: query, page: page)
                .sink(receiveCompletion: { _ in
                    continuation.resume()
                }, receiveValue: { (_: [ArtistsListModel.Artist]) in })
        }
        
        // Assert
        assert(service.lastAPI != nil, "Should call API first time")
        
        
        // Arrange
        service.lastAPI = nil
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = repository.artists(for: query, page: page)
                .sink(receiveCompletion: { _ in  continuation.resume() },
                      receiveValue: { (_: [ArtistsListModel.Artist]) in })
        }
        
        // Assert
        assert(service.lastAPI == nil, "Should get from cache not from service")
        
        
        // Arrange
        page = 2
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = repository.artists(for: query, page: page)
                .sink(receiveCompletion: { _ in  continuation.resume() },
                      receiveValue: { (_: [ArtistsListModel.Artist]) in })
        }
        _ = cancellable
        
        // Assert
        assert(service.lastAPI != nil, "Should call API for another page")
    }
    
    @Test func testThrowsEmptyResponseIfNoArtists() async throws {
        // Arrange
        let service = RequestsServiceMock()
        let artistsList = ArtistsListModel.mock(results: [])
        service.data = try JSONEncoder().encode(artistsList)

        let repository = ArtistsRepository(requestsService: service)

        let query = "query"
        var cancellable: AnyCancellable?
        
        var receivedError: Error?
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = repository.artists(for: query, page: 1)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    continuation.resume()
                }, receiveValue: { (_: [ArtistsListModel.Artist]) in })
        }
        _ = cancellable
        
        // Assert
        assert(receivedError as? RequestsError == .emptyResponse, "Should throw emptyResponse error")
    }
    
    @Test func testThrowsNoMoreDataWhenPageExceedsLimit() async throws {
        // Arrange
        let service = RequestsServiceMock()
        let artistsList = ArtistsListModel.mock(pagination: Pagination(page: 1, pages: 1, perPage: 1, items: 1))
        service.data = try JSONEncoder().encode(artistsList)
        
        let repository = ArtistsRepository(requestsService: service)
        let query = "query"
        var cancellable: AnyCancellable?
        var page = 1
        
        var receivedError: Error?
        
        await withCheckedContinuation { continuation in
            cancellable = repository.artists(for: query, page: page)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    continuation.resume()
                }, receiveValue: { (_: [ArtistsListModel.Artist]) in })
        }
        assert(receivedError == nil, "Should have no error")
        
        page = 2
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = repository.artists(for: query, page: page)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    continuation.resume()
                }, receiveValue: { (_: [ArtistsListModel.Artist]) in })
        }
        _ = cancellable
        
        // Assert
        assert(receivedError as? RequestsError == .noMoreData, "Should throw noMoreData error")
    }
    
    @Test func testReduceCacheSize() async throws {
        // Arrange
        let cache = LRUCacheMock<String, [Int: [ArtistsListModel.Artist]]>()
        cache.capacity = 10
        let repository = ArtistsRepository(requestsService: RequestsServiceMock(), artistsCache: cache)
        
        // Act
        repository.reduceCacheSize()
        
        // Assert
        assert(cache.capacity == 5, "Cache capacity should be 5")
        
        // Act
        repository.reduceCacheSize()
        
        // Assert
        assert(cache.capacity == 2, "Cache capacity should be 2")
        
        // Act
        repository.reduceCacheSize()
        
        // Assert
        assert(cache.capacity == 1, "Cache capacity should be lass than 1")
        
        // Act
        repository.reduceCacheSize()
        
        // Assert
        assert(cache.capacity == 1, "Cache capacity should be lass than 1")
    }
}
