//
//  LRUCacheMock.swift
//  MusicFinderTests
//
//  Created by 6od9i on 14/08/25.
//

import Foundation
@testable import MusicFinder

final class LRUCacheMock<Key: Hashable, Value>: PagedCacheProtocol {
    var capacity: Int = 10
    private var storage: [Key: Value] = [:]
    
    func get(_ key: Key) -> Value? {
        storage[key]
    }
    
    func put(_ key: Key, _ value: Value) {
        storage[key] = value
    }
    
    func updateCapacity(_ newCapacity: Int) {
        capacity = newCapacity
    }
    
    func update<Element>(for key: Key, page: Int, value: [Element]) where Value == [Int: [Element]] {
        var dict = storage[key] ?? [:]
        dict[page] = value
        storage[key] = dict
    }
}

extension LRUCacheMock: AlbumsCacheProtocol where Key == String, Value == [Int: [AlbumsListModel.Album]] {}
extension LRUCacheMock: ArtistsCacheProtocol where Key == String, Value == [Int: [ArtistsListModel.Artist]] {}
