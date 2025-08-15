//
//  ArtistPresenterProtocol.swift
//  MusicFinder
//
//  Created by 6od9i on 10/08/25.
//

import Foundation

protocol ArtistPresenterProtocol {
    func showArtisDetails(_ artist: ArtistInfo)
}

protocol ArtistInfo {
    var id: Int { get }
    var name: String { get }
    var thumbnail: String? { get }
}
