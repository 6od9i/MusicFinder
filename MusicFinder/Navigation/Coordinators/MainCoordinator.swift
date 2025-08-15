//
//  MainCoordinator.swift
//  MusicFinder
//
//  Created by 6od9i on 05/08/25.
//

import Foundation

final class MainCoordinator {
    private let router: RoutingProtocol
    private let requestsService: RequestsService
    
    init(router: RoutingProtocol) {
        self.router = router
        self.requestsService = RequestsService()
    }
    
    func start() {
        // TODO: check auth and create authorization coordinator if needed
        showArtisrsList()
    }
    
    func showArtisrsList() {
        let vm = ArtistsListVM(artistsRepository: ArtistsRepository(requestsService: requestsService), output: self)
        let view = ArtistsList(viewModel: vm)
        router.setRoot(view: view, navBarHidden: true)
    }
}

// MARK: - ArtistsListOutput
extension MainCoordinator: ArtistPresenterProtocol {
    func showArtisDetails(_ artist: ArtistInfo) {
        let vm = ArtistDetailsVM(
            artist: artist,
            detailsSource: ArtistDetailsRepository(requestsService: requestsService),
            output: self)
        let view = ArtistDetails(viewModel: vm)
        router.push(view: view, navBarHidden: false)
    }
}

// MARK: - ArtistDetailsOutput
extension MainCoordinator: ArtistDetailsOutput {
    func showAlbums(for artist: ArtistInfo) {
        let vm = AlbumsListVM(
            artist: artist,
            albumsSource: AlbumsListRepository(requestsService: requestsService))
        let view = AlbumsList(viewModel: vm)
        router.push(view: view, navBarHidden: false)
    }
}

// MARK: - ArtistsListOutput
extension MainCoordinator: ArtistsListOutput {}
