//
//  ArtistDetailsRepository.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import Combine

final class ArtistDetailsRepository {
    private let requestsService: RequestServiceProtocol
    
    init(requestsService: RequestServiceProtocol) {
        self.requestsService = requestsService
    }
}

// MARK: - ArtistDetailsSource
extension ArtistDetailsRepository: ArtistDetailsSource {
    func artistDetails(for artist: ArtistInfo) -> AnyPublisher<ArtistDetailsModel, Error> {
        requestsService.request(ArtistsAPI.artistDetails(artistId: artist.id))
    }
    
    func recentAlbums(for artist: ArtistInfo) -> AnyPublisher<[RecentAlbumsModel.Release], Error> {
        requestsService.request(ArtistsAPI.recentAlbums(artistId: artist.id, page: 1, perPage: 3))
            .tryMap { (result: RecentAlbumsModel) -> [RecentAlbumsModel.Release] in
                let fetchedAlbums = result.releases
                
                guard result.pagination.items > 0, fetchedAlbums.isEmpty == false else {
                    throw RequestsError.emptyResponse
                }
                
                return fetchedAlbums
            }
            .eraseToAnyPublisher()
    }
}
