//
//  ArtistDetailsVMMock.swift
//  MusicFinder
//
//  Created by 6od9i on 13/08/25.
//

import Foundation
import Combine

#if DEBUG || TESTING

extension ArtistDetailsVM {
    static func mock(detailsSource: ArtistDetailsSource = ArtistDetailsSourceMock(),
                     details: ArtistDetailsModel? = nil, error: String? = nil,
                     isAlbumsLoading: Bool = false, albums: [RecentAlbumsModel.Release]? = nil) -> ArtistDetailsVM {
        let mock = ArtistDetailsVM(artist: ArtistsListModel.Artist.mock,
                                   detailsSource: detailsSource,
                                   output: ArtistDetailsOutputMock())
        mock.details = details
        mock.errorMessage = error
        mock.isAlbumsLoading = isAlbumsLoading
        mock.recentAlbums = albums ?? []
        return mock
    }
}

#endif
