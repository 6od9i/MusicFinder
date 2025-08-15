//
//  ArtistDetailsHeader.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import SwiftUI

struct ArtistDetailsHeader: View {
    let details: ArtistDetailsModel
    @Environment(\.horizontalSizeClass)
    var sizeClass
    
    @State private var expanded = false
    
    var body: some View {
        let imageSize: CGFloat = (sizeClass == .compact) ? 120 : 180
        
        HStack {
            DefaultAsyncImage(
                path: details.image,
                width: imageSize,
                height: imageSize)
            .containerRelativeFrame(.horizontal, alignment: .leading) { size, _ in
                size * 0.25
            }
            VStack(alignment: .leading, spacing: 12) {
                Text(details.name)
                    .font(.largeTitle.bold())
                
                if let realName = details.realname {
                    Text("Real Name: \(realName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.leading)
            Spacer()
        }
    }
}

// swiftlint:disable all
#Preview("Default") {
    ArtistDetailsHeader(details: .mock())
}

#Preview("No Icon") {
    ArtistDetailsHeader(details: .mock(images: nil))
}
