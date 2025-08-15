//
//  EmptyListInfo.swift
//  MusicFinder
//
//  Created by 6od9i on 06/08/25.
//

import SwiftUI

struct EmptyListInfo: View {
    let text: String
    var color: Color = .gray
    
    var body: some View {
        Spacer()
        Text(text)
            .foregroundColor(color)
            .multilineTextAlignment(.center)
            .padding()
        Spacer()
        Spacer()
    }
}

#Preview {
    EmptyListInfo(text: "Some info")
}
