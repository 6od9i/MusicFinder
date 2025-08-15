//
//  AlbumsListVM.swift
//  MusicFinder
//
//  Created by 6od9i on 11/08/25.
//

import Combine
import SwiftUI

final class AlbumsListVM: ObservableObject {
    @Published var albums: [AlbumsListModel.Album] = []
    @Published var errorMessage: String?
    @Published var canLoadMore: Bool = true
    @Published var isLoading: Bool = false

    @Published var filters: AlbumsFiltersDTO = .init()
    
    @Published var artist: ArtistInfo
    
    private let albumsSource: AlbumsSource
    private var cancellables: Set<AnyCancellable> = []
    private var currentPage = 1
    
    init(artist: ArtistInfo, albumsSource: AlbumsSource) {
        self.artist = artist
        self.albumsSource = albumsSource
        bindFilters()
    }
}

extension AlbumsListVM {
    func showedItem(_ item: AlbumsListModel.Album?) {
        guard let item, let idx = albums.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        
        guard !isLoading, canLoadMore else { return }
        
        if idx > albums.count - (albumsSource.pageSize / 2) - 1 {
            errorMessage = nil
            loadNextPage()
        }
    }
    
    func loadAlbums() {
        loadNextPage()
    }
}

// MARK: - Loading
private extension AlbumsListVM {
    func filtersUpdated() {
        albums = []
        currentPage = 1
        isLoading = false
        canLoadMore = true
        loadNextPage()
    }
    
    func loadNextPage() {
        guard !isLoading, canLoadMore else { return }
        
        isLoading = true
        errorMessage = nil
        let page = currentPage
        let filters = self.filters
        
        albumsSource.albums(for: artist, page: currentPage, filters: filters)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if case .failure(let error) = result {
                    defer { self?.isLoading = false }
                    if error as? RequestsError == .noMoreData {
                        self?.canLoadMore = false
                        return
                    }
                    if error as? RequestsError == .emptyResponse {
                        return
                    }
                    self?.errorMessage = "Loading albums failed: \(error)"
                }
            } receiveValue: { [weak self] albums in
                guard let strongSelf = self else { return }
                if strongSelf.filters == filters, strongSelf.currentPage == page {
                    strongSelf.albums.append(contentsOf: albums)
                    strongSelf.currentPage += 1
                    strongSelf.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
    
    func bindFilters() {
        $filters
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.filtersUpdated()
            }
            .store(in: &cancellables)
    }
}
