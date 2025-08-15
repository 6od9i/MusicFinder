//
//  ArtistsList.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import SwiftUI

struct ArtistsList: View {
    @StateObject var viewModel: ArtistsListVM
    @State private var searchFocused: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.artists.isEmpty {
                    emptyView()
                } else {
                    artists
                }
            }
            .navigationTitle("Artists")
        }
        .searchable(
            text: $viewModel.searchText,
            isPresented: $searchFocused,
            prompt: "Search Artist")
        .onAppear {
            searchFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
            viewModel.didReceiveMemoryWarning()
        }
    }
    
    private var artists: some View {
        ListBottomIndicator(
            items: viewModel.artists,
            isLoading: viewModel.isLoading) { artist in
                ImageTitleListCell(item: artist) {
                    viewModel.didSelect(artist)
                }
                .onAppear {
                    viewModel.showedItem(artist)
                }
            }
    }
    
    @ViewBuilder
    func emptyView() -> some View {
        if let errorMessage = viewModel.errorMessage, errorMessage.isEmpty == false {
            EmptyListInfo(text: "Error: \(errorMessage)", color: .red)
        } else if viewModel.isLoading {
            ProgressView("Searching...")
                .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                .padding()
        } else if viewModel.searchText.isEmpty {
            EmptyListInfo(text: "Search for an artist to see results.")
        } else {
            EmptyListInfo(text: "No artists for your request.\nTry entering a different search word.")
        }
    }
}

extension ArtistsListModel.Artist: ImageTitleCellItem {}

// swiftlint:disable all
#Preview("Default") {
    ArtistsList(viewModel: ArtistsListVM.mock())
}

#Preview("Error") {
    let mock = ArtistsListVM.mock(errorMessage: "SomeError")
    ArtistsList(viewModel: mock)
}

#Preview("Loading") {
    let mock = ArtistsListVM.mock(
        artistsRepository: ArtistsSourceMock(delay: 10000),
        searchText: "Some", isLoading: true)
    ArtistsList(viewModel: mock)
}

#Preview ("Empty") {
    let mock = ArtistsListVM.mock(searchText: "Some")
    ArtistsList(viewModel: mock)
}

#Preview ("SomeItems") {
    let mock = ArtistsListVM.mock(artistsRepository: ArtistsSourceMock(response: [.mock]), searchText: "some")
    ArtistsList(viewModel: mock)
}

#Preview ("LoadMore") {
    let mock = ArtistsListVM.mock(
        artistsRepository: ArtistsSourceMock(delay: 5, response: [.mock]),
        searchText: "more",
        artists: [.mock, .mock], isLoading: true)
    ArtistsList(viewModel: mock)
}
