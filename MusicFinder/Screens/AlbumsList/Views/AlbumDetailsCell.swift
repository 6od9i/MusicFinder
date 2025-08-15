//
//  AlbumDetailsCell.swift
//  MusicFinder
//
//  Created by 6od9i on 11/08/25.
//

import SwiftUI

struct AlbumDetailsCell: View {
    let album: AlbumsListModel.Album
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            DefaultAsyncImage(path: album.coverImage ?? album.thumbnail ?? "", cornerRadius: 0)
                .scaledToFill()
                .frame(maxWidth: .infinity, minHeight: 250, maxHeight: 350)
                .clipped()
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.6), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 150)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(album.title ?? "Unknown Album")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                HStack(spacing: 12) {
                    if let year = album.year {
                        Label(String(year), systemImage: "calendar")
                    }
                    if let genre = album.genre?.first {
                        Label(genre, systemImage: "music.note")
                    }
                    if let label = album.label?.first {
                        Label(label, systemImage: "tag")
                    }
                }
                .font(.footnote)
                .foregroundColor(.white.opacity(0.85))
            }
            .padding()
        }
        .shadow(radius: 5)
    }
}

#Preview {
    AlbumDetailsCell(album: .mock())
}
