//
//  AlbumsFilters.swift
//  MusicFinder
//
//  Created by 6od9i on 11/08/25.
//

import SwiftUI

struct AlbumsFilters: View {
    @Binding var filters: AlbumsFiltersDTO
    
    @State private var showYearPicker = false
    @State private var showGenrePicker = false
    @State private var showLabelSheet = false
    @State private var showCustomGenreSheet = false
    
    @State private var tempLabelInput: String = ""
    @State private var tempYearInput: Int?
    @State private var tempGenreInput: AlbumGenre?
    @State private var customGenreInput: String = ""
    
    var body: some View {
        filtersList()
            .sheet(isPresented: $showLabelSheet) {
                FilterTextSheet(
                    text: $tempLabelInput,
                    isPresented: $showLabelSheet,
                    filterName: "label",
                    onApply: {
                        filters.label = tempLabelInput.isEmpty
                        ? nil
                        : tempLabelInput.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                )
            }
            .sheet(isPresented: $showCustomGenreSheet) {
                FilterTextSheet(
                    text: $customGenreInput,
                    isPresented: $showCustomGenreSheet,
                    filterName: "genre",
                    onApply: {
                        filters.genre = customGenreInput.isEmpty
                        ? nil
                        : customGenreInput.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                )
            }
            .pickerDialog(
                isPresented: $showYearPicker,
                title: "Select Year",
                options: Array(1500...2025).reversed(),
                selection: $tempYearInput,
                content: { year in
                    Text(String(year))
                },
                onCommit: {
                    filters.year = tempYearInput
                }
            )
            .pickerDialog(
                isPresented: $showGenrePicker,
                title: "Select Genre",
                options: AlbumGenre.allCases,
                selection: $tempGenreInput,
                content: { genre in
                    Text(genre.description)
                },
                onCommit: {
                    if case let .custom(genre) = tempGenreInput {
                        customGenreInput = genre
                        showCustomGenreSheet = true
                        return
                    }
                    filters.genre = tempGenreInput?.rawValue
                }
            )
    }
    
    @ViewBuilder
    func filtersList() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                AlbumFilterButton(
                    title: "Year: \(filters.year.map(String.init) ?? "All")",
                    isSelected: showYearPicker) {
                        tempYearInput = filters.year
                        showYearPicker.toggle()
                    }
                AlbumFilterButton(title: "Genre: \(filters.genre ?? "All")", isSelected: showGenrePicker) {
                    tempGenreInput = filters.genreValue
                    showGenrePicker.toggle()
                }
                AlbumFilterButton(title: "Label: \(filters.label ?? "All")", isSelected: showLabelSheet) {
                    tempLabelInput = filters.label ?? ""
                    showLabelSheet.toggle()
                }
            }
            .frame(minWidth: UIScreen.main.bounds.width)
            .padding(.vertical, 8)
        }
        .background(.ultraThinMaterial)
    }
}

// swiftlint:disable all
#Preview {
    AlbumsFilters(filters: .constant(AlbumsFiltersDTO(year: 1900,
                                                      genre: "Genre",
                                                      label: "Label")))
}

#Preview {
    AlbumsFilters(filters: .constant(AlbumsFiltersDTO()))
}
