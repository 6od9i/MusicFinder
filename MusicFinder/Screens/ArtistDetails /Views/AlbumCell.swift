//
//  AlbumCell.swift
//  MusicFinder
//
//  Created by 6od9i on 10/08/25.
//

import SwiftUI

struct AlbumCell: View {
    let album: RecentAlbumsModel.Release
    
    @Environment(\.horizontalSizeClass)
    var sizeClass
    
    var body: some View {
        let imageSize: CGFloat = (sizeClass == .compact) ? 50 : 80
        HStack(spacing: 12) {
            DefaultAsyncImage(
                path: album.thumbnail,
                width: imageSize,
                height: imageSize)
            .cornerRadius(8)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(album.title)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack {
                    if let year = album.year {
                        Text(String(year))
                    }
                    
                    Text(album.type.capitalized)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    AlbumCell(album: RecentAlbumsModel.Release.mock())
}
