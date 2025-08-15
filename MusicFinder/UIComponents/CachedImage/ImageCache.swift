//
//  ImageCache.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import UIKit

protocol ImageCache {
    func image(for url: URL) -> UIImage?
    func insertImage(_ image: UIImage?, for url: URL)
}
