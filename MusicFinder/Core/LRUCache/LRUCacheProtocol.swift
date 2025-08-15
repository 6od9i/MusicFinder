//
//  LRUCacheProtocol.swift
//  MusicFinder
//
//  Created by 6od9i on 14/08/25.
//

import Foundation

protocol LRUCacheProtocol {
    associatedtype Key: Hashable
    associatedtype Value
    
    var capacity: Int { get }
    
    func get(_ key: Key) -> Value?
    func put(_ key: Key, _ value: Value)
    func updateCapacity(_ newCapacity: Int)
}

protocol PagedCacheProtocol: LRUCacheProtocol {    
    func update<Element>(for key: Key, page: Int, value: [Element]) where Value == [Int: [Element]]
}
