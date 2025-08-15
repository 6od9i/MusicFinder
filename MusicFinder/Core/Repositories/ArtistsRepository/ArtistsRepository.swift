//
//  ArtistsRepository.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import Combine
import Foundation

final class ArtistsRepository {
    private let requestsService: RequestServiceProtocol
    private(set) var pageSize: Int
    
    /// While have no caching to DB use LRU cache
    private let artistsCache: ArtistsCacheProtocol
    private var paginationLimits: [String: Int] = [:]
    
    init(requestsService: RequestServiceProtocol, artistsCache: ArtistsCacheProtocol = SafeLRUCache(capacity: 100)) {
        self.requestsService = requestsService
        pageSize = RequestsSettings.defaultPageSize
        self.artistsCache = artistsCache
    }
}

// MARK: - ArtistsSource
extension ArtistsRepository: ArtistsSource {
    func artists(for query: String, page: Int) -> AnyPublisher<[ArtistsListModel.Artist], Error> {
        if let cached = artistsCache.get(query), let artists = cached[page], artists.isEmpty == false {
            return Just(artists).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        guard paginationLimits[query] ?? Int.max >= page else {
            return Fail(error: RequestsError.noMoreData).eraseToAnyPublisher()
        }
        
        return requestsService
            .request(ArtistsAPI.searchArtists(query: query, page: page, perPage: pageSize))
            .tryMap { [weak self] (result: ArtistsListModel) -> [ArtistsListModel.Artist] in
                let fetchedArtists = result.results
                
                if self?.paginationLimits[query] ?? Int.max != result.pagination.pages {
                    self?.paginationLimits[query] = result.pagination.pages
                }
                
                guard fetchedArtists.isEmpty == false else {
                    throw RequestsError.emptyResponse
                }
                
                self?.updateCache(query: query, artists: fetchedArtists, page: page)
                return fetchedArtists
            }
            .eraseToAnyPublisher()
    }
    
    func reduceCacheSize() {
        artistsCache.updateCapacity(max(1, artistsCache.capacity / 2))
    }
}

// MARK: - Helpers
private extension ArtistsRepository {
    func updateCache(query: String, artists: [ArtistsListModel.Artist], page: Int) {
        artistsCache.update(for: query, page: page, value: artists)
    }
}
