//
//  ArtistsListVMMock.swift
//  MusicFinder
//
//  Created by 6od9i on 13/08/25.
//

import Foundation

#if DEBUG || TESTING

extension ArtistsListVM {
    static func mock(artistsRepository: ArtistsSource = ArtistsSourceMock(),
                     searchText: String = "",
                     artists: [ArtistsListModel.Artist] = [],
                     isLoading: Bool = false,
                     errorMessage: String? = nil,
                     canLoadMore: Bool = true) -> ArtistsListVM {
        let mock = ArtistsListVM(artistsRepository: artistsRepository, output: ArtistsListOutputMock())
        mock.searchText = searchText
        mock.artists = artists
        mock.isLoading = isLoading
        mock.errorMessage = errorMessage
        mock.canLoadMore = canLoadMore
        return mock
    }
}

#endif
