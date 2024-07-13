//
//  Playground.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI

struct Playground: View {
    @State var bookColor: Color = .blue
    let bookHeightArray: [Double]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: -65) {
                ForEach(bookHeightArray, id: \.self) { height in
                    TestView(bookColor: $bookColor, bookHeight: height) // Pass each height value here
                }
            }
            .frame(height: 600)
        }
    }
}

struct MyView: View {
    var body: some View {
        Playground(bookHeightArray: [200, 100, 150])
    }
}

#Preview {
    MyView()
}
