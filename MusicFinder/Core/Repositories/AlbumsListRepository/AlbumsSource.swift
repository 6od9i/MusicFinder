//
//  AlbumsSource.swift
//  MusicFinder
//
//  Created by 6od9i on 11/08/25.
//

import Combine
import Foundation

protocol AlbumsSource {
    var pageSize: Int { get }
    
    func albums(
        for artist: ArtistInfo,
        page: Int,
        filters: AlbumsFiltersDTO) -> AnyPublisher<[AlbumsListModel.Album], Error>
}
