//
//  ArtistsSource.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import Combine
import Foundation

protocol ArtistsSource {
    var pageSize: Int { get }
    
    func artists(for query: String, page: Int) -> AnyPublisher<[ArtistsListModel.Artist], Error>
    func reduceCacheSize()
}
