//
//  ArtistDetailsOutputMock.swift
//  MusicFinder
//
//  Created by 6od9i on 13/08/25.
//

import Foundation

#if DEBUG || TESTING

struct ArtistDetailsOutputMock: ArtistDetailsOutput {
    func showArtisDetails(_: ArtistInfo) {}
    func showAlbums(for _: ArtistInfo) {}
}

#endif
