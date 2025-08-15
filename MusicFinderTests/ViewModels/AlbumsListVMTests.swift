//
//  AlbumsListVMTests.swift
//  MusicFinderTests
//
//  Created by 6od9i on 14/08/25.
//

import Foundation
import Testing
import Combine
@testable import MusicFinder

struct AlbumsListVMTests {
    @Test func testLoadAlbumsSuccess() async throws {
        // Arrange
        let mockAlbums: [AlbumsListModel.Album] = [.mock, .mock]
        let repository = AlbumsSourceMock(response: mockAlbums)
        let vm = AlbumsListVM(artist: ArtistsListModel.Artist.mock, albumsSource: repository)
        var cancellable: AnyCancellable?
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = vm.$albums
                .dropFirst()
                .sink { albums in
                    if albums == mockAlbums {
                        continuation.resume()
                    }
                }
            vm.loadAlbums()
        }
        _ = cancellable
        
        // Assert
        assert(vm.albums == mockAlbums, "VM should load albums from repository")
        assert(vm.isLoading == false, "VM should not be loading after request")
        assert(vm.canLoadMore == true, "VM should allow loading more if pagination exists")
    }

    @Test func testLoadAlbumsEmptyResponse() async throws {
        // Arrange
        let repository = AlbumsSourceMock(error: RequestsError.emptyResponse)
        let vm = AlbumsListVM(artist: ArtistsListModel.Artist.mock, albumsSource: repository)
        vm.filters = .empty
        var cancellable: AnyCancellable?
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = vm.$isLoading
                .dropFirst()
                .sink { value in
                    if value == false {
                        continuation.resume()
                    }
                }
            
            vm.loadAlbums()
        }
        _ = cancellable
        
        // Assert
        assert(vm.albums.isEmpty, "VM albums should be empty on empty response")
        assert(vm.canLoadMore == true, "VM should allow loading more if pagination exists")
        assert(vm.errorMessage == nil, "Error message should be nil")
    }

    @Test func testLoadAlbumsNoMoreData() async throws {
        // Arrange
        let mockAlbums: [AlbumsListModel.Album] = [.mock, .mock]
        let repository = AlbumsSourceMock(response: mockAlbums)
        let vm = AlbumsListVM(artist: ArtistsListModel.Artist.mock, albumsSource: repository)
        vm.filters = .empty
        
        var cancellable: AnyCancellable?
        await withCheckedContinuation { continuation in
            cancellable = vm.$albums
                .dropFirst()
                .sink { albums in
                    if albums == mockAlbums {
                        continuation.resume()
                    }
                }
            vm.loadAlbums()
        }
        _ = cancellable
        
        repository.error = RequestsError.noMoreData
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = vm.$canLoadMore
                .dropFirst()
                .sink { canLoadMore in
                    if canLoadMore == false {
                        continuation.resume()
                    }
                }
            
            vm.loadAlbums()
        }
        
        // Assert
        assert(vm.canLoadMore == false, "VM should set canLoadMore to false on noMoreData error")
        assert(vm.errorMessage == nil, "Error message should be nil")
        assert(repository.wasRequestCalled, "Repository should have been requested")
        
        
        // Arrange
        repository.wasRequestCalled = false
        
        // Act
        vm.loadAlbums()
        _ = cancellable
        
        // Assert
        assert(vm.errorMessage == nil, "Error message should be nil")
        assert(repository.wasRequestCalled == false, "Repository should not have been requested after noMoreData error")
        assert(vm.canLoadMore == false, "VM should not be able to load more data")
        
        
        // Arrange
        repository.error = nil
        
        // Act
        vm.filters = AlbumsFiltersDTO(year: 1990, genre: "some", label: "label")
        
        // Assert
        assert(vm.errorMessage == nil, "Error message should be nil")
        assert(vm.canLoadMore == true, "VM should allow loading more if pagination exists")
        assert(repository.wasRequestCalled, "Repository should not have been requested after noMoreData error")
    }
    
    @Test func testShowedItemTriggersLoadNextPage() async throws {
        // Arrange
        let mockAlbums: [AlbumsListModel.Album] = [.mock(id: 1), .mock(id: 2), .mock(id: 3), .mock(id: 4)]
        let repository = AlbumsSourceMock(pageSize: 4, response: mockAlbums)
        let vm = AlbumsListVM(artist: ArtistsListModel.Artist.mock, albumsSource: repository)
        
        vm.filters = .empty
        
        var cancellable: AnyCancellable?
        await withCheckedContinuation { continuation in
            cancellable = vm.$isLoading
                .dropFirst()
                .sink { isLoading in
                    if isLoading == false {
                        continuation.resume()
                    }
                }
            vm.loadAlbums()
        }
        _ = cancellable
        repository.wasRequestCalled = false
        
        // Act
        vm.showedItem(mockAlbums[0])
        // Assert
        assert(repository.wasRequestCalled == false, "First item less than pageSize / 2, so no request")
        
        // Act
        vm.showedItem(nil)
        // Assert
        assert(repository.wasRequestCalled == false, "Nill element should not call request")
        
        // Act
        vm.showedItem(.mock(id: 10000))
        // Assert
        assert(repository.wasRequestCalled == false, "Unknown element should not call request")
        
        // Act
        vm.showedItem(mockAlbums[2])
        // Assert
        assert(repository.wasRequestCalled == true, "Third item is more than than pageSize / 2, so should be request")
    }

    @Test func testLoadAlbumsUnknownErrorSetsErrorMessage() async throws {
        // Arrange
        struct UnknownError: Error {}
        let repository = AlbumsSourceMock(error: UnknownError())
        let vm = AlbumsListVM(artist: ArtistsListModel.Artist.mock, albumsSource: repository)
        var cancellable: AnyCancellable?

        // Act
        await withCheckedContinuation { continuation in
            cancellable = vm.$errorMessage
                .dropFirst()
                .sink { msg in
                    if msg != nil {
                        continuation.resume()
                    }
                }

            vm.loadAlbums()
        }
        _ = cancellable

        // Assert
        assert(vm.errorMessage?.contains("Loading albums failed") == true,
               "VM should set errorMessage on unknown error")
    }
}

extension AlbumsListModel.Album: @retroactive Equatable {
    public static func == (lhs: AlbumsListModel.Album, rhs: AlbumsListModel.Album) -> Bool {
        lhs.id == rhs.id
    }
}
