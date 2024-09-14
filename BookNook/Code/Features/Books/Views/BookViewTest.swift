//
//  BookViewTest.swift
//  BookNook
//
//  Created by Riley Jenum on 12/09/24.
//

import SwiftUI

struct BookViewTest: View {
    
    let cards = Array(1...200).map { "Card \($0)" }
    
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 40) {
                ForEach(cards.indices, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                                 startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(radius: 10)
                        Text(cards[index])
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(width: 200, height: 300)
                    .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1.3 : 0.75)
                            .blur(radius: phase.isIdentity ? 0 : 10)
                    }
                }
            }
            .scrollTargetLayout()
            .padding(.horizontal, UIScreen.main.bounds.width / 2 - 100)
        }
        .scrollTargetBehavior(.viewAligned)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BookViewTest()
    }
}
