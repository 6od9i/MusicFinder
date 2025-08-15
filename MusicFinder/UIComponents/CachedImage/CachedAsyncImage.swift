//
//  CachedAsyncImage.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View, Failure: View>: View {
    let url: URL?
    let cache: ImageCache
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    let failure: () -> Failure

    @State private var uiImage: UIImage?
    @State private var loadFailed = false
    
    init(
        path: String?,
        cache: ImageCache = DefaultImageCache.shared,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder failure: @escaping () -> Failure) {
            self.cache = cache
            self.content = content
            self.placeholder = placeholder
            self.failure = failure
            guard let path, let url = URL(string: path) else {
                loadFailed = true
                self.url = nil
                return
            }
            self.url = url
        }
    
    var body: some View {
        Group {
            if let uiImage {
                content(Image(uiImage: uiImage))
            } else if loadFailed {
                failure()
            } else {
                placeholder()
                    .onAppear(perform: loadImage)
            }
        }
    }

    private func loadImage() {
        guard let url else { return }
        if let cached = cache.image(for: url) {
            self.uiImage = cached
            return
        }
        
        Task {
            guard
                let (data, _) = try? await URLSession.shared.data(from: url),
                let image = UIImage(data: data) else {
                await MainActor.run {
                    loadFailed = true
                }
                return
            }
            cache.insertImage(image, for: url)
            await MainActor.run {
                uiImage = image
            }
        }
    }
}
