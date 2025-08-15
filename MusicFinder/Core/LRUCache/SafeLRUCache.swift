//
//  SafeLRUCache.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import Foundation

final class SafeLRUCache<Key: Hashable, Value> {
    private var cache: [Key: Node] = [:]
    private var head: Node?
    private var tail: Node?
    private(set) var capacity: Int
    
    private let syncQueue = DispatchQueue(label: "com.bomelnikov.MusicFinder.lrucache.queue", attributes: .concurrent)
    
    private class Node {
        let key: Key
        var value: Value
        var prev: Node?
        var next: Node?
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }
    
    init(capacity: Int) {
        self.capacity = max(0, capacity)
    }
}

// MARK: - LRUCacheProtocol
extension SafeLRUCache: LRUCacheProtocol {
    func updateCapacity(_ newCapacity: Int) {
        guard newCapacity > -1, capacity != newCapacity else { return }
        syncQueue.async(flags: .barrier) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.capacity = newCapacity
            while strongSelf.cache.count > strongSelf.capacity {
                strongSelf.removeTail()
            }
        }
    }
    
    func get(_ key: Key) -> Value? {
        syncQueue.sync { () -> Value? in
            guard let node = cache[key] else { return nil }
            moveToHead(node)
            return node.value
        }
    }
    
    func put(_ key: Key, _ value: Value) {
        syncQueue.async(flags: .barrier) {
            if let existingNode = self.cache[key] {
                existingNode.value = value
                self.moveToHead(existingNode)
            } else {
                let newNode = Node(key: key, value: value)
                self.cache[key] = newNode
                self.insertAtHead(newNode)
                
                if self.cache.count > self.capacity {
                    self.removeTail()
                }
            }
        }
    }
}

// MARK: - PagedCacheProtocol
extension SafeLRUCache: PagedCacheProtocol {
    func update<Element>(for key: Key, page: Int, value: [Element]) where Value == [Int: [Element]] {
        syncQueue.async {
            if let node = self.cache[key] {
                var newValue = node.value
                newValue[page] = value
                node.value = newValue
                self.moveToHead(node)
            } else {
                self.put(key, [page: value])
            }
        }
    }
}

// MARK: - Helpers
private extension SafeLRUCache {
    private func moveToHead(_ node: Node) {
        remove(node)
        insertAtHead(node)
    }
    
    private func insertAtHead(_ node: Node) {
        node.next = head
        node.prev = nil
        head?.prev = node
        head = node
        
        if tail == nil {
            tail = node
        }
    }
    
    private func remove(_ node: Node) {
        if let prev = node.prev {
            prev.next = node.next
        } else {
            head = node.next
        }
        
        if let next = node.next {
            next.prev = node.prev
        } else {
            tail = node.prev
        }
    }
    
    func removeTail() {
        guard let tailNode = tail else { return}
        cache[tailNode.key] = nil
        remove(tailNode)
    }
}
