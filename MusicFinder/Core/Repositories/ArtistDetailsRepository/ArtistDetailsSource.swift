//
//  ArtistDetailsSource.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import Combine
import Foundation

protocol ArtistDetailsSource {
    func artistDetails(for artist: ArtistInfo) -> AnyPublisher<ArtistDetailsModel, Error>
    func recentAlbums(for artist: ArtistInfo) -> AnyPublisher<[RecentAlbumsModel.Release], Error>
}
