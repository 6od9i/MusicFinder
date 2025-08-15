//
//  ArtistDetailsVMTests.swift
//  MusicFinderTests
//
//  Created by 6od9i on 14/08/25.
//

import Foundation
import Testing
import Combine
@testable import MusicFinder

struct ArtistDetailsVMTests {
    @Test func testLoadArtistDetailsSuccess() async throws {
        // Arrange
        let details = ArtistDetailsModel.mock()
        let recentAlbums: [RecentAlbumsModel.Release] = [.mock()]
        let output = ArtistDetailsOutputSpy()
        let source = ArtistDetailsSourceMock(
            albums: recentAlbums, details: details
        )

        let vm = ArtistDetailsVM(artist: ArtistsListModel.Artist.mock, detailsSource: source, output: output)
        var cancellable: AnyCancellable?
        
        // Act
        await withCheckedContinuation { continuation in
            cancellable = Publishers.CombineLatest(vm.$isLoading, vm.$isAlbumsLoading)
                .dropFirst()
                .sink { isLoading, isAlbumsLoading in
                    if isLoading == false && isAlbumsLoading == false {
                        continuation.resume()
                    }
                }
            vm.loadArtistDetails()
        }
        _ = cancellable
        
        // Assert
        assert(vm.details != nil, "VM should load details successfully")
        assert(vm.isLoading == false, "VM should stop loading")
        assert(vm.recentAlbums == recentAlbums, "VM should load recent albums")
        assert(vm.isAlbumsLoading == false, "Albums loading flag should be false")
        assert(vm.errorMessage == nil, "Error message should be nil on success")
    }
    
    @Test func testLoadArtistDetailsFailure() async throws {
        // Arrange
        let error = RequestsError.decodingFailed
        let output = ArtistDetailsOutputSpy()
        let source = ArtistDetailsSourceMock(artistError: error, albums: [.mock()])

        let vm = ArtistDetailsVM(artist: ArtistsListModel.Artist.mock, detailsSource: source, output: output)
        var cancellable: AnyCancellable?

        // Act
        await withCheckedContinuation { continuation in
            cancellable = vm.$isLoading
                .dropFirst()
                .sink { isLoading in
                    if isLoading == false {
                        continuation.resume()
                    }
                }
            vm.loadArtistDetails()
        }
        _ = cancellable

        // Assert
        assert(vm.details == nil, "VM should not load details on failure")
        assert(vm.recentAlbums.isEmpty, "VM should not load albums when details request failed")
        assert(vm.isLoading == false, "VM should stop loading")
        assert(vm.recentAlbums.isEmpty, "No recent albums should be loaded")
        assert(vm.isAlbumsLoading == true, "Albums loading flag stays true if details fail")
        assert(vm.errorMessage != nil, "Error message should be set on failure")
    }
    
    @Test func testLoadRecentAlbumsFailure() async throws {
        // Arrange
        let details = ArtistDetailsModel.mock()
        let error = RequestsError.decodingFailed
        let output = ArtistDetailsOutputSpy()
        let source = ArtistDetailsSourceMock(albumsError: error, details: details)

        let vm = ArtistDetailsVM(artist: ArtistsListModel.Artist.mock, detailsSource: source, output: output)
        var cancellable: AnyCancellable?

        // Act
        await withCheckedContinuation { continuation in
            cancellable = Publishers.CombineLatest(vm.$isLoading, vm.$isAlbumsLoading)
                .dropFirst()
                .sink { isLoading, isAlbumsLoading in
                    if isLoading == false && isAlbumsLoading == false {
                        continuation.resume()
                    }
                }
            vm.loadArtistDetails()
        }
        _ = cancellable

        // Assert
        assert(vm.details != nil, "VM should load details successfully")
        assert(vm.recentAlbums.isEmpty, "No recent albums should be loaded on error")
        assert(vm.isAlbumsLoading == false, "Albums loading flag should be false after failure")
        assert(vm.errorMessage == nil, "Error message should be nil because details loaded successfully")
    }
    
    @Test func testShowAlbums() {
        // Arrange
        let output = ArtistDetailsOutputSpy()
        let source = ArtistDetailsSourceMock(details: ArtistDetailsModel.mock())
        let vm = ArtistDetailsVM(artist: ArtistsListModel.Artist.mock, detailsSource: source, output: output)

        // Act
        vm.showAlbums()

        // Assert
        assert(output.shownArtist?.id == vm.artist.id, "Output should show albums for the correct artist")
    }
    
    @Test func testDidSelectMemberAndGroup() {
        // Arrange
        let output = ArtistDetailsOutputSpy()
        let source = ArtistDetailsSourceMock(details: ArtistDetailsModel.mock())
        let vm = ArtistDetailsVM(artist: ArtistsListModel.Artist.mock, detailsSource: source, output: output)

        let member = ArtistDetailsModel.Artist.mock

        // Act
        vm.didSelect(member)

        // Assert
        assert(output.shownArtist?.id == member.id, "Output should show selected member")
        
        // Arrange
        let group = ArtistDetailsModel.Group.mock
        
        // Act
        vm.didSelect(group)
        
        // Assert
        assert(output.shownArtist?.id == group.id, "Output should show selected group")
    }
}

final class ArtistDetailsOutputSpy: ArtistDetailsOutput {
    var shownArtist: ArtistInfo?
    
    func showAlbums(for artist: ArtistInfo) {
        shownArtist = artist
    }
    
    func showArtisDetails(_ artist: ArtistInfo) {
        shownArtist = artist
    }
}

extension RecentAlbumsModel.Release: @retroactive Equatable {
    public static func == (lhs: RecentAlbumsModel.Release, rhs: RecentAlbumsModel.Release) -> Bool {
        lhs.id == rhs.id
    }
}
