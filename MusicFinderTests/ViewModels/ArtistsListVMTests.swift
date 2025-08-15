//
//  ArtistsListVMTests.swift
//  MusicFinderTests
//
//  Created by 6od9i on 14/08/25.
//

import Foundation
import Testing
import Combine
@testable import MusicFinder

struct ArtistsListVMTests {
    @Test func testSearchArtistsSuccess() async throws {
        // Arrange
        let mockArtists: [ArtistsListModel.Artist] = [.mock(id: 1), .mock(id: 2)]
        let output = ArtistsListOutputDummy()
        let repository = ArtistsSourceMock(response: mockArtists)
        let vm = ArtistsListVM(artistsRepository: repository, output: output)
        var cancellable: AnyCancellable?
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = vm.$artists
                .sink { artists in
                    if artists.isEmpty == false {
                        continuation.resume()
                    }
                }
            vm.searchText = "Rock"
        }
        _ = cancellable
        
        // Assert
        assert(vm.artists == mockArtists, "VM should load artists successfully")
        assert(vm.isLoading == false, "VM should stop loading")
        assert(vm.errorMessage == nil, "Error message should be nil on success")
        assert(vm.canLoadMore == true, "VM should be able to load more")
    }
    
    @Test func testSearchArtistsNoMoreData() async throws {
        // Arrange
        let repository = ArtistsSourceMock(error: RequestsError.noMoreData)
        let output = ArtistsListOutputDummy()
        let vm = ArtistsListVM(artistsRepository: repository, output: output)
        var cancellable: AnyCancellable?
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = vm.$canLoadMore
                .dropFirst()
                .sink { canLoadMore in
                    if canLoadMore == false {
                        continuation.resume()
                    }
                }
            vm.searchText = "Pop"
        }
        _ = cancellable
        
        // Assert
        assert(vm.artists.isEmpty, "No artists should be loaded")
        assert(vm.isLoading == false, "VM should stop loading")
        assert(vm.errorMessage == nil, "Error message should be nil for noMoreData")
    }
    
    @Test func testShowedItemTriggersNextPageSearch() async throws {
        // Arrange
        let mockArtists: [ArtistsListModel.Artist] = [
            .mock(id: 1),
            .mock(id: 2),
            .mock(id: 3),
            .mock(id: 4)
        ]
        let repository = ArtistsSourceMock(pageSize: 4, response: mockArtists)
        let vm = ArtistsListVM(artistsRepository: repository, output: ArtistsListOutputDummy())
        
        var cancellable: AnyCancellable?
        await withCheckedContinuation { continuation in
            cancellable = vm.$artists
                .sink { artists in
                    if artists.isEmpty == false {
                        continuation.resume()
                    }
                }
            vm.searchText = "test"
        }
        _ = cancellable
        repository.wasRequestCalled = false
        
        // Act
        vm.showedItem(mockArtists[0])
        // Assert
        assert(repository.wasRequestCalled == false, "First item less than pageSize / 2, so no request")
        
        // Act
        vm.showedItem(nil)
        // Assert
        assert(repository.wasRequestCalled == false, "Nil element should not call request")
        
        // Act
        vm.showedItem(.mock(id: 10000, name: "Unknown"))
        // Assert
        assert(repository.wasRequestCalled == false, "Unknown element should not call request")
        
        // Act
        vm.showedItem(mockArtists[2])
        // Assert
        assert(repository.wasRequestCalled == true, "Third item is more than pageSize / 2, so should trigger search")
    }
    
    @Test func testDidSelectArtist() {
        // Arrange
        let output = ArtistsListOutputDummy()
        let repository = ArtistsSourceMock()
        let vm = ArtistsListVM(artistsRepository: repository, output: output)
        let artist = ArtistsListModel.Artist.mock(id: 123)
        
        // Act
        vm.didSelect(artist)
        
        // Assert
        assert(output.showArtisDetailsCalled, "Output should show artist")
    }
}

final class ArtistsListOutputDummy: ArtistsListOutput {
    var showArtisDetailsCalled = false
    
    func showArtisDetails(_ artist: ArtistInfo) {
        showArtisDetailsCalled = true
    }
}

extension ArtistsListModel.Artist: @retroactive Equatable {
    public static func == (lhs: ArtistsListModel.Artist, rhs: ArtistsListModel.Artist) -> Bool {
        return lhs.id == rhs.id
    }
}
