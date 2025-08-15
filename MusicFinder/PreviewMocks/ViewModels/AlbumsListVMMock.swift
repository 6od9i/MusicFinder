//
//  AlbumsListVMMock.swift
//  MusicFinder
//
//  Created by 6od9i on 13/08/25.
//

import Foundation

#if DEBUG || TESTING

extension AlbumsListVM {
    static func mock(albums: [AlbumsListModel.Album] = [.mock, .mock, .mock], errorMessage: String? = nil,
                     canLoadMore: Bool = true, isLoading: Bool = false,
                     artist: ArtistInfo = ArtistsListModel.Artist.mock,
                     albumsSource: AlbumsSource = AlbumsSourceMock()) -> AlbumsListVM {
        let mock = AlbumsListVM(artist: artist, albumsSource: albumsSource)
        mock.albums = albums
        mock.errorMessage = errorMessage
        mock.canLoadMore = canLoadMore
        mock.isLoading = isLoading
        return mock
    }
}

#endif
