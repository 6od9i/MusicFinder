//
//  ArtistDetailsOutput.swift
//  MusicFinder
//
//  Created by 6od9i on 10/08/25.
//

import Foundation

protocol ArtistDetailsOutput: ArtistPresenterProtocol {
    func showAlbums(for artist: ArtistInfo)
}
