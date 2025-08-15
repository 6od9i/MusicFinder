//
//  ExpandableList.swift
//  MusicFinder
//
//  Created by 6od9i on 08/08/25.
//

import SwiftUI

struct ExpandableList<Data: Identifiable, Content: View>: View {
    let title: String?
    let items: [Data]
    var limit: Int = 3
    
    @ViewBuilder let content: (Data) -> Content
    
    @State private var expanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if let title {
                Text(title)
                    .font(.title3.bold())
            }
            
            ForEach(displayedItems) { item in
                content(item)
            }
            
            if items.count > limit {
                ExpandButton(expanded: $expanded)
            }
        }
    }
    
    private var displayedItems: [Data] {
        expanded ? items : Array(items.prefix(limit))
    }
}

// swiftlint:disable all
#Preview("Long") {
    ExpandableList(
        title: "Some title:",
        items: [
            ArtistDetailsModel.Artist.mock,
            ArtistDetailsModel.Artist.mock,
            ArtistDetailsModel.Artist.mock,
            ArtistDetailsModel.Artist.mock,
            ArtistDetailsModel.Artist.mock,
            ArtistDetailsModel.Artist.mock],
        limit: 3) {
            ImageTitleListCell(item: $0)
    }
}

#Preview("Short") {
    ExpandableList(
        title: "Some title:",
        items: [
            ArtistDetailsModel.Artist.mock,
            ArtistDetailsModel.Artist.mock],
        limit: 3) {
            ImageTitleListCell(item: $0)
    }
}
