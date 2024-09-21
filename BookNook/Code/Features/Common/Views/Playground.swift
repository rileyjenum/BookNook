//
//  Playground.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI

struct Playground: View {
    @State private var flipped = false
    
    var body: some View {
        ZStack {
            if flipped {
                Color.blue
                    .frame(width: 200, height: 200)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            } else {
                Color.red
                    .frame(width: 200, height: 200)
            }
        }
        .onTapGesture {
            withAnimation {
                flipped.toggle()
            }
        }
        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut, value: flipped)
    }
}

struct PlaygroundViewPreviews: PreviewProvider {
    static var previews: some View {
        Playground()
    }
}
