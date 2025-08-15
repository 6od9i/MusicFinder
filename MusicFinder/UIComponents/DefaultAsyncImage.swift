//
//  DefaultAsyncImage.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import SwiftUI

struct DefaultAsyncImage: View {
    let path: String?
    
    var width: CGFloat?
    var height: CGFloat?
    var cornerRadius: CGFloat = 8
    
    var cache: ImageCache = DefaultImageCache.shared
    
    var body: some View {
        CachedAsyncImage(
            path: path,
            cache: cache,
            content: { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius)
                    .clipped()
            },
            placeholder: {
                Color.gray.opacity(0.1)
                    .frame(width: width, height: height)
                    .cornerRadius(cornerRadius)
            },
            failure: {
                Image(systemName: "person.crop.circle.badge.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .foregroundColor(.gray)
            }
        )
    }
}

#Preview {
    DefaultAsyncImage(path: ArtistsListModel.Artist.mock.thumbnail)
}
