//
//  FilterTextSheet.swift
//  MusicFinder
//
//  Created by 6od9i on 12/08/25.
//

import SwiftUI

struct FilterTextSheet: View {
    @Binding var text: String
    @Binding var isPresented: Bool
    var filterName: String
    var onApply: () -> Void
    @FocusState private var textViewFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter \(filterName)")) {
                    TextField("\(filterName.capitalized) name", text: $text)
                        .focused($textViewFocused)
                        .autocorrectionDisabled()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        onApply()
                        isPresented = false
                    }
                }
            }
            .navigationTitle("Filter by \(filterName.capitalized)")
            .onAppear {
                textViewFocused = true
            }
        }
    }
}

// swiftlint:disable all
#Preview {
    FilterTextSheet(text: .constant("name"), isPresented: .constant(true),
                    filterName: "Genre", onApply: {})
}
