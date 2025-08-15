//
//  ArtistDetails.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import SwiftUI

struct ArtistDetails: View {
    @StateObject var viewModel: ArtistDetailsVM
    
    @Environment(\.horizontalSizeClass)
    var sizeClass
    @Environment(\.presentationMode)
    var presentationMode: Binding<PresentationMode>
    
    @State private var expandedMembers = false
    
    var body: some View {
        ScrollView {
            if let details = viewModel.details {
                detailsView(details)
            } else {
                loadingView.padding()
            }
        }
        .onAppear {
            viewModel.loadArtistDetails()
        }
        .refreshable {
            viewModel.loadArtistDetails()
        }
        .navigationTitle(
            viewModel.details == nil
            ? viewModel.artist.name
            : ((viewModel.details?.isBand ?? false) ? "Band" : "Artist")
        )
    }
    
    @ViewBuilder
    private func detailsView(_ details: ArtistDetailsModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            ArtistDetailsHeader(details: details)
            if let profile = details.profile {
                profileInfoView(profile)
            }
            albumsView
            if let members = details.sortedMembers, !members.isEmpty {
                memebersList(members)
            } else if let groups = details.sortedGroups, !groups.isEmpty {
                groupsList(groups)
            }
        }
        .padding(.horizontal)
    }
    
    var albumsView: some View {
        VStack {
            HStack {
                Text("Albums:")
                    .font(.title3.bold())
                Spacer()
                
                if viewModel.isAlbumsLoading {
                    ProgressView()
                } else {
                    Button(action: {
                        viewModel.showAlbums()
                    }, label: {
                        HStack {
                            Text("Show All")
                                .font(.subheadline)
                            Image(systemName: "chevron.forward")
                        }
                        .padding(.horizontal)
                        .foregroundColor(.primary)
                    })
                }
            }
            if viewModel.recentAlbums.isEmpty == false {
                ForEach(viewModel.recentAlbums) { item in
                    AlbumCell(album: item)
                }
            }
        }
    }
    
    @ViewBuilder
    private func memebersList(_ members: [ArtistDetailsModel.Artist]) -> some View {
        ExpandableList(title: "Band Members", items: members) { member in
            ImageTitleListCell(item: member) {
                viewModel.didSelect(member)
            }
        }
    }
    
    @ViewBuilder
    private func groupsList(_ groups: [ArtistDetailsModel.Group]) -> some View {
        ExpandableList(title: "Groups", items: groups) { group in
            // TODO: customize group cell with group design
            ImageTitleListCell(item: group) {
                viewModel.didSelect(group)
            }
        }
    }
    
    @ViewBuilder
    private func profileInfoView(_ profile: String) -> some View {
        Group {
            Text("Info:")
                .font(.headline)
            ExpandableText(text: profile)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var loadingView: some View {
        let thumbSize: CGFloat = (sizeClass == .compact) ? 80 : 120
        return HStack {
            DefaultAsyncImage(
                path: viewModel.artist.thumbnail,
                width: thumbSize, height: thumbSize
            )
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                Text("Loading...")
                    .font(.subheadline)
                    .padding()
                ProgressView().padding()
            }
            Spacer()
        }
    }
}

extension ArtistDetailsModel.Artist: ImageTitleCellItem {}
extension ArtistDetailsModel.Group: ImageTitleCellItem {}

// swiftlint:disable all
#Preview("Detailed No list") {
    ArtistDetails(viewModel: ArtistDetailsVM.mock(details: .mock(members: nil, groups: nil)))
}

#Preview("Detailed No Members") {
    ArtistDetails(viewModel: ArtistDetailsVM.mock(details: .mock(members: nil)))
}

#Preview("Detailed many Members") {
    ArtistDetails(viewModel: ArtistDetailsVM.mock(details: .mock(
        profile: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum imperdiet mauris nisi, at luctus arcu sagittis ut. Morbi non dui lacus. Quisque venenatis facilisis est ut auctor. Phasellus rhoncus ut enim sed placerat. Phasellus euismod ante ac est ultrices varius in a est. Suspendisse pretium dolor tortor, ut dapibus tellus ultricies ut. Duis semper nibh vel augue mattis, vel dignissim ante eleifend. Mauris efficitur, diam quis vestibulum euismod, ante nulla rutrum lectus, eget mattis est nisl ut ante. Pellentesque vel tellus at erat consectetur rutrum. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed porta aliquet condimentum. Phasellus interdum, ligula vel auctor porttitor, risus risus rutrum quam, eu consequat ante nisl id sem.",
        members: [.mock, .mock, .mock, .mock, .mock, .mock, .mock]
    )))
}

#Preview("Detailed many Groups") {
    ArtistDetails(viewModel: ArtistDetailsVM.mock(details: .mock(
        profile: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum imperdiet mauris nisi, at luctus arcu sagittis ut. Morbi non dui lacus. Quisque venenatis facilisis est ut auctor. Phasellus rhoncus ut enim sed placerat. Phasellus euismod ante ac est ultrices varius in a est. Suspendisse pretium dolor tortor, ut dapibus tellus ultricies ut. Duis semper nibh vel augue mattis, vel dignissim ante eleifend. Mauris efficitur, diam quis vestibulum euismod, ante nulla rutrum lectus, eget mattis est nisl ut ante. Pellentesque vel tellus at erat consectetur rutrum. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed porta aliquet condimentum. Phasellus interdum, ligula vel auctor porttitor, risus risus rutrum quam, eu consequat ante nisl id sem.",
        members: nil, groups: [.mock, .mock, .mock, .mock, .mock, .mock]
    )))
}

#Preview("No Image") {
    ArtistDetails(viewModel: ArtistDetailsVM.mock(details: ArtistDetailsModel.mock(images: nil)))
}

#Preview("Empty") {
    ArtistDetails(viewModel: ArtistDetailsVM.mock())
}

#Preview("Loading details Error") {
    ArtistDetails(viewModel: ArtistDetailsVM.mock(detailsSource: ArtistDetailsRepository(requestsService: RequestsServiceMock(error: RequestsError.invalidURL))))
}
