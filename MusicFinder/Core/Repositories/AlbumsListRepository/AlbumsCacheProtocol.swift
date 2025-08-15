//
//  AlbumsCacheProtocol.swift
//  MusicFinder
//
//  Created by 6od9i on 14/08/25.
//

import Foundation

protocol AlbumsCacheProtocol {
    var capacity: Int { get }
    
    func get(_ key: String) -> [Int: [AlbumsListModel.Album]]?
    func put(_ key: String, _ value: [Int: [AlbumsListModel.Album]])
    func updateCapacity(_ newCapacity: Int)
    func update(for key: String, page: Int, value: [AlbumsListModel.Album])
}

extension SafeLRUCache: AlbumsCacheProtocol where Key == String, Value == [Int: [AlbumsListModel.Album]] {}
