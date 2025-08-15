//
//  InMemoryImageCache.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import UIKit

// swiftlint:disable legacy_objc_type
final class DefaultImageCache: ImageCache {
    private let cache: NSCache<NSURL, UIImage>
    
    static let shared = DefaultImageCache()
    
    private init(limit: Int = 10000) {
        cache = .init()
        cache.countLimit = limit
    }
    
    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image else { return }
        cache.setObject(image, forKey: url as NSURL)
    }
}
