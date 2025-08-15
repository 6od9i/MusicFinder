//
//  ArtistsCacheProtocol.swift
//  MusicFinder
//
//  Created by 6od9i on 14/08/25.
//

import Foundation

protocol ArtistsCacheProtocol {
    var capacity: Int { get }
    
    func get(_ key: String) -> [Int: [ArtistsListModel.Artist]]?
    func put(_ key: String, _ value: [Int: [ArtistsListModel.Artist]])
    func updateCapacity(_ newCapacity: Int)
    func update(for key: String, page: Int, value: [ArtistsListModel.Artist])
}

extension SafeLRUCache: ArtistsCacheProtocol where Key == String, Value == [Int: [ArtistsListModel.Artist]] {}
