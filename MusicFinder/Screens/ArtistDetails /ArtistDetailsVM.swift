//
//  ArtistDetailsVM.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import Combine
import SwiftUI

final class ArtistDetailsVM: ObservableObject {
    @Published var artist: ArtistInfo
    @Published var details: ArtistDetailsModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var isAlbumsLoading = true
    @Published var recentAlbums: [RecentAlbumsModel.Release] = []
    
    private let output: ArtistDetailsOutput
    private let detailsSource: ArtistDetailsSource
    private var cancellables: Set<AnyCancellable> = []
    
    init(artist: ArtistInfo, detailsSource: ArtistDetailsSource, output: ArtistDetailsOutput) {
        self.artist = artist
        self.detailsSource = detailsSource
        self.output = output
    }
}

// MARK: - Interface
extension ArtistDetailsVM {
    func didSelect(_ member: ArtistDetailsModel.Artist) {
        output.showArtisDetails(member)
    }
    
    func didSelect(_ group: ArtistDetailsModel.Group) {
        output.showArtisDetails(group)
    }
    
    func showAlbums() {
        output.showAlbums(for: artist)
    }
    
    func loadArtistDetails() {
        cancellables.removeAll()
        errorMessage = nil
        isLoading = true
        
        detailsSource
            .artistDetails(for: artist)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    // TODO: localize error
                    self?.errorMessage = "Loading error: \(error)"
                    self?.isLoading = false
                }
            }, receiveValue: { [weak self] details in
                self?.isLoading = false
                self?.details = details
                self?.loadRecentAlbums()
            })
            .store(in: &cancellables)
    }
}

// MARK: - Helpers
extension ArtistDetailsVM {
    private func loadRecentAlbums() {
        isAlbumsLoading = true
        
        detailsSource
            .recentAlbums(for: artist)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        print("Failed to load albums: \(error.localizedDescription)")
                        self?.isAlbumsLoading = false
                    }
                }, receiveValue: { [weak self] albums in
                    self?.recentAlbums = albums
                    self?.isAlbumsLoading = false
                })
                .store(in: &cancellables)
    }
}
