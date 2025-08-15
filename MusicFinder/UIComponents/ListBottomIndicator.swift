//
//  ListBottomIndicator.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import SwiftUI

struct ListBottomIndicator<T: Identifiable, Row: View>: View {
    let items: [T]
    let isLoading: Bool
    let rowContent: (T) -> Row
    
    var body: some View {
        List {
            ForEach(items) { item in
                rowContent(item)
            }
            
            if isLoading {
                scrollLoadingIndicator
                .listRowSeparator(.hidden)
                .id((UUID()))
            }
        }
        .listStyle(.plain)
    }
    
    var scrollLoadingIndicator: some View {
        HStack {
            Spacer()
            ProgressView().padding()
            Spacer()
        }
    }
}

#Preview {
    ListBottomIndicator(items: [ArtistsListModel.Artist.mock], isLoading: true) {
        ImageTitleListCell(item: $0)
    }
}
