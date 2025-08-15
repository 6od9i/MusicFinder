//
//  ImageTitleListCell.swift
//  MusicFinder
//
//  Created by 6od9i on 06/08/25.
//

import SwiftUI

struct ImageTitleListCell: View {
    let item: any ImageTitleCellItem
    var onTap: (() -> Void)?
    
    @Environment(\.horizontalSizeClass)
    var sizeClass
    
    var body: some View {
        let imageSize: CGFloat = (sizeClass == .compact) ? 50 : 80
        Button(action: {
            onTap?()
        }, label: {
            HStack {
                DefaultAsyncImage(path: item.thumbnail, width: imageSize, height: imageSize)
                
                Text(item.name)
                    .font(.headline)
                    .padding(.leading, 8)
            }
            .padding(.vertical, 4)
        })
        .foregroundColor(.primary)
    }
}

#Preview {
    ImageTitleListCell(item: ArtistsListModel.Artist.mock)
}

protocol ImageTitleCellItem: Identifiable {
    var name: String { get }
    var thumbnail: String? { get }
}
