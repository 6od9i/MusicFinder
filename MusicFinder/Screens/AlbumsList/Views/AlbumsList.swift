//
//  AlbumsList.swift
//  MusicFinder
//
//  Created by 6od9i on 11/08/25.
//

import SwiftUI

struct AlbumsList: View {
    @StateObject var viewModel: AlbumsListVM
    @State private var filterBarHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            if viewModel.albums.isEmpty {
                VStack {
                    AlbumsFilters(filters: $viewModel.filters)
                    emptyView()
                }
            } else {
                albums
            }
        }
        .onAppear {
            viewModel.loadAlbums()
        }
        .navigationTitle("\(viewModel.artist.name) Albums")
    }
    
    private var albums: some View {
        ZStack {
            ListBottomIndicator(
                items: viewModel.albums,
                isLoading: viewModel.isLoading) { album in
                    AlbumDetailsCell(album: album)
                        .onAppear {
                            viewModel.showedItem(album)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
        }
        .ignoresSafeArea(edges: .bottom)
        .safeAreaInset(edge: .top) {
            AlbumsFilters(filters: $viewModel.filters)
        }
    }
    
    @ViewBuilder
    func emptyView() -> some View {
        if let errorMessage = viewModel.errorMessage, errorMessage.isEmpty == false {
            EmptyListInfo(text: "Error: \(errorMessage)", color: .red)
        } else if viewModel.isLoading {
            Spacer()
            ProgressView("Searching...")
                .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                .padding()
            Spacer()
        } else if viewModel.filters.isEmpty {
            EmptyListInfo(text: "Search for an albums to see results.")
        } else {
            EmptyListInfo(text: "No albums found for this filters.\nTry to change them.")
        }
    }
}

// swiftlint:disable all
#Preview("Empty") {
    AlbumsList(viewModel: .mock())
}

#Preview("Some Albums") {
    AlbumsList(viewModel: .mock(
        albumsSource: AlbumsSourceMock(response: [.mock, .mock, .mock])))
}

#Preview("Loading") {
    AlbumsList(viewModel: .mock(
        albumsSource: AlbumsSourceMock(delay: 1000, response: [.mock, .mock, .mock])))
}
