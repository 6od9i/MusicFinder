//
//  ArtistsListOutputMock.swift
//  MusicFinder
//
//  Created by 6od9i on 13/08/25.
//

import Foundation

#if DEBUG || TESTING

struct ArtistsListOutputMock: ArtistsListOutput {
    func showArtisDetails(_: ArtistInfo) {}
}

#endif
