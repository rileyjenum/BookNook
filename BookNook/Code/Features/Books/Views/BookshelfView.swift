//
//  BookshelfView.swift
//  BookNook
//
//  Created by Riley Jenum on 26/05/24.
//

import SwiftUI
import SwiftData

struct BookshelfView: View {
    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]
    @Query(sort: [SortDescriptor(\ReadingSession.startTime)]) var sessions: [ReadingSession]
    
    @Environment(\.modelContext) var context
    
    @StateObject private var viewModel = BookViewModel()
    
    @State private var selectedBookIndex: Int? = nil
    @State private var addNewBookShowing: Bool = false
    @State private var selectedBook: Book?
    @State private var isEditingBook = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(books.indices, id: \.self) { index in
                                bookSpineView(geometry: geometry, scrollViewProxy: scrollViewProxy, index: index)
                                    .frame(width: selectedBookIndex == index ? 150 : 40, height: 200)
                                    .rotation3DEffect(
                                        .degrees(selectedBookIndex == index ? rotationAngle : 0),
                                        axis: (x: 0, y: 1, z: 0)
                                    )
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            if selectedBookIndex == index {
                                                selectedBookIndex = nil
                                                rotationAngle = 0
                                            } else {
                                                selectedBookIndex = index
                                                scrollViewProxy.scrollTo(index, anchor: .center)
                                                rotationAngle = 180
                                            }
                                        }
                                    }
                            }
                        }
                        .frame(height: 500) // Ensures the HStack height is sufficient
                        .padding(.horizontal, (geometry.size.width - (selectedBookIndex == nil ? 40 : 150)) / 2)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture()
                    .onChanged { _ in
                        if selectedBookIndex != nil {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                selectedBookIndex = nil
                                rotationAngle = 0
                            }
                        }
                    }
            )
        }
    }
    
    private func bookSpineView(geometry: GeometryProxy, scrollViewProxy: ScrollViewProxy, index: Int) -> some View {
        GeometryReader { itemGeometry in
            let midX = geometry.frame(in: .global).midX
            let itemMidX = itemGeometry.frame(in: .global).midX
            let distance = abs(midX - itemMidX)
            let maxDistance = midX
            let curveFactor = max(0, 100 * cos((distance / maxDistance) * .pi / 2))
            let opacity = max(0.2, 1 - distance / maxDistance)
            
            ZStack {
                if selectedBookIndex == index, let selectedBook = books[safe: index] {
                    BookCoverView(book: selectedBook)
                        .opacity(rotationAngle == 180 ? 1 : 0) // Show cover when rotated
                        .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                selectedBookIndex = nil
                                rotationAngle = 0
                            }
                        }
                } else {
                    BookSpine(
                        spineColor: .beige,
                        coverColor: .beige.opacity(0.8),
                        isSelected: selectedBookIndex == index,
                        opacity: opacity,
                        title: books[index].title
                    )
                    .opacity(rotationAngle == 0 ? 1 : 0) // Show spine when not rotated
                    .rotation3DEffect(.degrees(rotationAngle), axis: (x: 0, y: 1, z: 0))
                }
            }
            .frame(height: 200) // Adjust the frame height as needed
        }
    }
}

struct BookSpine: View {
    let spineColor: Color
    let coverColor: Color
    let isSelected: Bool
    let opacity: Double
    let title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(spineColor)
                .frame(width: 40, height: 180)
//                .opacity(opacity)
                .zIndex(isSelected ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isSelected)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .frame(width: 180, height: 40)
                .rotationEffect(.degrees(90))
                .multilineTextAlignment(.center)
                .scaleEffect(isSelected ? 1 : 1)
                .zIndex(isSelected ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isSelected)
                .lineLimit(nil) // Allow unlimited lines
                .allowsTightening(true) // Allows text to tighten to fit the frame
        }
    }
}

extension Color {
    static let beige = Color(red: 200 / 255, green: 200 / 255, blue: 180 / 255)
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct BookshelfView_Previews: PreviewProvider {
    static var previews: some View {
        BookshelfView()
    }
}
