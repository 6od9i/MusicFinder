//
//  ExpandButton.swift
//  MusicFinder
//
//  Created by 6od9i on 08/08/25.
//

import SwiftUI

struct ExpandButton: View {
    @Binding var expanded: Bool
    
    var body: some View {
        Button(expanded ? "Show Less" : "Show More") {
            expanded.toggle()
        }
        .font(.caption)
        .foregroundColor(.gray)
    }
}

// swiftlint:disable all
#Preview("constricted") {
    ExpandButton(expanded: .constant(false))
}

#Preview("expanded") {
    ExpandButton(expanded: .constant(true))
}
