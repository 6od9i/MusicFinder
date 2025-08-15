//
//  ExpandableText.swift
//  MusicFinder
//
//  Created by 6od9i on 07/08/25.
//

import SwiftUI

struct ExpandableText: View {
    let text: String
    var lineLimit: Int = 3
    @State private var expanded = false
    
    @State private var shortSize: CGSize = .zero
    @State private var fullSize: CGSize = .zero
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .lineLimit(expanded ? nil : lineLimit)
            
            if shortSize.height < fullSize.height {
                ExpandButton(expanded: $expanded)
            }
        }
        .background(
            ZStack {
                Text(text)
                    .lineLimit(lineLimit)
                    .background(GeometryReader { geo in
                        Color.clear
                            .onAppear { shortSize = geo.size }
                            .onChange(of: geo.size) { size, _ in shortSize = size }
                    })
                
                Text(text)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(GeometryReader { geo in
                        Color.clear
                            .onAppear { fullSize = geo.size }
                            .onChange(of: geo.size) { size, _ in fullSize = size }
                    })
            }
                .hidden()
        )
    }
}

// swiftlint:disable all
#Preview("Long text") {
    ExpandableText(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum imperdiet mauris nisi, at luctus arcu sagittis ut. Morbi non dui lacus. Quisque venenatis facilisis est ut auctor. Phasellus rhoncus ut enim sed placerat. Phasellus euismod ante ac est ultrices varius in a est. Suspendisse pretium dolor tortor, ut dapibus tellus ultricies ut. Duis semper nibh vel augue mattis, vel dignissim ante eleifend. Mauris efficitur, diam quis vestibulum euismod, ante nulla rutrum lectus, eget mattis est nisl ut ante. Pellentesque vel tellus at erat consectetur rutrum. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed porta aliquet condimentum. Phasellus interdum, ligula vel auctor porttitor, risus risus rutrum quam, eu consequat ante nisl id sem.", lineLimit: 3)
}

#Preview("Short text") {
    ExpandableText(text: "Short text", lineLimit: 3)
}
