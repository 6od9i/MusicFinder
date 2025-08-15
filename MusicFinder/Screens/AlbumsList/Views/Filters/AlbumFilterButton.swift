//
//  AlbumFilterButton.swift
//  MusicFinder
//
//  Created by 6od9i on 12/08/25.
//

import SwiftUI

struct AlbumFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .foregroundColor(isSelected ? selectedTextColor : Color.primary)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? selectedBackgroundColor : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? selectedBackgroundColor : Color.gray.opacity(0.5), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var selectedBackgroundColor: Color {
        colorScheme == .dark ? Color.white : Color.black
    }

    private var selectedTextColor: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
}

// swiftlint:disable all
#Preview("No Selected") {
    AlbumFilterButton(title: "Button", isSelected: false, action: {})
}

#Preview("Selected") {
    AlbumFilterButton(title: "Button", isSelected: true, action: {})
}
