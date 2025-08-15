//
//  ArtistsListVM.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import Combine
import SwiftUI

final class ArtistsListVM: ObservableObject {
    @Published var searchText: String = ""
    @Published var artists: [ArtistsListModel.Artist] = []
    @Published var errorMessage: String?
    @Published var canLoadMore: Bool = true
    @Published var isLoading: Bool = false
    
    private let output: ArtistsListOutput
    private let artistsRepository: ArtistsSource
    private var cancellables: Set<AnyCancellable> = []
    private var currentPage = 1
    
    init(artistsRepository: ArtistsSource, output: ArtistsListOutput) {
        self.artistsRepository = artistsRepository
        self.output = output
        setupSearchRequest()
    }
}

extension ArtistsListVM {
    func didReceiveMemoryWarning() {
        artistsRepository.reduceCacheSize()
    }
    
    func showedItem(_ item: ArtistsListModel.Artist?) {
        guard let item, let idx = artists.firstIndex(where: { $0.id == item.id }) else {
            return
        }
        
        guard !isLoading, canLoadMore else { return }
        
        if idx > artists.count - (artistsRepository.pageSize / 2) - 1 {
            errorMessage = nil
            search(query: searchText)
        }
    }
    
    func didSelect(_ item: ArtistsListModel.Artist) {
        output.showArtisDetails(item)
    }
}

// MARK: - Search methods
private extension ArtistsListVM {
    func setupSearchRequest() {
        $searchText
            .removeDuplicates()
            .debounce(for: 0.15, scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.searchNew(query: query)
            }
            .store(in: &cancellables)
    }
    
    func searchNew(query: String) {
        artists = []
        canLoadMore = true
        isLoading = false
        currentPage = 1
        search(query: query)
    }
    
    func search(query: String) {
        guard !query.isEmpty, !isLoading, canLoadMore else { return }
        
        isLoading = true
        errorMessage = nil
        let page = currentPage
        
        artistsRepository.artists(for: query, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    defer { self?.isLoading = false }
                    if error as? RequestsError == .noMoreData {
                        self?.canLoadMore = false
                        return
                    }
                    self?.errorMessage = "Request error: \(error)"
                }
            } receiveValue: { [weak self] artists in
                guard let strongSelf = self else { return }
                if strongSelf.searchText == query, strongSelf.currentPage == page {
                    strongSelf.artists.append(contentsOf: artists)
                    strongSelf.currentPage += 1
                    strongSelf.isLoading = false
                }
            }
            .store(in: &cancellables)
    }
}
