//
//  BookViewTest.swift
//  BookNook
//
//  Created by Riley Jenum on 12/09/24.
//

import SwiftUI

struct BookViewTest: View {
    // Example data set for the cards
    let cards = Array(1...200).map { "Card \($0)" }
    
    // State to track the index of the currently centered card
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 170) {
                    ForEach(cards.indices, id: \.self) { index in
                        CardView(title: cards[index])
                            .scaleEffectEffectOnScroll(index: index, selectedIndex: selectedIndex)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, dynamicPadding(for: selectedIndex))
                .onAppear {
                    scrollProxy.scrollTo(selectedIndex, anchor: .center)
                }
                .onChange(of: selectedIndex) { newValue in
                    scrollProxy.scrollTo(newValue, anchor: .center)
                }
            }
            .scrollTargetBehavior(.viewAligned)

        }
    }
    
    // Dynamic padding to center the first card
    private func dynamicPadding(for index: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (index == 0) ? (screenWidth / 2 - 100) : 70 // Adjust this 100 value as per card width/spacing
    }
}

struct CardView: View {
    let title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]),
                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(radius: 10)
            
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
        }
        .frame(width: 200, height: 300)
    }
}

// Custom modifier to scale the card view depending on its position in the scroll view
struct ScaleEffectOnScroll: ViewModifier {
    var index: Int
    var selectedIndex: Int
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            let scale = calculateScale(geometry: geometry)
            content
                .scaleEffect(x: scale, y: scale)
                .opacity(Double(scale))
                .animation(.easeInOut, value: selectedIndex)
        }
    }
    
    // Calculate the scale based on the position of the card relative to the center of the screen
    private func calculateScale(geometry: GeometryProxy) -> CGFloat {
        let midX = geometry.frame(in: .global).midX
        let screenWidth = UIScreen.main.bounds.width
        let centerX = screenWidth / 4
        
        // Adjust scaling more precisely by considering the distance to the exact center of the screen
        let distanceToCenter = abs(centerX - midX)
        
        // Adjust 150 to control how far items can be before they start scaling down
        let scale = max(0.6, 1 - (distanceToCenter / 250))
        
        return scale
    }
}

extension View {
    func scaleEffectEffectOnScroll(index: Int, selectedIndex: Int) -> some View {
        self.modifier(ScaleEffectOnScroll(index: index, selectedIndex: selectedIndex))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BookViewTest()
    }
}
