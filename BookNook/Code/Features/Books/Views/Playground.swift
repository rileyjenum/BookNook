//
//  Playground.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI

struct Playground: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Rotated Textaadfadfadfaasdf")
                .rotationEffect(.degrees(90))
                .frame(width: 200, height: 40)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil) // Allows unlimited lines for wrapping
                .minimumScaleFactor(0.5) // Scales down the text if needed
                .allowsTightening(true) // Allows the text to be tighter if needed
            Spacer()
        }
        .frame(width: 40, height: 200)
        .background(Color.gray)
    }
}

struct MyView: View {
    var body: some View {
        Playground()
    }
}

#Preview {
    MyView()
}
