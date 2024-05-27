//
//  BookshelfView.swift
//  BookNook
//
//  Created by Riley Jenum on 26/05/24.
//

import SwiftUI

struct BookshelfView: View {
    @State private var selectedBookIndex: Int? = nil
    @State private var bookColors: [Color] = (0..<20).map { _ in Color.random }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(0..<20, id: \.self) { index in
                                GeometryReader { itemGeometry in
                                    let midX = geometry.frame(in: .global).midX
                                    let itemMidX = itemGeometry.frame(in: .global).midX
                                    let distance = abs(midX - itemMidX)
                                    let maxDistance = midX
                                    let curveFactor = max(0, 100 * cos((distance / maxDistance) * .pi / 2))
                                    let opacity = max(0.2, 1 - distance / maxDistance)

                                    BookSpine(
                                        spineColor: bookColors[index],
                                        coverColor: bookColors[index].opacity(0.8),
                                        isSelected: selectedBookIndex == index,
                                        opacity: opacity
                                    )
                                    .offset(y: selectedBookIndex == index ? -250 : -curveFactor)
                                    .id(index)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            if selectedBookIndex == index {
                                                selectedBookIndex = nil
                                            } else {
                                                selectedBookIndex = index
                                                scrollViewProxy.scrollTo(index, anchor: .center)
                                            }
                                        }
                                    }
                                }
                                .frame(width: selectedBookIndex == index ? 100 : 40, height: 200)
                            }
                        }
                        .padding(.horizontal, geometry.size.width / 2)  // Adjust padding to allow centering of edge items
                        .padding(.top, 300)
                    }
                }
            }
            .frame(height: 300)
            .contentShape(Rectangle())  // Make the entire area respond to gestures
            .simultaneousGesture(
                DragGesture()
                    .onChanged { _ in
                        if selectedBookIndex != nil {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                selectedBookIndex = nil
                            }
                        }
                    }
            )
        }
    }
}

struct BookSpine: View {
    let spineColor: Color
    let coverColor: Color
    let isSelected: Bool
    let opacity: Double

    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(isSelected ? coverColor : spineColor)
            .frame(width: isSelected ? 100 : 40, height: 180)
            .opacity(opacity)
            .offset(x: isSelected ? 0 : 0, y: 0)
            .scaleEffect(isSelected ? 1 : 1)
            .zIndex(isSelected ? 1 : 0)
            .animation(.easeInOut(duration: 0.5), value: isSelected)
    }
}

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}

struct BookshelfView_Previews: PreviewProvider {
    static var previews: some View {
        BookshelfView()
    }
}
