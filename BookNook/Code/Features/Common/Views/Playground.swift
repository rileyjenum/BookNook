//
//  Playground.swift
//  BookNook
//
//  Created by Riley Jenum on 13/07/24.
//

import SwiftUI

struct Playground: View {
    @State var animated = false

    var body: some View {
        VStack {
            Text("Hello world")
                .offset(x: animated ? 200 : 0)
                .animation(.easeInOut)
            
            
            Text("Fat")
                .offset(x: animated ? 200 : 0)
        }
    }
}

struct PlaygroundViewPreviews: PreviewProvider {
    static var previews: some View {
        Playground()
    }
}
