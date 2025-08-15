//
//  AlbumsListRepository.swift
//  MusicFinder
//
//  Created by 6od9i on 11/08/25.
//

import Combine
import Foundation

final class AlbumsListRepository {
    private let requestsService: RequestServiceProtocol
    private(set) var pageSize: Int
    
    private let albumsCache: AlbumsCacheProtocol
    private var paginationLimits: [String: Int] = [:]
    
    init(requestsService: RequestServiceProtocol, albumsCache: AlbumsCacheProtocol = SafeLRUCache(capacity: 15)) {
        self.requestsService = requestsService
        pageSize = RequestsSettings.defaultPageSize
        self.albumsCache = albumsCache
    }
}

// MARK: - AlbumsSource
extension AlbumsListRepository: AlbumsSource {
    func albums(
        for artist: ArtistInfo,
        page: Int,
        filters: AlbumsFiltersDTO
    ) -> AnyPublisher<[AlbumsListModel.Album], Error> {
        let api = ArtistsAPI.searchAlbums(
            artistId: artist.id,
            page: page, perPage: pageSize,
            year: filters.year, genre: filters.genre, label: filters.label
        )
        
        let paginationsKey = "artist_\(artist.id)" + filters.description
        
        if let cached = albumsCache.get(paginationsKey), let albums = cached[page], albums.isEmpty == false {
            return Just(albums).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        guard paginationLimits[paginationsKey] ?? Int.max >= page else {
            return Fail(error: RequestsError.noMoreData).eraseToAnyPublisher()
        }
        
        return requestsService
            .request(api)
            .tryMap { [weak self] (result: AlbumsListModel) -> [AlbumsListModel.Album] in
                let fetchedAlbums = result.results
                
                if self?.paginationLimits[paginationsKey] ?? Int.max != result.pagination.pages {
                    self?.paginationLimits[paginationsKey] = result.pagination.pages
                }
                
                guard fetchedAlbums.isEmpty == false else {
                    throw RequestsError.emptyResponse
                }
                
                self?.updateCache(key: paginationsKey, artists: fetchedAlbums, page: page)
                
                return fetchedAlbums
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Helpers
private extension AlbumsListRepository {
    func updateCache(key: String, artists: [AlbumsListModel.Album], page: Int) {
        albumsCache.update(for: key, page: page, value: artists)
    }
}
