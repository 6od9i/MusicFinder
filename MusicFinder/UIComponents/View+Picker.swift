//
//  View+Picker.swift
//  MusicFinder
//
//  Created by 6od9i on 12/08/25.
//

import SwiftUI

extension View {
    func pickerDialog<T: Hashable, Content: View>(
        isPresented: Binding<Bool>,
        title: String,
        options: [T],
        selection: Binding<T?>,
        @ViewBuilder content: @escaping (T) -> Content,
        onCommit: @escaping () -> Void
    ) -> some View {
        self.sheet(isPresented: isPresented) {
            PickerDialog(
                isPresented: isPresented,
                title: title,
                options: options,
                selection: selection,
                onCommit: onCommit,
                contentBuilder: content)
        }
    }
}

struct PickerDialog<T: Hashable, Content: View>: View {
    @Binding var isPresented: Bool
    let title: String
    let options: [T]
    @Binding var selection: T?
    let onCommit: () -> Void
    let contentBuilder: (T) -> Content
    
    @State private var contentHeight: CGFloat = 300
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                Spacer()
                Text(title)
                    .font(.headline)
                Spacer()
                Button("Apply") {
                    isPresented = false
                    onCommit()
                }
            }
            .padding()
            
            Divider()
            Picker(selection: $selection) {
                Text("All").tag(nil as T?)
                ForEach(options, id: \.self) { option in
                    contentBuilder(option)
                        .tag(Optional(option))
                }
            } label: {
                Text(title)
            }
            .pickerStyle(WheelPickerStyle())
        }
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        contentHeight = proxy.size.height
                    }
                    .onChange(of: proxy.size.height) { _, newHeight in
                        contentHeight = newHeight
                    }
            }
        )
        .presentationDetents([.height(contentHeight)])
    }
}
